//
//  UWiFiSearchResultCell.h
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/22.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URouter.h"

@interface UWiFiSearchResultCell : UITableViewCell
- (void)configWithData:(URouter *)router;
@property (nonatomic, copy) void (^tapDetailBlock)(void);
@end
