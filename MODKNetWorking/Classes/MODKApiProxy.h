//
//  MODKApiProxy.h
//  ssda
//
//  Created by 意想不到 on 2018/7/23.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MODKAPIServicer.h"

// 实际发送网络请求类

@interface MODKApiProxy : NSObject

@property (nonatomic, strong, readonly) MODKAPIServicer *apiServicer;

+ (instancetype)sharedInstance;

- (void)config:(MODKAPIServicer *)service;

- (void)cancelAllRequest;

- (NSURLSessionDataTask *)GET:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;

- (NSURLSessionDataTask *)POST:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;

- (NSURLSessionDataTask *)JSONPost:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail;

@end
