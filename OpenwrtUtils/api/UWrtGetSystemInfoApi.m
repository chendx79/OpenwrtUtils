//
//  UWrtGetSystemInfoApi.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/5.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetSystemInfoApi.h"

@implementation UWrtGetSystemInfoApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"system",
                                                 @"info",
                                                 @{} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.systemInfo = [result objectAtIndex:1];
    //NSLog(@"wanStatus=%@", wanStatus);
//    NSLog(@"外网配置如下：");
//    NSLog(@"类型=%@", [self.systemInfo objectForKey:@"proto"]);
//    NSLog(@"IP地址=%@", [[[self.systemInfo objectForKey:@"ipv4-address"] objectAtIndex:0] objectForKey:@"address"]);
//    NSLog(@"DNS地址=%@", [self.systemInfo objectForKey:@"dns-server"]);
}

@end
