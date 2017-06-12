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
    
    NSDictionary *allWirelessConfig = [[result objectAtIndex:1] objectForKey:@"values"];
    for (int i = 0; i < [allWirelessConfig allKeys].count; i++) {
        NSString *key = [allWirelessConfig allKeys][i];
        NSDictionary *value = [allWirelessConfig objectForKey:key];
        if ([[value objectForKey:@".type"] isEqualToString:@"wifi-iface"]) {
            self.wirelessConfig = value;
            NSLog(@"Wifi配置%@", self.wirelessConfig);
            self.wifiDevice = [self.wirelessConfig objectForKey:@"device"];
        }
    }
}

@end
