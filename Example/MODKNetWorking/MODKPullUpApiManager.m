//
//  MODKPullUpApiManager.m
//  MODKPet
//
//  Created by 意想不到 on 2018/7/27.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "MODKPullUpApiManager.h"

@interface MODKPullUpApiManager ()

@property (nonatomic, assign) NSInteger priCurrentPage;

@end

@implementation MODKPullUpApiManager

- (NSURLSessionDataTask *)loadData {
    _refreshType = MODKPullUpApiManagerRefreshTypeNormal;
    _priCurrentPage = 1;
    return [super loadData];
}

- (void)downRefresh {
    _priCurrentPage = 1;
    _refreshType = MODKPullUpApiManagerRefreshTypePullDown;
    [super loadData];
}

- (void)loadNextPage {
    _refreshType = MODKPullUpApiManagerRefreshTypePullUp;
    [super loadData];
}

- (NSInteger)currentPage {
    return self.priCurrentPage;
}

- (NSDictionary *)commonParamsDict {
    NSMutableDictionary *dict = [[super commonParamsDict] mutableCopy];
    dict[[self pageKey]] = @(_priCurrentPage);
    dict[[self rowKey]] = @([self rowCount]);
    return [dict copy];
}

- (NSString *)pageKey {
    return @"pageNo";
}

- (NSString *)rowKey {
    return @"rows";
}

- (NSInteger)rowCount {
    return 30;
}

- (void)beforePerformSuccessWithResponseObject:(id)responseObject {
    [super beforePerformSuccessWithResponseObject:responseObject];
    id data = responseObject[@"data"];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)data;
        if (array.count != 0) {
            _priCurrentPage ++;
        }
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        if (dict.allKeys != 0) {
            _priCurrentPage ++;
        }
    }
}

@end
