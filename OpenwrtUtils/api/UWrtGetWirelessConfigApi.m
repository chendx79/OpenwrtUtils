//
//  UWrtGetWirelessConfigApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetWirelessConfigApi.h"

@implementation UWrtGetWirelessConfigApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"wireless"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.wirelessConfig = [[result objectAtIndex:1] objectForKey:@"values"];
    //NSLog(@"wirelessConfig=%@", wirelessConfig);
    for (int i = 0; i < [self.wirelessConfig allKeys].count; i++) {
        NSString *key = [self.wirelessConfig allKeys][i];
        NSDictionary *value = [self.wirelessConfig objectForKey:key];
        //NSLog(@"%@ = %@", key, value);
        if ([[value objectForKey:@".type"] isEqualToString:@"wifi-iface"]) {
            NSLog(@"Wifi配置：SSID=%@, 加密方式=%@, 密码=%@", [value objectForKey:@"ssid"], [value objectForKey:@"encryption"], [value objectForKey:@"key"]);
            self.wifiDevice = [value objectForKey:@"device"];
            //NSLog(@"wifi设备=%@", [value objectForKey:@"device"]);
        }
    }
}

@end
