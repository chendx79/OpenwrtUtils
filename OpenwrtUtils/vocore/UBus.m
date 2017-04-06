//
//  UBus.m
//  OpenwrtUBus
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBus.h"
#import "Utils.h"
#import "UWrtHttpEngine.h"

@interface UBus ()
@property (nonatomic, copy) NSString *sessionToken;
@property (nonatomic, copy) NSString *wifiDevice;
@end

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
        ssServer = [data objectForKey:@"ssServer"];
        ssPort = [data objectForKey:@"ssPort"];
        ssPassword = [data objectForKey:@"ssPassword"];
        NSString *gatewayIP = [[Utils sharedInstance] GetGetwayIP];
        URLString = [NSString stringWithFormat:@"http://%@/ubus", gatewayIP];
        //for test
        //URLString = @"http://192.168.20.183/ubus";
        //gatewayIP = @"192.168.20.183";

        //路由器系统做准备
        //[[Utils sharedInstance] SystemPrepare:gatewayIP Port:@"22" Username:@"root" Password:rootPassword];
    }

    return self;
}

- (void)CheckUBus {
    NSDictionary *parameters = @{};
    [self SendPost:parameters CurrentAction:CheckUBus result:NULL];
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
    [self SendPost:parameters CurrentAction:Login result:NULL];
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
    [self SendPost:parameters CurrentAction:GetLanConfig result:NULL];
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
    [self SendPost:parameters CurrentAction:GetLanDHCP result:NULL];
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
    [self SendPost:parameters CurrentAction:GetSSHStatus result:NULL];
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
    [self SendPost:parameters CurrentAction:GetWanStatus result:NULL];
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
    [self SendPost:parameters CurrentAction:GetWirelessConfig result:NULL];
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
    [self SendPost:parameters CurrentAction:GetShadowsocksConfig result:NULL];
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
    [self SendPost:parameters CurrentAction:GetPdnsdConfig result:NULL];
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
    [self SendPost:parameters CurrentAction:ScanWifi result:NULL];
}

- (void)SetShadowsocksConfig:(NSString *)serverAddr ServerPort:(NSNumber *)serverPort Password:(NSString *)password {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"set",
                                                 @{@"config" : @"shadowsocks",
                                                   @"type" : @"shadowsocks",
                                                   @"values" : @{@"server" : serverAddr,
                                                                 @"server_port" : serverPort,
                                                                 @"password" : password}} ]
    };
    [self SendPost:parameters CurrentAction:SetShadowsocksConfig result:NULL];
}

- (void)GetDHCPLeases {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"file",
                                                 @"read",
                                                 @{@"path" : @"/tmp/dhcp.leases"} ]
    };
    [self SendPost:parameters CurrentAction:GetDHCPLeases result:NULL];
}

- (void)Commit:(NSString *)config {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"commit",
                                                 @{@"config" : config} ]
    };
    [self SendPost:parameters CurrentAction:Commit result:NULL];
}

- (void)Apply {
    NSDictionary *parameters = @{ @"jsonrpc" : @"2.0",
                                  @"id" : @1,
                                  @"method" : @"call",
                                  @"params" : @[ sessionToken,
                                                 @"uci",
                                                 @"apply",
                                                 @{@"rollback" : @NO,
                                                   @"timeout" : @10} ]
    };
    [self SendPost:parameters CurrentAction:Apply result:NULL];
}

- (BOOL)isSuccess:(NSDictionary *)data {
    long t = [[[data objectForKey:@"result"] objectAtIndex:0] longValue];
    if (t == UBUS_STATUS_OK) {
        return YES;
    } else {
        return NO;
    }
}

- (void)SendPost:(NSDictionary *)parameters CurrentAction:(Action)action result:(void (^)(BOOL rst, id obj))result {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSLog(@"Sending POST request to %@, parameters = %@", URLString, parameters);
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
                        [self GetDHCPLeases];
                        break;
                    case GetDHCPLeases:
                        DHCPLeases = [[result objectAtIndex:1] objectForKey:@"data"];
                        NSLog(@"DHCPLeases=\n%@", DHCPLeases);
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
                        [self SetShadowsocksConfig:ssServer ServerPort:ssPort Password:ssPassword];
                        break;
                    case SetShadowsocksConfig:
                        //pdnsdConfig = [[result objectAtIndex:1] objectForKey:@"data"];
                        NSLog(@"设置Shadowsocks成功");
                        [self Commit:@"shadowsocks"];
                        break;
                    case Commit:
                        NSLog(@"提交成功");
                        //[self Apply];
                        break;
                    case Apply:
                        NSLog(@"应用成功");
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

#pragma mark - public methods

- (void)checkUBusAvailable:(void (^)(BOOL available))result {
    UWrtCheckUBusApi *api = [UWrtCheckUBusApi new];
    [[UWrtHttpEngine sharedInstance] post:api result:^(BOOL rst, UWrtCheckUBusApi *obj) {
        if (result) {
            result(obj.isAvailable);
        }
    }];
}

- (void)loginWithPassword:(NSString *)password result:(void (^)(BOOL success))result {
    UWrtLoginApi *api = [UWrtLoginApi new];
    api.rootPassword = password;
    [[UWrtHttpEngine sharedInstance] post:api result:^(BOOL rst, UWrtLoginApi *obj) {
        self.sessionToken = obj.sessionToken;
        if (result) {
            result(rst);
        }
    }];
}

- (void)wirelessConfig:(void (^)(void))result {
    UWrtGetWirelessConfigApi *api = [UWrtGetWirelessConfigApi new];
    api.sessionToken = self.sessionToken;
    [[UWrtHttpEngine sharedInstance] post:api result:^(BOOL rst, UWrtGetWirelessConfigApi *obj) {
        self.wifiDevice = obj.wifiDevice;
        if (result) {
            result();
        }
    }];
}

- (void)scanWiFi:(void (^)(NSArray *list))result {
    UWrtScanWiFiApi *api = [UWrtScanWiFiApi new];
    api.sessionToken = self.sessionToken;
    api.wifiDevice = self.wifiDevice;
    [[UWrtHttpEngine sharedInstance] post:api result:^(BOOL rst, UWrtScanWiFiApi *obj) {
        if (result) {
            result(obj.apList);
        }
    }];
}

@end
