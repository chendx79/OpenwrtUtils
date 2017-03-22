//
//  URouter.h
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URouter : NSObject
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isEncrypt;
+ (URouter *)routerWithInfo:(NSDictionary *)info;
@end
