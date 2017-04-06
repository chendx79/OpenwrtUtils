//
//  UWrtGetSSHStatusApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetSSHStatusApi.h"

@implementation UWrtGetSSHStatusApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"dropbear"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    self.sshStatus = [[result objectAtIndex:1] objectForKey:@"values"];
    self.sshStatus = [self.sshStatus objectForKey:[self.sshStatus allKeys][0]];
    //NSLog(@"sshStatus=%@", sshStatus);
    NSLog(@"SSH状态=%@, 端口号=%@", [self.sshStatus objectForKey:@"PasswordAuth"], [self.sshStatus objectForKey:@"Port"]);
}

@end
