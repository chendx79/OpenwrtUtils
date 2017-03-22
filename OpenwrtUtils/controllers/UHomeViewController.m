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
    self.navigationItem.title = @"Openwrt实用工具";
    [[UBus sharedInstance] CheckUBus];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"openwrtbox"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSearchWiFi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(100);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (void)actionSearchWiFi {
    USearchWiFiViewController *vc = [[USearchWiFiViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
