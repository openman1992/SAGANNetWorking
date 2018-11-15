//
//  YourNameApiManager.m
//  MODKNetWorking_Example
//
//  Created by 意想不到 on 2018/11/15.
//  Copyright © 2018年 openman1992. All rights reserved.
//

#import "YourNameApiManager.h"

@implementation YourNameApiManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // 这儿我需要对业务错误进行处理
        self.errorFilterDelegate = self;
    }
    return self;
}

- (NSDictionary *)commonParamsDict {
    NSMutableDictionary *dict = [super commonParamsDict].mutableCopy;
    // 这儿可以添加一些共有的参数
    return dict.copy;
}

- (NSDictionary *)httpHeader {
    NSMutableDictionary *dict = [super httpHeader].mutableCopy;
    // 这儿可以添加一些共有的http头部信息
    return dict.copy;
}


- (BOOL)errorByFilterWithResponseObjct:(id)responseObject apiManager:(MODKBaseApiManager *)manager error:(NSError **)error {
    
    return YES;
}

@end
