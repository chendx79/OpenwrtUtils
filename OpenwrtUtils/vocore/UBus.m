//
//  UBus.m
//  OpenwrtUBus
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBus.h"
#import "Utils.h"

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
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        rootPassword = [data objectForKey:@"rootPassword"];
        URLString = [NSString stringWithFormat:@"http://%@/ubus", [[Utils sharedInstance] GetGetwayIP]];
    }

    return self;
}

- (void)CheckUBus {
    NSDictionary *parameters = @{};
    [self SendPost:parameters CurrentAction:CheckUBus];
}

- (void)Login {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ @"00000000000000000000000000000000",
                                                 @"session",
                                                 @"login",
                                                 @{@"username" : @"root",
                                                   @"password" : rootPassword} ]
    };
    [self SendPost:parameters CurrentAction:Login];
}

- (void)GetLanConfig {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"network",
                                                   @"section" : @"lan"} ]
    };
    [self SendPost:parameters CurrentAction:GetLanConfig];
}

- (void)GetWanStatus {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"network.interface.wan",
                                                 @"status",
                                                 @{} ]
    };
    [self SendPost:parameters CurrentAction:GetWanStatus];
}

- (void)GetWirelessConfig {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"wireless"} ]
    };
    [self SendPost:parameters CurrentAction:GetWirelessConfig];
}

- (void)ScanWifi {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"iwinfo",
                                                 @"scan",
                                                 @{@"device" : @"radio0"} ]
    };
    [self SendPost:parameters CurrentAction:ScanWifi];
}

- (BOOL)isSuccess:(NSDictionary *)data {
    long t = [[[data objectForKey:@"result"] objectAtIndex:0] longValue];
    if (t == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)SendPost:(NSDictionary *)parameters CurrentAction:(Action)action {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];

    [session POST:URLString
        parameters:parameters
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
          if (action == CheckUBus) {
              if ([[responseObject objectForKey:@"jsonrpc"] isEqualToString:@"2.0"]) {
                  NSLog(@"路由器支持UBus访问");
                  [self Login];
              } else {
                  NSLog(@"路由器不支持UBus访问");
              }
          }
          if ([self isSuccess:responseObject]) {
              NSArray *result = [responseObject objectForKey:@"result"];
              dispatch_async(dispatch_get_main_queue(), ^{
                //处理result
                switch (action) {
                    case Login:
                        sessionToken = [[result objectAtIndex:1] objectForKey:@"ubus_rpc_session"];
                        NSLog(@"sessionToken=%@", sessionToken);
                        [self GetLanConfig];
                        break;
                    case GetLanConfig:
                        lanConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        NSLog(@"lanConfig=%@", lanConfig);
                        [self GetWanStatus];
                        break;
                    case GetWanStatus:
                        wanStatus = [result objectAtIndex:1];
                        NSLog(@"wanStatus=%@", wanStatus);
                        [self GetWirelessConfig];
                        break;
                    case GetWirelessConfig:
                        wirelessConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        NSLog(@"wirelessConfig=%@", wirelessConfig);
                        [self ScanWifi];
                        break;
                    case ScanWifi:
                        apList = [result objectAtIndex:1];
                        NSLog(@"apList=%@", apList);
                        break;
                    default:
                        break;
                }
              });
          } else { //返回错误
              NSLog(@"返回错误：%@", responseObject);
              dispatch_async(dispatch_get_main_queue(), ^{
                //处理result
                switch (action) {
                    case Login:
                        NSLog(@"登录出错");
                        break;
                    case GetLanConfig:
                        break;
                    case GetWanStatus:
                        break;
                    case GetWirelessConfig:
                        break;
                    case ScanWifi:
                        break;
                    default:
                        break;
                }
              });
          };
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
          NSLog(@"请求失败");
          if (action == CheckUBus) {
              NSLog(@"路由器不支持UBus访问");
          }
        }];
}

@end
