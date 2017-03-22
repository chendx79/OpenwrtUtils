//
//  URouter.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "URouter.h"

@implementation URouter

+ (URouter *)routerWithInfo:(NSDictionary *)info {
    return [[[self class] alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        
    }
    return self;
}

@end
