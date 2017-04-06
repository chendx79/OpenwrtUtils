//
//  UWrtGetShadowsocksConfigApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetShadowsocksConfigApi.h"

@implementation UWrtGetShadowsocksConfigApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"shadowsocks"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.shadowsocksConfig = [[result objectAtIndex:1] objectForKey:@"values"];
    self.shadowsocksConfig = [self.shadowsocksConfig objectForKey:[self.shadowsocksConfig allKeys][0]];
    //NSLog(@"shadowsocksConfig=%@", shadowsocksConfig);
    NSLog(@"Shadowsocks配置：状态=%@, 服务器=%@, 服务器端口=%@, 密码=%@, 加密方式=%@", [self.shadowsocksConfig objectForKey:@"enable"], [self.shadowsocksConfig objectForKey:@"server"], [self.shadowsocksConfig objectForKey:@"server_port"], [self.shadowsocksConfig objectForKey:@"password"], [self.shadowsocksConfig objectForKey:@"encrypt_method"]);
}

@end
