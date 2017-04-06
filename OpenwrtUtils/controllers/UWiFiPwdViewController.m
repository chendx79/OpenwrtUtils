//
//  UWiFiPwdViewController.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/20.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWiFiPwdViewController.h"

@interface UWiFiPwdViewController ()
@property (nonatomic, strong) URouter *router;
@end

@implementation UWiFiPwdViewController

- (instancetype)initWithRouter:(URouter *)router {
    if (self = [super init]) {
        self.router = router;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"取消" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(30);
    }];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setTitle:@"完成" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done];
    [done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(30);
    }];
    
    UITextField *textfield = [[UITextField alloc] init];
    [self.view addSubview:textfield];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
