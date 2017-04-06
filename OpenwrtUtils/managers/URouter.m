//
//  URouter.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "URouter.h"

@interface URouter ()

@property (nonatomic, copy) NSString *bssid;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) NSInteger qualityMax;
@property (nonatomic, assign) NSInteger signal;
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, strong) UEncryption *encryption;

@end

@interface UEncryption : NSObject
@property (nonatomic, strong) NSArray *authentication;
@property (nonatomic, strong) NSArray *ciphers;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSArray *wpa;
+ (UEncryption *)encryptionWithInfo:(NSDictionary *)info;
@end


@implementation URouter

/**
{
    "bssid" : "50:DA:00:C9:A1:90",
    "channel" : 1,
    "encryption" : {
        "authentication" : ["802.1x"],
        "ciphers" : [ccmp],
        "enabled" : 1,
        "wpa" : [2],
    },
    "mode" : Master,
    "quality" : 63,
    "quality_max" : 70,
    "signal" : "-47",
    "ssid" : WANDA,
}
*/

+ (URouter *)routerWithInfo:(NSDictionary *)info {
    return [[[self class] alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        self.bssid = [info valueForKey:@"bssid"];
        self.channel = [info valueForKey:@"channel"];
        self.mode = [info valueForKey:@"mode"];
        self.quality = [[info valueForKey:@"quality"] integerValue];
        self.qualityMax = [[info valueForKey:@"qualityMax"] integerValue];
        self.signal = [[info valueForKey:@"signal"] integerValue];
        self.ssid = [info valueForKey:@"ssid"];
        self.encryption = [UEncryption encryptionWithInfo:[info valueForKey:@"encryption"]];
    }
    return self;
}

@end


@implementation UEncryption

+ (UEncryption *)encryptionWithInfo:(NSDictionary *)info {
    return [[[self class] alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info {
    if (self = [super init]) {
        self.authentication = [info valueForKey:@"authentication"];
        self.ciphers = [info valueForKey:@"ciphers"];
        self.enabled = [[info valueForKey:@"enabled"] boolValue];
        self.wpa = [info valueForKey:@"wpa"];
    }
    return self;
}

@end

