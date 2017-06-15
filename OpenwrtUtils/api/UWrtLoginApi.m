//
//  UWrtLoginApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtLoginApi.h"
#import "URouterConfig.h"

@interface UWrtLoginApi ()
@property (nonatomic, copy) NSString *sessionToken;
@end
@implementation UWrtLoginApi

- (NSDictionary *)parameters {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ @"00000000000000000000000000000000",
                                                 @"session",
                                                 @"login",
                                                 @{@"username" : @"root",
                                                   @"password" : self.rootPassword} ]
                                  };
    return parameters;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return [[[respoonse objectForKey:@"result"] objectAtIndex:0] longValue] == 0;
}

- (void)decodeResponse:(id)response {
    NSArray *result = [response objectForKey:@"result"];
    self.sessionToken = [[result objectAtIndex:1] objectForKey:@"ubus_rpc_session"];
    NSDictionary *accessGroup = [result objectAtIndex:1][@"acls"][@"access-group"];
    if ([accessGroup objectForKey:@"superuser"]) {
        [URouterConfig sharedInstance].isUBusNotFullAccess = NO;
        [URouterConfig sharedInstance].isSystemPrepared = YES;
    } else {
        [URouterConfig sharedInstance].isUBusNotFullAccess = YES;
    }
}

@end
