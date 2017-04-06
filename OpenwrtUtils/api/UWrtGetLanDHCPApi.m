//
//  UWrtGetLanDHCPApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetLanDHCPApi.h"

@implementation UWrtGetLanDHCPApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"dhcp",
                                                   @"section" : @"lan"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    self.lanDHCP = [[[[result objectAtIndex:1] objectForKey:@"values"] objectForKey:@"dhcp_option"] objectAtIndex:0];
    //NSLog(@"lanDHCP=%@", lanDHCP);
    if ([self.lanDHCP componentsSeparatedByString:@","].count > 1) {
        NSLog(@"DHCP=%@", [self.lanDHCP componentsSeparatedByString:@","][1]);
    }
}


@end
