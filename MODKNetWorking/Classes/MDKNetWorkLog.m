//
//  MDKNetWorkLog.m
//  MODKPet
//
//  Created by 意想不到 on 2018/10/10.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "MDKNetWorkLog.h"

@interface MDKNetWorkLog ()

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSData *responseObject;

@end

@implementation MDKNetWorkLog

- (instancetype)initWithResponse:(NSURLResponse *)response responseObject:(NSData *)responseObject {
    self = [super init];
    if (self) {
        _response = response;
        _responseObject = responseObject;
    }
    return self;
}

- (void)show {
    
#ifdef DEBUG
    NSHTTPURLResponse *httpResponse = nil;
    if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *)_response;
    }
    NSString *datastr = [[NSString alloc]initWithData:_responseObject encoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"\n\nMDKNet:%@_______code:%ld__________data:%@\n\n",httpResponse.URL,httpResponse.statusCode,datastr];
    NSLog(@"%@", str);
#else
    
#endif
    
}

@end
