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

typedef NS_OPTIONS(NSUInteger, Action)
{
    CheckUBus = 1,
    Login  = 2,
    GetLanConfig  = 3,
    GetWanStatus = 4,
    GetWirelessConfig = 5,
    ScanWifi = 6,
};

@interface UBus : NSObject{
@private
    NSString *rootPassword;
    NSString *URLString;
    
    NSString *sessionToken;
    NSDictionary *lanConfig;
    NSDictionary *wanStatus;
    NSDictionary *wirelessConfig;
    NSArray *apList;
}

+ (id)sharedInstance;

- (void)CheckUBus;
- (void)Login;
- (void)GetLanConfig;


@end


#endif /* UBus_h */
