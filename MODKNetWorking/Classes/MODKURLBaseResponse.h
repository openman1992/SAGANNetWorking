//
//  MODKURLBaseResponse.h
//  ssda
//
//  Created by 意想不到 on 2018/7/23.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <Foundation/Foundation.h>

// 响应 处理类 

@interface MODKURLBaseResponse : NSObject

- (id)fetchData:(NSData *)data error:(NSError **)error;

@end
