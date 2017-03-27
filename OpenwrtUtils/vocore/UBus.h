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
    SetShadowsocksConfig = 11,
    
    Commit = 20,
    Apply = 21,
};

typedef NS_OPTIONS(NSUInteger, UbusError) {
    UBUS_STATUS_OK = 0,
    UBUS_STATUS_INVALID_COMMAND = 1,
    UBUS_STATUS_INVALID_ARGUMENT = 2,
    UBUS_STATUS_METHOD_NOT_FOUND = 3,
    UBUS_STATUS_NOT_FOUND = 4,
    UBUS_STATUS_NO_DATA = 5,
    UBUS_STATUS_PERMISSION_DENIED = 6,
    UBUS_STATUS_TIMEOUT = 7,
    UBUS_STATUS_NOT_SUPPORTED = 8,
    UBUS_STATUS_UNKNOWN_ERROR = 9,
    UBUS_STATUS_CONNECTION_FAILED = 10,
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
