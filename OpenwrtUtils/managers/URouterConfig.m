//
//  URouterConfig.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "URouterConfig.h"

@interface URouterConfig ()
@property (nonatomic, strong) NSArray *searchedRouters;
@end

@implementation URouterConfig

+ (URouterConfig *)sharedInstance {
    static URouterConfig *instance = nil;
    @synchronized (self) {
        if (!instance) {
            instance = [[[self class] alloc] init];
        }
    }
    return instance;
}

- (void)searchingRouters {

}

@end
