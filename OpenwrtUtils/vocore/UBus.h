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
    Login  = 0,
    GetLanConfig  = 1,
    GetWanStatus = 2,
    GetWirelessConfig = 3,
    ScanWifi = 4,
};

@interface UBus : NSObject{
@private
    NSString *sessionToken;
    NSDictionary *lanConfig;
    NSDictionary *wanStatus;
    NSDictionary *wirelessConfig;
    NSArray *apList;
}

+ (id)sharedInstance;

- (void)Login;
- (void)GetLanConfig;


@end


#endif /* UBus_h */
