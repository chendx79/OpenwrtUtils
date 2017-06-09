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

- (void)checkBoxAvailable:(void (^)(BOOL available))resultBlock;
- (void)loginWithPassword:(NSString *)pwd result:(void (^)(BOOL))resultBlock;
- (void)searchingRouters:(id<URouterConfigProtocol>)delegate;
- (void)getRouterInfo;
- (void)getWanStatus;
- (void)getSystemInfo;
- (void)getSystemBoard;
- (void)getDiskInfo;

- (BOOL)isBoxAvailable;
- (BOOL)isBoxLoggedin;
- (BOOL)isWiFiConnected;

- (NSDictionary *)wanStatus;
- (NSDictionary *)systemInfo;
- (NSDictionary *)systemBoard;
- (NSDictionary *)diskInfo;

@end
