//
//  MODKApiProxy.h
//  ssda
//
//  Created by 意想不到 on 2018/7/23.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MODKAPIConfig.h"

// 实际发送网络请求类

@interface MODKApiProxy : NSObject

@property (nonatomic, strong, readonly) NSString *baseUrl;

@property (nonatomic, assign) NSInteger currentNetStatus; // 当前网络状态 AFNetworkReachabilityStatusUnknown          = -1,
//AFNetworkReachabilityStatusNotReachable     = 0,
//AFNetworkReachabilityStatusReachableViaWWAN = 1,
//AFNetworkReachabilityStatusReachableViaWiFi = 2,

+ (instancetype)sharedInstance;

- (void)config:(MODKEnvironmentType)type;

- (void)monitNetwork; // 监听网络

- (void)cancelAllRequest;

- (NSURLSessionDataTask *)GET:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;

- (NSURLSessionDataTask *)POST:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;

- (NSURLSessionDataTask *)JSONPost:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;




@end
