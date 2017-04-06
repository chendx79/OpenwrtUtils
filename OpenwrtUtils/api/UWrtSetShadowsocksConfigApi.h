//
//  UWrtSetShadowsocksConfigApi.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"

@interface UWrtSetShadowsocksConfigApi : NSObject <UWrtApiProtocol>
// request
@property (nonatomic, copy) NSString *sessionToken;
@property (nonatomic, copy) NSString *serverAddr;
@property (nonatomic, copy) NSString *serverPort;
@property (nonatomic, copy) NSString *password;

// response
@end
