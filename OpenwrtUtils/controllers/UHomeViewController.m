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
    NSLog(@"CheckUBus started...");
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"openwrtbox"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSearchWiFi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(100);
    }];
    
    [self showLoading];
    [[UBus sharedInstance] checkUBusAvailable:^(BOOL available) {
        [self hideLoading];
        NSString *message = nil;
        if (available) {
            message = @"路由器支持UBus访问";
        }
        else {
            message = @"路由器不支持UBus访问";
        }
        [self toast:message];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toast:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

#pragma mark - actions

- (void)actionSearchWiFi {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *pwdField = [alertView textFieldAtIndex:0];
        [[UBus sharedInstance] loginWithPassword:pwdField.text result:^(BOOL success) {
            if (success) {
                USearchWiFiViewController *vc = [[USearchWiFiViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self toast:@"登录失败"];
            }
        }];
    }
}

@end
