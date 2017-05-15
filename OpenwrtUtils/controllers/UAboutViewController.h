//
//  UAboutViewController.h
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/5/5.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UBaseViewController.h"

@interface UAboutViewController : UBaseViewController

@property (nonatomic, strong) NSDictionary *systemInfo;
@property (nonatomic, strong) NSDictionary *systemBoard;
@property (nonatomic, strong) NSDictionary *diskInfo;

@end
