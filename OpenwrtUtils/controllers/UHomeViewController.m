//
//  UHomeViewController.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/17.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UHomeViewController.h"
#import "USearchWiFiViewController.h"
#import "UBus.h"

@interface UHomeViewController ()

@end

@implementation UHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Openwrt使用工具";
    [[UBus sharedInstance] Login];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSearchWiFi {
    USearchWiFiViewController *vc = [[USearchWiFiViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
