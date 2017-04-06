//
//  UWrtScanWiFiApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtScanWiFiApi.h"

@implementation UWrtScanWiFiApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"iwinfo",
                                                 @"scan",
                                                 @{@"device" : self.wifiDevice} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.apList = [[result objectAtIndex:1] objectForKey:@"results"];
    //NSLog(@"apList=%@", apList);
    NSLog(@"搜索到的无线热点如下：");
    for (int i = 0; i < self.apList.count; i++) {
        NSDictionary *ap = self.apList[i];
        NSLog(@"SSID=%@， 信号=%@/%@， MAC地址=%@， 认证方式=%@", [ap objectForKey:@"ssid"], [ap objectForKey:@"quality"], [ap objectForKey:@"quality_max"], [ap objectForKey:@"bssid"], [[[ap objectForKey:@"encryption"] objectForKey:@"authentication"] objectAtIndex:0]);
    }
}

@end
