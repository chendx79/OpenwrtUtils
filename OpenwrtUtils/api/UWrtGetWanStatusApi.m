//
//  UWrtGetWanStatusApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetWanStatusApi.h"

@implementation UWrtGetWanStatusApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"network.interface.wan",
                                                 @"status",
                                                 @{} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.wanStatus = [result objectAtIndex:1];
    //NSLog(@"wanStatus=%@", wanStatus);
    NSLog(@"外网配置如下：");
    NSLog(@"类型=%@", [self.wanStatus objectForKey:@"proto"]);
    NSLog(@"IP地址=%@", [[[self.wanStatus objectForKey:@"ipv4-address"] objectAtIndex:0] objectForKey:@"address"]);
    NSLog(@"DNS地址=%@", [self.wanStatus objectForKey:@"dns-server"]);
}

@end
