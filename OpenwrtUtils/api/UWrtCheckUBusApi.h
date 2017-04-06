//
//  UWrtCheckUBusApi.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"

@interface UWrtCheckUBusApi : NSObject <UWrtApiProtocol>
// request

// response
@property (nonatomic, readonly) BOOL isAvailable;
@end
