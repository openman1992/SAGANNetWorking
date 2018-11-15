//
//  YourNameGetListApiManager.m
//  MODKNetWorking_Example
//
//  Created by 意想不到 on 2018/11/15.
//  Copyright © 2018年 openman1992. All rights reserved.
//

#import "YourNameGetListApiManager.h"

@implementation YourNameGetListApiManager

- (NSString *)methodName {
    return @"/api/video/listHot1";
}

- (MODKApiManagerRequestType)requestType {
    return MODKApiManagerRequestTypeGet;
}

@end
