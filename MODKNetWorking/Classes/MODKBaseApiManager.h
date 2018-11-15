//
//  MODKBaseApiManager.h
//  ssda
//
//  Created by 意想不到 on 2018/7/20.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MODKURLBaseResponse.h"
#import "AFNetworking.h"

@class MODKBaseApiManager;

typedef NS_ENUM (NSUInteger, MODKApiManagerRequestType){
    MODKApiManagerRequestTypeGet, /**< get请求，数据体拼接url方式提交 */
    MODKApiManagerRequestTypePost,  /**< 通用post请求 */
    MODKApiManagerRequestTypeJSONPost, /**< Post 请求，数据体以 JSON 方式提交 */
};

#pragma mark -
#pragma mark MODKApiManagerCallbackDelegate

/**
 *  API 回调函数
 *  managerCallApiDidSuccess 代表数据成功拿到，可以直接拿来使用的
 *  managerCallApiDidFailed 失败，数据失败可能性存在 1.网络层错误 如500 404 等 2，业务逻辑上的错误
 */
@protocol MODKApiManagerApiCallbackDelegate <NSObject>

@required

- (void)managerCallApiDidSuccess:(MODKBaseApiManager *)manager responseObject:(id)responseObject;
- (void)managerCallApiDidFailed:(MODKBaseApiManager *)manager error:(NSError *)error;

@end



#pragma mark -
#pragma mark MODKApiManagerParamSourceDelegate

/**
 *  让 manager 能够获取调用 API 所需要的数据 使用场景存在 当一个接口需要获取额外的参数时
 */
@protocol MODKBaseApiManagerParamSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(MODKBaseApiManager *)manager;

@end

#pragma mark -
#pragma mark MODKApiManagerValidator

@protocol MODKApiManagerValidator <NSObject>

/**
 验证器，用于验证 调用 API 的参数是否正确
 使用场景：
 如需要给服务器参数时，有一些必要参数，存在空或者不正确的情况使用
 */
@required

/**
 当调用API的参数是来自用户输入的时候，验证是很必要的。
 这些必要参数存在错误 需要你返回一个错误信息
 */
- (NSString *)manager:(MODKBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end

#pragma mark -
#pragma mark MODKApiManager

/**
 *  ACIApiManager 的派生类必须符合这个 protocol
 */
@protocol MODKApiManager <NSObject>

@required

- (NSString *)methodName;
- (MODKApiManagerRequestType)requestType;

@end

#pragma mark -
#pragma mark MODKApiManagerInterceptor

@protocol MODKApiManagerInterceptor <NSObject>

@optional
- (void)beforePerformSuccessManager:(MODKBaseApiManager *)manager responseObject:(id)responseObject;
- (void)afterPerformSuccessManager:(MODKBaseApiManager *)manager responseObject:(id)responseObject;

- (void)beforePerformFailManager:(MODKBaseApiManager *)manager error:(NSError *)error;
- (void)afterPerformFailManager:(MODKBaseApiManager *)manager error:(NSError *)error;



@end


@interface MODKBaseApiManager : NSObject

/**
 解析器：数据用什么方式去解析 目前提供二种方式 如果以后有加密等方式 扩展解析器
 MODKURLJosnResponse json解析
 MODKURLBaseResponse 直接返回原始数据data
 默认MODKURLJosnResponse
 */
@property (nonatomic, strong) NSString *indetyfier; 

@property (nonatomic, strong) MODKURLBaseResponse *response;

@property (nonatomic, weak) id<MODKApiManagerApiCallbackDelegate> delegate;

@property (nonatomic, weak) id<MODKBaseApiManagerParamSourceDelegate> paramsDelegate;

@property (nonatomic, weak) id<MODKApiManagerValidator> validateDelegate;

@property (nonatomic, weak) id<MODKApiManagerInterceptor> IntercepteDelegate;

@property (nonatomic, weak) id<MODKApiManager>mochild;

// 提供共有参数， 如果不需要共有参数 重写它
- (NSDictionary *)commonParamsDict;
// 提供共有http头部参数 如果不需要 重写它
- (NSDictionary *)httpHeader;

/**
 *  该方法会通过 param source 来获取参数，这使得参数的生成逻辑位于 controller 中的固定位置
 *
 *  @return 该请求task
 */
- (NSURLSessionDataTask *)loadData;
// 取消目前所有的任务
- (void)cancelAllRequests;

/** 切片方法，重写后需要调用一下super 否则代理将不会执行 */
- (void)beforePerformSuccessWithResponseObject:(id)responseObject;
- (void)afterPerformSuccessWithResponseObject:(id)responseObject;

- (void)beforePerformFailWithError:(NSError *)error;
- (void)afterPerformFailWithError:(NSError *)error;


@end
