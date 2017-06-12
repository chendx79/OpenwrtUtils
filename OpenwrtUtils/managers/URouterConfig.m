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
@property (nonatomic, strong) NSDictionary *wanStatus;
@property (nonatomic, strong) NSDictionary *systemInfo;
@property (nonatomic, strong) NSDictionary *systemBoard;
@property (nonatomic, strong) NSDictionary *diskInfo;
@property (nonatomic, strong) NSDictionary *networkState;
@property (nonatomic, strong) NSString *lanDHCP;
@property (nonatomic, strong) NSDictionary *wirelessConfig;
@property (nonatomic, strong) NSString *iwInfoDevice;
@property (nonatomic, strong) NSDictionary *iwInfoInfo;

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

- (void)getRouterInfo{
    [self getWanStatus];
    [self getSystemInfo];
    [self getSystemBoard];
    [self getDiskInfo];
    [self getNetworkState];
    [self getLanDHCP];
    [self getWirelessConfig];
    [self getIWInfoDevice];
}

- (void)getWanStatus{
    [[UBus sharedInstance] getWanStatus:^(NSDictionary *wanStatus) {
        self.wanStatus = wanStatus;
    }];
}

- (void)getSystemInfo{
    [[UBus sharedInstance] getSystemInfo:^(NSDictionary *systemInfo) {
        self.systemInfo = systemInfo;
    }];
}

- (void)getSystemBoard{
    [[UBus sharedInstance] getSystemBoard:^(NSDictionary *systemBoard) {
        self.systemBoard = systemBoard;
    }];
}

- (void)getDiskInfo{
    [[UBus sharedInstance] getDiskInfo:^(NSDictionary *diskInfo) {
        self.diskInfo = diskInfo;
    }];
}

- (void)getNetworkState{
    [[UBus sharedInstance] getNetworkState:^(NSDictionary *networkState) {
        self.networkState = networkState;
    }];
}

- (void)getLanDHCP{
    [[UBus sharedInstance] getLanDHCP:^(NSString *lanDHCP) {
        self.lanDHCP = lanDHCP;
    }];
}

- (void)getWirelessConfig{
    [[UBus sharedInstance] getWirelessConfig:^(NSDictionary *wirelessConfig) {
        self.wirelessConfig = wirelessConfig;
    }];
}

- (void)getIWInfoDevice{
    [[UBus sharedInstance] getIWInfoDevice:^(NSString *iwInfoDevice) {
        self.iwInfoDevice = iwInfoDevice;
        [self getIWInfoInfo];
    }];
}

- (void)getIWInfoInfo{
    [[UBus sharedInstance] getIWInfoInfo:^(NSDictionary *iwInfoInfo) {
        self.iwInfoInfo = iwInfoInfo;
    }];
}

@end
