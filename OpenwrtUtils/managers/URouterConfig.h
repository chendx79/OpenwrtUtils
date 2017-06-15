//
//  URouterConfig.h
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URouter.h"

@class URouterConfig;
@protocol URouterConfigProtocol <NSObject>
- (void)routerConfig:(URouterConfig *)router didSearchRouters:(NSArray *)routers;
@end

@interface URouterConfig : NSObject

+ (URouterConfig *)sharedInstance;

- (void)checkUbusAvailable:(void (^)(BOOL available))resultBlock;
- (void)loginWithPassword:(NSString *)pwd result:(void (^)(BOOL))resultBlock;
- (void)searchingRouters:(id<URouterConfigProtocol>)delegate;
- (void)getRouterInfo;
- (void)getWanStatus;
- (void)getSystemInfo;
- (void)getSystemBoard;
- (void)sshLogin;
- (void)systemPrepare;
- (void)getDiskInfo;
- (void)getWifiClients;
- (void)getShadowsocksConfig;

- (BOOL)isWifi;
- (BOOL)isUBusAvailable;
- (BOOL)isBoxLoggedin;
- (BOOL)isWiFiConnected;
- (BOOL)isSSHLoggedin;
- (BOOL)isSystemPrepared;
- (BOOL)isUBusNotFullAccess;

@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic, assign) BOOL isUBusNotFullAccess;
@property (nonatomic, assign) BOOL isSystemPrepared;

- (NSDictionary *)wanStatus;
- (NSDictionary *)systemInfo;
- (NSDictionary *)systemBoard;
- (NSDictionary *)diskInfo;
- (NSDictionary *)networkState;
- (NSString *)lanDHCP;
- (NSDictionary *)wirelessConfig;
- (NSString *)iwInfoDevice;
- (NSDictionary *)iwInfoInfo;
- (NSArray *)wifiClients;
- (NSDictionary *)shadowsocksConfig;
- (NSString *)pdnsdConfig;

@end
