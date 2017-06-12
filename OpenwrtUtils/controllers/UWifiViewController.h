//
//  UWifiViewController.h
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBaseViewController.h"

@interface UWifiViewController : UBaseViewController

@property (nonatomic, strong) NSDictionary *wirelessConfig;
@property (nonatomic, strong) NSDictionary *iwInfoInfo;

@end
