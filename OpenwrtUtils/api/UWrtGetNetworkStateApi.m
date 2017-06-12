//
//  UWrtGetNetworkStateApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtGetNetworkStateApi.h"

@implementation UWrtGetNetworkStateApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ self.sessionToken,
                                                 @"uci",
                                                 @"state",
                                                 @{@"config" : @"network"}]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    self.networkState = [[result objectAtIndex:1] objectForKey:@"values"];
    NSLog(@"NetworkState=%@", self.networkState);
}


@end
