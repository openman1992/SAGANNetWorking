//
//  MDKNetWorkLog.h
//  MODKPet
//
//  Created by 意想不到 on 2018/10/10.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDKNetWorkLog : NSObject

- (instancetype)initWithResponse:(NSURLResponse *)response responseObject:(NSData *)responseObject;

- (void)show;

@end

NS_ASSUME_NONNULL_END
