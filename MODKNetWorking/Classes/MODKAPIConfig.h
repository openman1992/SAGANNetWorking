//
//  MODKAPIConfig.h
//  ssda
//
//  Created by 意想不到 on 2018/7/23.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#ifndef MODKAPIConfig_h
#define MODKAPIConfig_h

typedef NS_ENUM(NSUInteger, MODKEnvironmentType) {
    MODKEnvironmentTypeAppDev,   /**< app开发环境 */
    MODKEnvironmentTypeRelease,  /**< 生产环境 */
};

static NSTimeInterval kACINetworkingTimeoutSeconds = 20.0f;

// 错误类型定义，网络错误定义为 如404 500 等 
extern NSString * const MODKApiErrorTypeStringNetwork; // 网络错误
extern NSString * const MODKApiErrorTypeStringBusiness; // 业务逻辑错误

#endif /* MODKAPIConfig_h */
