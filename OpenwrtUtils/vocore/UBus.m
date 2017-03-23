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

- (void)GetLanDHCP {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"dhcp",
                                                   @"section" : @"lan"} ]
                                  };
    [self SendPost:parameters CurrentAction:GetLanDHCP];
}

- (void)GetSSHStatus {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"dropbear"} ]
                                  };
    [self SendPost:parameters CurrentAction:GetSSHStatus];
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

- (void)GetShadowsocksConfig {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"get",
                                                 @{@"config" : @"shadowsocks"} ]
                                  };
    [self SendPost:parameters CurrentAction:GetShadowsocksConfig];
}

- (void)GetPdnsdConfig {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"file",
                                                 @"read",
                                                 @{@"path" : @"/etc/pdnsd.conf"} ]
                                  };
    [self SendPost:parameters CurrentAction:GetPdnsdConfig];
}

- (void)ScanWifi {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"iwinfo",
                                                 @"scan",
                                                 @{@"device" : wifiDevice} ]
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
                        NSLog(@"登录成功，sessionToken=%@", sessionToken);
                        [self GetLanConfig];
                        break;
                    case GetLanConfig:
                        lanConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        //NSLog(@"lanConfig=%@", lanConfig);
                        NSLog(@"内网配置如下：");
                        NSLog(@"网关地址=%@", [lanConfig objectForKey:@"ipaddr"]);
                        [self GetLanDHCP];
                        break;
                    case GetLanDHCP:
                        lanDHCP = [[[[result objectAtIndex:1] objectForKey:@"values"] objectForKey:@"dhcp_option"] objectAtIndex:0];
                        //NSLog(@"lanDHCP=%@", lanDHCP);
                        if ([lanDHCP componentsSeparatedByString:@","].count > 1) {
                            NSLog(@"DHCP=%@", [lanDHCP componentsSeparatedByString:@","][1]);
                        }
                        [self GetSSHStatus];
                        break;
                    case GetSSHStatus:
                        sshStatus = [[result objectAtIndex:1] objectForKey:@"values"];
                        sshStatus = [sshStatus objectForKey:[sshStatus allKeys][0]];
                        //NSLog(@"sshStatus=%@", sshStatus);
                        NSLog(@"SSH状态=%@, 端口号=%@", [sshStatus objectForKey:@"PasswordAuth"], [sshStatus objectForKey:@"Port"]);
                        [self GetWanStatus];
                        break;
                    case GetWanStatus:
                        wanStatus = [result objectAtIndex:1];
                        //NSLog(@"wanStatus=%@", wanStatus);
                        NSLog(@"外网配置如下：");
                        NSLog(@"类型=%@", [wanStatus objectForKey:@"proto"]);
                        NSLog(@"IP地址=%@", [[[wanStatus objectForKey:@"ipv4-address"] objectAtIndex:0] objectForKey:@"address"]);
                        NSLog(@"DNS地址=%@", [wanStatus objectForKey:@"dns-server"]);
                        [self GetWirelessConfig];
                        break;
                    case GetWirelessConfig:
                        wirelessConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        //NSLog(@"wirelessConfig=%@", wirelessConfig);
                        for (int i = 0; i < [wirelessConfig allKeys].count; i++) {
                            NSString *key = [wirelessConfig allKeys][i];
                            NSDictionary *value = [wirelessConfig objectForKey:key];
                            //NSLog(@"%@ = %@", key, value);
                            if ([[value objectForKey:@".type"] isEqualToString:@"wifi-iface"]) {
                                NSLog(@"Wifi配置：SSID=%@, 加密方式=%@, 密码=%@", [value objectForKey:@"ssid"], [value objectForKey:@"encryption"], [value objectForKey:@"key"]);
                                wifiDevice = [value objectForKey:@"device"];
                                //NSLog(@"wifi设备=%@", [value objectForKey:@"device"]);
                            }
                        }
                        [self GetShadowsocksConfig];
                        break;
                    case GetShadowsocksConfig:
                        shadowsocksConfig = [[result objectAtIndex:1] objectForKey:@"values"];
                        shadowsocksConfig = [shadowsocksConfig objectForKey:[shadowsocksConfig allKeys][0]];
                        //NSLog(@"shadowsocksConfig=%@", shadowsocksConfig);
                        NSLog(@"Shadowsocks配置：状态=%@, 服务器=%@, 服务器端口=%@, 密码=%@, 加密方式=%@", [shadowsocksConfig objectForKey:@"enable"], [shadowsocksConfig objectForKey:@"server"], [shadowsocksConfig objectForKey:@"server_port"], [shadowsocksConfig objectForKey:@"password"], [shadowsocksConfig objectForKey:@"encrypt_method"]);
                        [self GetPdnsdConfig];
                        break;
                    case GetPdnsdConfig:
                        pdnsdConfig = [[result objectAtIndex:1] objectForKey:@"data"];
                        NSLog(@"pdnsdConfig=\n%@", pdnsdConfig);
                        [self ScanWifi];
                        break;
                    case ScanWifi:
                        apList = [[result objectAtIndex:1] objectForKey:@"results"];
                        //NSLog(@"apList=%@", apList);
                        NSLog(@"搜索到的无线热点如下：");
                        for (int i = 0; i < apList.count; i++) {
                            NSDictionary *ap = apList[i];
                            NSLog(@"SSID=%@， 信号=%@/%@， MAC地址=%@， 认证方式=%@", [ap objectForKey:@"ssid"], [ap objectForKey:@"quality"], [ap objectForKey:@"quality_max"], [ap objectForKey:@"bssid"], [[[ap objectForKey:@"encryption"] objectForKey:@"authentication"] objectAtIndex:0]);
                        }
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
                        NSLog(@"登录失败");
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
