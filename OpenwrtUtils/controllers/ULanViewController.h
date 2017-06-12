//
//  ULanViewController.h
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBaseViewController.h"

@interface ULanViewController : UBaseViewController

@property (nonatomic, strong) NSDictionary *networkState;
@property (nonatomic, strong) NSString *lanDHCP;

@end
