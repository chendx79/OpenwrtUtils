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
- (void)showWanStatus:(void (^)(NSDictionary *wanStatus))resultBlock;
- (void)showSystemInfo:(void (^)(NSDictionary * systemInfo))resultBlock;
- (void)showSystemBoard:(void (^)(NSDictionary * systemBoard))resultBlock;
- (void)showDiskInfo:(void (^)(NSDictionary *diskInfo))resultBlock;

- (BOOL)isBoxAvailable;
- (BOOL)isBoxLoggedin;
- (BOOL)isWiFiConnected;

@end
