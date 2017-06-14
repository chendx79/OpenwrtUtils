//
//  UShadowsocksViewController.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UShadowsocksViewController.h"
#import "URouterConfig.h"

@interface UShadowsocksViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation UShadowsocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Shadowsocks";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backBarButtonPressed:)];

    self.datasource = [NSMutableArray array];

    [self.view addSubview:self.tableView];

    self.shadowsocksConfig = [[URouterConfig sharedInstance] shadowsocksConfig];
}

- (void)backBarButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"启用";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];
            
            UISwitch *enabled = [[UISwitch alloc] initWithFrame:CGRectMake(320, 7, 0, 0)];
            [enabled setOn:NO];
            if (self.shadowsocksConfig) {
                if ([self.shadowsocksConfig[@"enable"] isEqualToString:@"1"]) {
                    [enabled setOn:YES];
                }
            }
            [cell.contentView addSubview:enabled];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"服务器地址";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.shadowsocksConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.shadowsocksConfig[@"server"];
                [cell.contentView addSubview:labelValue];
            }
        }
        if (indexPath.row == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"服务器端口";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];
            
            if (self.shadowsocksConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.shadowsocksConfig[@"server_port"];
                [cell.contentView addSubview:labelValue];
            }
        }
        if (indexPath.row == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"密码";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];
            
            if (self.shadowsocksConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                NSMutableString *dottedPassword = [NSMutableString new];
                for (int i = 0; i < [self.shadowsocksConfig[@"password"] length]; i++) {
                    [dottedPassword appendString:@"●"]; // BLACK CIRCLE Unicode: U+25CF, UTF-8: E2 97 8F
                }
                labelValue.text = dottedPassword;
                [cell.contentView addSubview:labelValue];
            }
        }
        if (indexPath.row == 3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"加密方式";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];
            
            if (self.shadowsocksConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.shadowsocksConfig[@"encrypt_method"];
                [cell.contentView addSubview:labelValue];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
