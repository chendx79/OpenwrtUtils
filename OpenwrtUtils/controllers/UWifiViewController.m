//
//  UWifiViewController.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWifiViewController.h"
#import "URouterConfig.h"

@interface UWifiViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation UWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"无线网络";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backBarButtonPressed:)];

    self.datasource = [NSMutableArray array];

    [self.view addSubview:self.tableView];

    self.wirelessConfig = [[URouterConfig sharedInstance] wirelessConfig];
    self.iwInfoInfo = [[URouterConfig sharedInstance] iwInfoInfo];
    self.wifiClients = [[URouterConfig sharedInstance] wifiClients];
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
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"安全";
    }
    if (section == 3) {
        return @"已连接客户端";
    }
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
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return [self.wifiClients count];
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
            label.text = @"SSID";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.wirelessConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.wirelessConfig[@"ssid"];
                [cell.contentView addSubview:labelValue];
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"加密方式";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.wirelessConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.wirelessConfig[@"encryption"];
                [cell.contentView addSubview:labelValue];
            }
        }
        if (indexPath.row == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"加密算法";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.wirelessConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = @"自动";
                [cell.contentView addSubview:labelValue];
            }
        }
        if (indexPath.row == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"密码";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.wirelessConfig) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                NSMutableString *dottedPassword = [NSMutableString new];
                for (int i = 0; i < [self.wirelessConfig[@"key"] length]; i++) {
                    [dottedPassword appendString:@"●"]; // BLACK CIRCLE Unicode: U+25CF, UTF-8: E2 97 8F
                }
                labelValue.text = dottedPassword;
                [cell.contentView addSubview:labelValue];
            }
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"BSSID";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];

            if (self.iwInfoInfo) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.iwInfoInfo[@"bssid"];
                [cell.contentView addSubview:labelValue];
            }
        }
    }
    if (indexPath.section == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
        label.text = self.wifiClients[indexPath.row][@"name"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:label];

        if (self.iwInfoInfo) {
            UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
            labelValue.textAlignment = NSTextAlignmentRight;
            labelValue.text = self.wifiClients[indexPath.row][@"ip"];
            [cell.contentView addSubview:labelValue];
            
            UILabel *labelElse = [[UILabel alloc] initWithFrame:CGRectMake(120, 31, 250, 10)];
            labelElse.textAlignment = NSTextAlignmentRight;
            labelElse.font = [UIFont fontWithName:@"Arial" size:10];
            labelElse.text = self.wifiClients[indexPath.row][@"mac"];
            [cell.contentView addSubview:labelElse];
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
