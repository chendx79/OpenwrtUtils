//
//  UWrtGetPdnsdConfigApi.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"

@interface UWrtGetPdnsdConfigApi : NSObject <UWrtApiProtocol>
// request
@property (nonatomic, copy) NSString *sessionToken;
// response
@property (nonatomic, copy) NSString *pdnsdConfig;
@end
