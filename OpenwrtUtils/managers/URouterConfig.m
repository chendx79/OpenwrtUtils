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
@property (nonatomic, assign) BOOL isBoxAvailable;
@property (nonatomic, assign) BOOL isBoxLoggedin;
@property (nonatomic, assign) BOOL isWiFiConnected;
@end

@implementation URouterConfig

+ (URouterConfig *)sharedInstance {
    static URouterConfig *instance = nil;
    @synchronized(self) {
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

- (void)checkBoxAvailable:(void (^)(BOOL available))resultBlock {
    [[UBus sharedInstance] checkUBusAvailable:^(BOOL available) {
      self.isBoxAvailable = available;
      if (resultBlock) {
          resultBlock(available);
      }
    }];
}

- (void)loginWithPassword:(NSString *)pwd result:(void (^)(BOOL))resultBlock {
    [[UBus sharedInstance] loginWithPassword:pwd
                                      result:^(BOOL success) {
                                        self.isBoxLoggedin = success;
                                        if (resultBlock) {
                                            resultBlock(success);
                                        }
                                      }];
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

- (void)showWanStatus:(void (^)(NSDictionary *wanStatus))resultBlock {
    [[UBus sharedInstance] getWanStatus:^(NSDictionary *wanStatus) {
      if (resultBlock) {
          resultBlock(wanStatus);
      }
    }];
}

- (void)showSystemInfo:(void (^)(NSDictionary *systemInfo))resultBlock {
    [[UBus sharedInstance] getSystemInfo:^(NSDictionary *systemInfo) {
      if (resultBlock) {
          resultBlock(systemInfo);
      }
    }];
}

- (void)showSystemBoard:(void (^)(NSDictionary *systemBoard))resultBlock {
    [[UBus sharedInstance] getSystemBoard:^(NSDictionary *systemBoard) {
      if (resultBlock) {
          resultBlock(systemBoard);
      }
    }];
}

- (void)showDiskInfo:(void (^)(NSDictionary *diskInfo))resultBlock {
    [[UBus sharedInstance] getDiskInfo:^(NSDictionary *diskInfo) {
        if (resultBlock) {
            resultBlock(diskInfo);
        }
    }];
}


@end
