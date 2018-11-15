//
//  MODKAPIServicer.h
//  AFNetworking
//
//  Created by 意想不到 on 2018/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MODKAPIServicer : NSObject

@property (nonatomic, strong, readonly) NSString *baseUrlString; // base URL

@property (nonatomic, assign) BOOL isMoniNetwork; // 是否监听网络

- (instancetype)initWithBaseUrlString:(NSString *)baseUrlString;

@end

NS_ASSUME_NONNULL_END
