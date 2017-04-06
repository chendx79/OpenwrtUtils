//
//  UWrtGetDHCPLeasesApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetDHCPLeasesApi.h"

@implementation UWrtGetDHCPLeasesApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"file",
                                                 @"read",
                                                 @{@"path" : @"/tmp/dhcp.leases"} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    self.DHCPLeases = [[result objectAtIndex:1] objectForKey:@"data"];
    NSLog(@"DHCPLeases=\n%@", self.DHCPLeases);
}

@end
