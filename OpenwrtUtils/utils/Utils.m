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

@end
