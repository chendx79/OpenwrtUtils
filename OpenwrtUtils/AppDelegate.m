//
//  AppDelegate.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/3/14.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "AppDelegate.h"
#import "UHomeViewController.h"
#import "AFNetworking.h"
#import "URouterConfig.h"

@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController *navigation;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.navigation = [[UINavigationController alloc] initWithRootViewController:[UHomeViewController new]];
    self.window.rootViewController = self.navigation;
    [self.window makeKeyAndVisible];

    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [URouterConfig sharedInstance].isWifi = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [URouterConfig sharedInstance].isWifi = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [URouterConfig sharedInstance].isWifi = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [URouterConfig sharedInstance].isWifi = YES;
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
