//
//  UBus.m
//  OpenwrtUBus
//
//  Created by 陈鼎星 on 2017/3/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "Utils.h"

@implementation Utils

static Utils *_sharedInstance = nil;
static BOOL _bypassAllocMethod = YES;

+ (id)sharedInstance {
    @synchronized([Utils class]) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[Utils alloc] init];
        }
    }
    return _sharedInstance;
}

+ (id)alloc {
    @synchronized([Utils class]) {
        _bypassAllocMethod = NO; // EDIT #2
        if (_sharedInstance == nil) {
            _sharedInstance = [super alloc];
            return _sharedInstance;
        } else {
            // EDIT #1 : you could throw an exception here to avoid the double allocation of the Utils class
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

#define CTL_NET 4 /* network, see socket.h */
#define ROUNDUP(a) \
    ((a) > 0 ? (1 + (((a)-1) | (sizeof(long) - 1))) : sizeof(long))

- (NSString *)GetLocalIP {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free memory
    freeifaddrs(interfaces);

    if (!address || [address length] == 0) {
        address = @"127.0.0.1";
    }

    assert(address && [address length] > 0);
    return address;
}

- (NSString *)GetGetwayIP {
    NSString *address = nil;

    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
                 NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char *buf, *p;
    struct rt_msghdr *rt;
    struct sockaddr *sa;
    struct sockaddr *sa_tab[RTAX_MAX];
    int i;
    int r = -1;

    if (sysctl(mib, sizeof(mib) / sizeof(int), 0, &l, 0, 0) < 0) {
        address = @"192.168.0.1";
    }

    if (l > 0) {
        buf = malloc(l);
        if (sysctl(mib, sizeof(mib) / sizeof(int), buf, &l, 0, 0) < 0) {
            address = @"192.168.0.1";
        }

        for (p = buf; p < buf + l; p += rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for (i = 0; i < RTAX_MAX; i++) {
                if (rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }

            if (((rt->rtm_addrs & (RTA_DST | RTA_GATEWAY)) == (RTA_DST | RTA_GATEWAY)) && sa_tab[RTAX_DST]->sa_family == AF_INET && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                unsigned char octet[4] = {0, 0, 0, 0};
                int i;
                for (i = 0; i < 4; i++) {
                    octet[i] = (((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >> (i * 8)) & 0xFF;
                }
                if (((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    in_addr_t addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                    r = 0;
                    address = [NSString stringWithFormat:@"%s", inet_ntoa(*((struct in_addr *)&addr))];
                    break;
                }
            }
        }
        free(buf);
    }
    return address;
}

- (BOOL)SSHLogin:(NSString *)ip Port:(NSString *)port Username:(NSString *)username Password:(NSString *)password{
    host = [NSString stringWithFormat:@"%@:%@", ip, port];
    session = [NMSSHSession connectToHost:host withUsername:username];
    
    if (session.isConnected) {
        [session authenticateByPassword:password];
        
        if (session.isAuthorized) {
            NSLog(@"Authentication succeeded");
            return YES;
        }
    }
    return NO;
}

- (BOOL)SystemPrepare{
    if (session.isConnected) {
        NSError *error = nil;
        NSString *response;

        //开启root的全部ubus权限
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"superuser.json" ofType:nil];
            BOOL success = [session.channel uploadFile:filePath to:@"/usr/share/rpcd/acl.d/superuser.json"];
            if (success) {
                NSLog(@"上传superuser.json到路由器成功");//ubus重新登录生效，不需要重启
            }
        }

        //上传show_wifi_clients.sh脚本到/sbin
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"show_wifi_clients.sh" ofType:nil];
            BOOL success = [session.channel uploadFile:filePath to:@"/sbin/show_wifi_clients.sh"];
            if (success) {
                NSLog(@"上传show_wifi_clients.sh到路由器成功");
                response = [session.channel execute:@"chmod +x /sbin/show_wifi_clients.sh" error:&error];
                NSLog(@"%@", response);
                NSLog(@"成功给予show_wifi_clients.sh脚本可执行权限");//可以获取无线客户端列表，不需要重启
            }
        }

        response = [session.channel execute:@"opkg update" error:&error];//更新opkg
        NSLog(@"%@", response);
        response = [session.channel execute:@"opkg install rpcd-mod-iwinfo rpcd-mod-file iwinfo" error:&error];//安装wifi访问模块和文件访问模块
        NSLog(@"%@", response);
        response = [session.channel execute:@"/etc/init.d/rpcd restart && /etc/init.d/uhttpd restart" error:&error];//重启ubus
        NSLog(@"%@", response);

        return YES;
    }

    return NO;
}

- (NSDictionary *)GetDiskInfo{
    if (session.isConnected) {
        NSError *error = nil;
        
        NSString *response;
        response = [session.channel execute:@"df -h|grep rootfs" error:&error];
        NSArray* respArray = [response componentsSeparatedByString: @" "];
        NSMutableArray* diskInfoArray = [[NSMutableArray alloc] init];
        for(NSString *s in respArray){
            if (![s isEqual: @""]) {
                [diskInfoArray addObject:s];
            }
        }
        NSDictionary *diskInfo = [[NSDictionary alloc]initWithObjectsAndKeys:diskInfoArray[1], @"total", diskInfoArray[2], @"used", diskInfoArray[3] , @"available", diskInfoArray[4], @"usedPercent", nil];
        
        return diskInfo;
    }
    return nil;
}

- (NSArray *)GetWifiClients {
    if (session.isConnected) {
        NSError *error = nil;
        
        NSString *response;
        response = [session.channel execute:@"show_wifi_clients.sh" error:&error];
        NSArray* respArray = [response componentsSeparatedByString: @"\n"];
        NSMutableArray* wifiClients = [[NSMutableArray alloc] init];
        for(NSString *s in respArray){
            if (![s isEqual: @""]) {
                NSArray* client = [s componentsSeparatedByString: @"\t"];
                NSDictionary *clientInfo = [[NSDictionary alloc]initWithObjectsAndKeys:client[0], @"ip", client[1], @"name", client[2] , @"mac", nil];
                [wifiClients addObject:clientInfo];
            }
        }

        return wifiClients;
    }
    return nil;
}

@end
