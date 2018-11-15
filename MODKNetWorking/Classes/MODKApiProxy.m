//
//  MODKApiProxy.m
//  ssda
//
//  Created by 意想不到 on 2018/7/23.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "MODKApiProxy.h"
#import "AFNetworking.h"
#import "MDKNetWorkLog.h"


NSString * const MODKNotiNetworkStatusChanged = @"MODKNotiNetworkStatusChanged"; // 网络状态发生改变

@interface MODKApiProxy ()

@property (nonatomic, strong) MODKAPIServicer *apiServicer;

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end


@implementation MODKApiProxy

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MODKApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MODKApiProxy alloc] init];
    });
    return sharedInstance;
   
}

- (void)monitNetwork {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [[NSNotificationCenter defaultCenter]postNotificationName:MODKNotiNetworkStatusChanged object:self userInfo:@{@"status":@(status),@"desc":@"未知网络"}];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter]postNotificationName:MODKNotiNetworkStatusChanged object:self userInfo:@{@"status":@(status),@"desc":@"不可用网络"}];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                 [[NSNotificationCenter defaultCenter]postNotificationName:MODKNotiNetworkStatusChanged object:self userInfo:@{@"status":@(status),@"desc":@"流量网络"}];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
               [[NSNotificationCenter defaultCenter]postNotificationName:MODKNotiNetworkStatusChanged object:self userInfo:@{@"status":@(status),@"desc":@"无线网络"}];
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
     
}

- (void)config:(MODKAPIServicer *)service {
    _apiServicer = service;
    if (service.isMoniNetwork) {
        [self monitNetwork];
    }
}

- (void)cancelAllRequest {
    NSArray *arr = self.sessionManager.dataTasks;
    for (int i = 0; i<arr.count; i++) {
        NSURLSessionDataTask *task = arr[i];
        [task cancel];
    }
}


- (NSURLSessionDataTask *)GET:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail {
    AFHTTPRequestSerializer *seri = [AFHTTPRequestSerializer serializer];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [seri setValue:obj forHTTPHeaderField:key];
    }];
    NSMutableURLRequest *request = [seri requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",_apiServicer.baseUrlString,urlString] parameters:params error:nil];
    return [self callApiWithRequest:request success:success fail:fail];
}

- (NSURLSessionDataTask *)POST:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail {
    AFHTTPRequestSerializer *seri = [AFHTTPRequestSerializer serializer];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [seri setValue:obj forHTTPHeaderField:key];
    }];
    NSMutableURLRequest *request = [seri requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",_apiServicer.baseUrlString,urlString] parameters:params error:nil];
    
    return [self callApiWithRequest:request success:success fail:fail];
}

- (NSURLSessionDataTask *)JSONPost:(NSString *)urlString params:(NSDictionary *)params httpHeader:(NSDictionary *)header success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail {
    AFJSONRequestSerializer *seri = [AFJSONRequestSerializer serializer];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [seri setValue:obj forHTTPHeaderField:key];
    }];
    NSMutableURLRequest *request = [seri requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",_apiServicer.baseUrlString,urlString] parameters:params error:nil];
    return [self callApiWithRequest:request success:success fail:fail];
}

- (NSURLSessionDataTask *)callApiWithRequest:(NSMutableURLRequest *)request success:( void (^)(id responseObject))success fail:( void (^)(NSError *error, NSURLResponse *response))fail {
    __block NSURLSessionDataTask *task = nil;
    request.timeoutInterval = 20.0;
    task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        MDKNetWorkLog *log =  [[MDKNetWorkLog alloc]initWithResponse:response responseObject:responseObject];
        if (error) {
            [log show];
            fail(error,response);
        } else {
            success(responseObject);
        }
    }];
    [task resume];
    return task;
}

- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFURLSessionManager alloc]init];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
       // _sessionManager.completionQueue = dispatch_get_global_queue(0, 0);
    }
    return _sessionManager;
}

@end
