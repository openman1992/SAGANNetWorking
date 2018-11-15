//
//  MODKPullUpApiManager.h
//  MODKPet
//
//  Created by 意想不到 on 2018/7/27.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "YourNameApiManager.h"

typedef NS_ENUM (NSUInteger, MODKPullUpApiManagerRefreshType){
    MODKPullUpApiManagerRefreshTypeNormal = 0, // 正常
    MODKPullUpApiManagerRefreshTypePullDown = 1, // 下拉刷新
    MODKPullUpApiManagerRefreshTypePullUp = 2,  // 上拉加载
};

// 下拉刷新和上啦加载的 

@interface MODKPullUpApiManager :YourNameApiManager

@property (nonatomic, assign ,readonly) NSInteger currentPage;

@property (nonatomic, assign)  MODKPullUpApiManagerRefreshType refreshType;

- (void)loadNextPage;

- (void)downRefresh;

// overoid methods
- (NSString *)pageKey; // 默认string pageNo

- (NSString *)rowKey; // 默认string  rows

- (NSInteger)rowCount; // 默认30条

@end
