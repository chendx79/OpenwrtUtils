//
//  UBus.m
//  OpenwrtUBus
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBus.h"

@implementation UBus

static UBus *_sharedInstance = nil;
static BOOL _bypassAllocMethod = YES;

+ (id)sharedInstance {
    @synchronized([UBus class]) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[UBus alloc] init];
        }
    }
    return _sharedInstance;
}

+ (id)alloc {
    @synchronized([UBus class]) {
        _bypassAllocMethod = NO; // EDIT #2
        if (_sharedInstance == nil) {
            _sharedInstance = [super alloc];
            return _sharedInstance;
        } else {
            // EDIT #1 : you could throw an exception here to avoid the double allocation of the UBus class
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"<%@: %p> Double allocation issue", [_sharedInstance class], _sharedInstance] reason:@"You cannot allocate the singeton class twice or more." userInfo:nil];
        }
    }
    return nil;
}

// EDIT #2 : the init method
- (id)init {
    if (_bypassAllocMethod)
        @throw [NSException exceptionWithName:@"invalid allocation" reason:@"invalid allocation" userInfo:nil];
    
    if (self = [super init]) {
        
    }
    
    return self;
}


- (void)Login{
    NSDictionary *parameters = @{@"jsonrpc": @"2.0",
                                 @"id": @1,
                                 @"method": @"call",
                                 @"params": @[@"00000000000000000000000000000000", @"session", @"login", @{ @"username": @"root", @"password": @"yourPassword"}]};
    [self SendPost:parameters CurrentAction:Login];
}

- (void)GetLanConfig{
    // sessionToken为空的情况可能会导致"params"字段没值，所以需对sessionToken做空判断
    NSDictionary *parameters = @{@"jsonrpc": @"2.0",
                                 @"id": @1,
                                 @"method": @"call",
                                 @"params": @[sessionToken, @"uci", @"get", @{ @"config": @"network", @"section": @"lan"}]};
    [self SendPost:parameters CurrentAction:GetLanConfig];
}

- (BOOL)isSuccess:(NSDictionary*)data
{
    long t = [[[data objectForKey:@"result" ] objectAtIndex:0] longValue];
    if (t == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)SendPost:(NSDictionary *)parameters CurrentAction:(Action)action{
    NSString *URLString = @"http://192.168.10.244/ubus";
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [session POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self isSuccess:responseObject]){
            NSArray *result = [responseObject objectForKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //处理result
                switch (action) {
                    case Login:
                        sessionToken = [[result objectAtIndex:1] objectForKey:@"ubus_rpc_session"];
                        if (sessionToken.length > 0) {
                            NSLog(@"sessionToken=%@", sessionToken);
                            [self GetLanConfig];
                        }
                        else {
                            NSLog(@"sessionToken is null");
                        }
                        break;
                    case GetLanConfig:
                        lanConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        NSLog(@"lanConfig=%@", lanConfig);
                        break;
                    default:
                        break;
                }
            });
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

@end
