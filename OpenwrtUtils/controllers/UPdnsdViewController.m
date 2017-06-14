//
//  UPdnsdViewController.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/6/14.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UPdnsdViewController.h"
#import "URouterConfig.h"

@interface UPdnsdViewController () <UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation UPdnsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Pdnsd";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backBarButtonPressed:)];

    [self.view addSubview:self.textView];

    self.pdnsdConfig = [[URouterConfig sharedInstance] pdnsdConfig];

    self.textView.text = self.pdnsdConfig;
}

- (void)backBarButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate


#pragma mark -

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.font = [UIFont fontWithName:@"Arial" size:12.0];
        _textView.delegate = self;
    }
    return _textView;
}

@end
