//
//  UBus.h
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/sysctl.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface Utils : NSObject {
   @private
    NSString *host;
    NMSSHSession *session;
}

+ (id)sharedInstance;

- (NSString *)GetLocalIP;
- (NSString *)GetGetwayIP;
- (BOOL)SSHLogin:(NSString *)ip Port:(NSString *)port Username:(NSString *)username Password:(NSString *)password;
- (BOOL)SystemPrepare;
- (NSDictionary *)GetDiskInfo;
- (NSArray *)GetWifiClients;

@end

#endif /* UBus_h */
