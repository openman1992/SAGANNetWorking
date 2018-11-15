//
//  MODKBaseApiManager.m
//  ssda
//
//  Created by 意想不到 on 2018/7/20.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "MODKBaseApiManager.h"
#import "MODKURLJosnResponse.h"
#import "MODKApiProxy.h"

NSString * const MODKApiErrorTypeStringNetwork = @"MODKApiErrorTypeStringNetwork"; // 网络错误

NSString * const MODKApiErrorTypeStringBusiness = @"MODKApiErrorTypeStringBusiness"; // 业务逻辑错误

NSString * const MODKApiErrorTypeNeedLog = @"MODKApiErrorTypeNeedLog"; // 需要登录

@interface MODKBaseApiManager ()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation MODKBaseApiManager

- (void)dealloc {
    _delegate = nil;
    _paramsDelegate = nil;
    _IntercepteDelegate = nil;
    _validateDelegate = nil;
    [_task cancel];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![self conformsToProtocol:@protocol(MODKApiManager)]) {
            // 子类必须遵守该协议
            NSAssert(NO, @"子类必须要实现CLAPIManager这个protocol");
        }else {
             self.mochild = (id <MODKApiManager>)self;
        }
        _response = [[MODKURLJosnResponse alloc]init];
    }
    return self;
}

- (void)cancelAllRequests {
    [[MODKApiProxy sharedInstance] cancelAllRequest];
}

- (NSDictionary *)commonParamsDict {
    return @{};
}
- (NSDictionary *)httpHeader {
    
    return nil;
}

- (NSURLSessionDataTask *)loadData {
    //参数获取 ，1 获取共有参数 2. 获取特有参数
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self.paramsDelegate respondsToSelector:@selector(paramsForApi:)]) {
        NSDictionary *specDict = [self.paramsDelegate paramsForApi:self];
        [params addEntriesFromDictionary:specDict];
    }
    [params addEntriesFromDictionary:[self commonParamsDict]];
    if ([_validateDelegate respondsToSelector:@selector(manager:isCorrectWithParamsData:)]) {
        NSString *errorString = [_validateDelegate manager:self isCorrectWithParamsData:params];
        if (errorString) {
            NSError *error = [NSError errorWithDomain:MODKApiErrorTypeStringBusiness code:-11 userInfo:@{NSLocalizedDescriptionKey:errorString}];
            [self callFailApi:error response:nil];
            return nil;
        }
    }
   
   // 实际发送网络请求
    switch (self.mochild.requestType) {
        case MODKApiManagerRequestTypeGet: {
            _task = [[MODKApiProxy sharedInstance]GET:self.mochild.methodName params:params httpHeader:[self httpHeader] success:^(id responseObject) {
                [self callSuccessApi:responseObject];
            } fail:^(NSError *error, NSURLResponse *response) {
                [self callFailApi:error response:response];
            }];
        }
            break;
        case MODKApiManagerRequestTypePost: {
            _task = [[MODKApiProxy sharedInstance]POST:self.mochild.methodName params:params httpHeader:[self httpHeader] success:^(id responseObject) {
                [self callSuccessApi:responseObject];
            } fail:^(NSError *error, NSURLResponse *response) {
                [self callFailApi:error response:response];
            }];
        }
            break;
        case MODKApiManagerRequestTypeJSONPost: {
            _task = [[MODKApiProxy sharedInstance]JSONPost:self.mochild.methodName params:params httpHeader:[self httpHeader] success:^(id responseObject) {
                [self callSuccessApi:responseObject];
            } fail:^(NSError *error, NSURLResponse *response) {
                [self callFailApi:error response:response];
            }];
        }
            break;
        default:
            break;
    }
    return _task;
}

- (void)callSuccessApi:(id)responseObject {
    NSError *error = nil;
    NSDictionary *responseObj = [self.response fetchData:responseObject error:&error];
    if (error) {
        if ([_delegate respondsToSelector:@selector(managerCallApiDidFailed:error:)]) {
            [self beforePerformFailWithError:error];
            [_delegate managerCallApiDidFailed:self error:error];
            [self afterPerformFailWithError:error];
        }
        return;
    }
    // 处理业务 错误
    if ([responseObj[@"code"] integerValue] == 401) {
        // 需要登录
        [[NSNotificationCenter defaultCenter]postNotificationName:MODKApiErrorTypeNeedLog object:self];
        return;
    } else if ([responseObj[@"success"] integerValue] != 1) {
        error = [NSError errorWithDomain:@"dbjError" code:[responseObj[@"success"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObj[@"msg"]}];
    }
    if (error) {
        if ([_delegate respondsToSelector:@selector(managerCallApiDidFailed:error:)]) {
            [self beforePerformFailWithError:error];
            [_delegate managerCallApiDidFailed:self error:error];
            [self afterPerformFailWithError:error];
        }
        return;
    }
    if ([_delegate respondsToSelector:@selector(managerCallApiDidSuccess:responseObject:)]) {
        [self beforePerformSuccessWithResponseObject:responseObj];
        [_delegate managerCallApiDidSuccess:self responseObject:responseObj];
        [self afterPerformSuccessWithResponseObject:responseObj];
    }
    
}
- (void)callFailApi:(NSError *)error response:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 401) {
            // 需要登录
            [[NSNotificationCenter defaultCenter]postNotificationName:MODKApiErrorTypeNeedLog object:self];
            return;
        }
    }
    if ([_delegate respondsToSelector:@selector(managerCallApiDidFailed:error:)]) {
         [self beforePerformFailWithError:error];
        [_delegate managerCallApiDidFailed:self error:error];
         [self afterPerformFailWithError:error];
    }
   
}

// 切片 方法
- (void)beforePerformSuccessWithResponseObject:(id)responseObject {
    if (self != self.IntercepteDelegate && [self.IntercepteDelegate respondsToSelector:@selector(beforePerformSuccessManager:responseObject:)]) {
        [self.IntercepteDelegate beforePerformSuccessManager:self responseObject:responseObject];
    }
}
- (void)afterPerformSuccessWithResponseObject:(id)responseObject {
    if (self != self.IntercepteDelegate && [self respondsToSelector:@selector(afterPerformSuccessManager:responseObject:)]) {
        [self.IntercepteDelegate afterPerformSuccessManager:self responseObject:responseObject];
    }
}

- (void)beforePerformFailWithError:(NSError *)error {
    if (self != self.IntercepteDelegate && [self.IntercepteDelegate respondsToSelector:@selector(beforePerformFailManager:error:)]) {
        [self.IntercepteDelegate beforePerformFailManager:self error:error];
    }
}
- (void)afterPerformFailWithError:(NSError *)error {
    if (self != self.IntercepteDelegate && [self.IntercepteDelegate respondsToSelector:@selector(afterPerformFailManager:error:)]) {
        [self.IntercepteDelegate afterPerformFailManager:self error:error];
    }
}

- (NSString *)indetyfier {
    return [NSString stringWithFormat:@"%@",@(_task.taskIdentifier)];
}


@end
