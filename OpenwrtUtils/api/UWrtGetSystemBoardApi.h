//
//  UWrtGetSystemBoardApi.h
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/5.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"

@interface UWrtGetSystemBoardApi : NSObject <UWrtApiProtocol>
// request
@property (nonatomic, copy) NSString *sessionToken;

// response
@property (nonatomic, strong) NSDictionary *systemBoard;
@end
