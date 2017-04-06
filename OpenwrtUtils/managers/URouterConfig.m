//
//  URouterConfig.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "URouterConfig.h"
#import "UBus.h"

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
    
    [[UBus sharedInstance] wirelessConfig:^{
        [[UBus sharedInstance] scanWiFi:^(NSArray *list) {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *ap in list) {
                URouter *router = [URouter routerWithInfo:ap];
                [temp addObject:router];
            }
            [self.searchedRouters removeAllObjects];
            [self.searchedRouters addObjectsFromArray:temp];
            if ([self.searchRouterDelegate respondsToSelector:@selector(routerConfig:didSearchRouters:)]) {
                [self.searchRouterDelegate routerConfig:self didSearchRouters:self.searchedRouters];
            }
        }];
    }];
    
}

@end
