//
//  UWrtHttpEngine.m
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWrtHttpEngine.h"
#import "AFNetworking.h"
#import "Utils.h"

@interface UWrtHttpEngine ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation UWrtHttpEngine

+ (UWrtHttpEngine *)sharedInstance {
    static UWrtHttpEngine *instance = nil;
    @synchronized (self) {
        if (!instance) {
            instance = [[[self class] alloc] init];
        }
    }
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        self.session = session;
    }
    return self;
}

- (NSString *)url {
    NSString *gatewayIP = [[Utils sharedInstance] GetGetwayIP];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/ubus", gatewayIP];
    
    //for test
    //URLString = @"http://192.168.20.183/ubus";
    //gatewayIP = @"192.168.20.183";

    return urlString;
}

- (void)post:(id<UWrtApiProtocol>)api result:(void (^)(BOOL rst, id obj))result {
    [self.session POST:[self url] parameters:[api parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL requestResult = NO;
        if ([api isReponseSuccess:responseObject]) {
            [api decodeResponse:responseObject];
            requestResult = YES;
        }
        else {
            [api decodeError:nil];
            requestResult = NO;
        }
        if (result) {
            result(requestResult, api);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([api respondsToSelector:@selector(decodeError:)]) {
            [api decodeError:error];
        }
        if (result) {
            result(NO, api);
        }
    }];
}

@end
