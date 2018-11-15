//
//  MODKAPIServicer.m
//  AFNetworking
//
//  Created by 意想不到 on 2018/11/15.
//

#import "MODKAPIServicer.h"

@interface MODKAPIServicer ()

@property (nonatomic, strong) NSString *baseUrlString;

@end

@implementation MODKAPIServicer

- (instancetype)initWithBaseUrlString:(NSString *)baseUrlString {
    self = [super init];
    if (self) {
        _baseUrlString = baseUrlString;
    }
    return self;
}

@end
