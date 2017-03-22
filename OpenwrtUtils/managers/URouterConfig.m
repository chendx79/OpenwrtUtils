//
//  URouterConfig.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "URouterConfig.h"

@interface URouterConfig ()
@property (nonatomic, weak) id<URouterConfigProtocol> searchRouterDelegate;
@property (nonatomic, strong) NSMutableArray *searchedRouters;
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

- (instancetype)init {
    if (self = [super init]) {
        self.searchedRouters = [NSMutableArray array];
    }
    return self;
}

- (void)searchingRouters:(id<URouterConfigProtocol>)delegate {
    self.searchRouterDelegate = delegate;
    
    // 测试代码，模拟搜索到wifi
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        URouter *router = [URouter new];
        router.ssid = @"wanda";
        router.isEncrypt = YES;
        router.isConnected = NO;
        [self.searchedRouters removeAllObjects];
        [self.searchedRouters addObject:router];
        if ([self.searchRouterDelegate respondsToSelector:@selector(routerConfig:didSearchRouters:)]) {
            [self.searchRouterDelegate routerConfig:self didSearchRouters:self.searchedRouters];
        }
    });
}

@end
