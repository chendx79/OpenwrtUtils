//
//  UWrtCheckUBusApi.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtCheckUBusApi.h"

@interface UWrtCheckUBusApi ()
@property (nonatomic, assign) BOOL isAvailable;
@end

@implementation UWrtCheckUBusApi

- (NSDictionary *)parameters {
    return nil;
}

- (BOOL)isReponseSuccess:(id)respoonse {
    return YES;
}

- (void)decodeResponse:(id)response {
    if ([[response objectForKey:@"jsonrpc"] isEqualToString:@"2.0"]) {
        NSLog(@"路由器支持UBus访问");
        self.isAvailable = YES;
    } else {
        NSLog(@"路由器不支持UBus访问");
        self.isAvailable = NO;
    }
}

- (void)decodeError:(id)error {
    
}

@end
