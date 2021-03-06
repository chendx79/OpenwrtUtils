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
    GetDHCPLeases = 5,
    GetSSHStatus = 6,
    GetWanStatus = 7,
    GetWirelessConfig = 8,
    GetShadowsocksConfig = 9,
    GetPdnsdConfig = 10,

    ScanWifi = 20,

    SetShadowsocksConfig = 30,

    Commit = 40,
    Apply = 41,
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

//NSString * const SSH_PORT = @"22";
//NSString * const SSH_USERNAME = @"root";

@interface UBus : NSObject {
   @private
    NSString *rootPassword;
    NSString *URLString;

    NSString *ssServer;
    NSNumber *ssPort;
    NSString *ssPassword;
    NSString *gatewayIP;

//    NSString *sessionToken;
    NSDictionary *lanConfig;
    NSString *lanDHCP;
    NSString *DHCPLeases;
    NSDictionary *sshStatus;
    NSDictionary *wanStatus;
//    NSDictionary *wirelessConfig;
    NSDictionary *shadowsocksConfig;
    NSString *pdnsdConfig;
//    NSArray *apList;
//    NSString *wifiDevice;
}

+ (id)sharedInstance;

//- (void)CheckUBus;
//- (void)Login;
//- (void)GetLanConfig;

- (void)checkUBusAvailable:(void (^)(BOOL available))result;
- (void)loginWithPassword:(NSString *)password result:(void (^)(BOOL success))result;
- (void)wirelessConfig:(void (^)(void))result;
- (void)scanWiFi:(void (^)(NSArray *list))result;
- (void)getWanStatus:(void (^)(NSDictionary *wanStatus))result;
- (void)getSystemInfo:(void (^)(NSDictionary *systemInfo))result;
- (void)getSystemBoard:(void (^)(NSDictionary *systemInfo))result;
- (void)getNetworkState:(void (^)(NSDictionary *networkState))result;
- (void)getLanDHCP:(void (^)(NSString *lanDHCP))result;
- (void)getWirelessConfig:(void (^)(NSDictionary *wirelessConfig))result;
- (void)getIWInfoDevice:(void (^)(NSString *iwInfoDevice))result;
- (void)getIWInfoInfo:(void (^)(NSDictionary *iwInfoInfo))result;
- (void)getShadowsocksConfig:(void (^)(NSDictionary *shadowsocksConfig))result;
- (void)getPdnsdConfig:(void (^)(NSString *pdnsdConfig))result;

- (void)systemPrepare:(void (^)(BOOL isSystemPrepared))result;
- (void)sshLogin:(void (^)(BOOL success))result;
- (void)getDiskInfo:(void (^)(NSDictionary *diskInfo))result;
- (void)getWifiClients:(void (^)(NSArray *wifiClients))result;

@end

#endif /* UBus_h */
