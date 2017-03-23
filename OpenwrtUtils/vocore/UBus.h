//
//  UBus.h
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#ifndef UBus_h
#define UBus_h

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_OPTIONS(NSUInteger, Action) {
    CheckUBus = 1,
    Login = 2,
    GetLanConfig = 3,
    GetLanDHCP = 4,
    GetSSHStatus = 5,
    GetWanStatus = 6,
    GetWirelessConfig = 7,
    GetShadowsocksConfig = 8,
    GetPdnsdConfig = 9,
    ScanWifi = 10,
};

@interface UBus : NSObject {
   @private
    NSString *rootPassword;
    NSString *URLString;

    NSString *sessionToken;
    NSDictionary *lanConfig;
    NSString *lanDHCP;
    NSDictionary *sshStatus;
    NSDictionary *wanStatus;
    NSDictionary *wirelessConfig;
    NSDictionary *shadowsocksConfig;
    NSString *pdnsdConfig;
    NSArray *apList;
    NSString *wifiDevice;
}

+ (id)sharedInstance;

- (void)CheckUBus;
- (void)Login;
- (void)GetLanConfig;

@end

#endif /* UBus_h */
