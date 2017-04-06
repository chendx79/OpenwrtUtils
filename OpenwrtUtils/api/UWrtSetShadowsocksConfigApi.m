//
//  UWrtSetShadowsocksConfigApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtSetShadowsocksConfigApi.h"

@implementation UWrtSetShadowsocksConfigApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"set",
                                                 @{@"config" : @"shadowsocks",
                                                   @"type" : @"shadowsocks",
                                                   @"values" : @{@"server" : self.serverAddr,
                                                                 @"server_port" : self.serverPort,
                                                                 @"password" : self.password}} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
}

@end
