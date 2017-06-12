//
//  UWrtGetNetworkStateApi.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/6/12.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"

@interface UWrtGetNetworkStateApi : NSObject <UWrtApiProtocol>
// request
@property (nonatomic, copy) NSString *sessionToken;

// response
@property (nonatomic, copy) NSDictionary *networkState;
@end
