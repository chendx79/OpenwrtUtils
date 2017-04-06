//
//  UWrtGetPdnsdConfigApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetPdnsdConfigApi.h"

@implementation UWrtGetPdnsdConfigApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"file",
                                                 @"read",
                                                 @{@"path" : @"/etc/pdnsd.conf"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    
    self.pdnsdConfig = [[result objectAtIndex:1] objectForKey:@"data"];
    NSLog(@"pdnsdConfig=\n%@", self.pdnsdConfig);
}

@end
