//
//  UWanViewController.m
//  OpenwrtUtils
//
//  Created by 陈鼎星 on 2017/5/15.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWanViewController.h"
#import "URouterConfig.h"

@interface UWanViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation UWanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"公网";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backBarButtonPressed:)];

    self.datasource = [NSMutableArray array];

    [self.view addSubview:self.tableView];

    self.wanStatus = [[URouterConfig sharedInstance] wanStatus];
    self.networkState = [[URouterConfig sharedInstance] networkState];
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
    if (section == 0) {
        return @"IP地址";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.wanStatus[@"proto"] isEqualToString:@"dhcp"]) {
            return 5;
        }
        if ([self.wanStatus[@"proto"] isEqualToString:@"static"]) {
            return 6;
        }
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([self.wanStatus[@"proto"] isEqualToString:@"dhcp"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                NSArray *segmentArray = @[
                                          @"DHCP",
                                          @"静态"
                                          ];
                UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
                segmentControl.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 30);
                segmentControl.selectedSegmentIndex = 0;
                
                [cell.contentView addSubview:segmentControl];
            }
            if (indexPath.row == 1) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
                label.text = @"IP地址";
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.contentView addSubview:label];
                
                if (self.wanStatus) {
                    UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                    labelValue.textAlignment = NSTextAlignmentRight;
                    labelValue.text = self.wanStatus[@"ipv4-address"][0][@"address"];
                    [cell.contentView addSubview:labelValue];
                }
            }
            if (indexPath.row == 2) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
                label.text = @"路由器";
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.contentView addSubview:label];
                
                if (self.wanStatus) {
                    UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                    labelValue.textAlignment = NSTextAlignmentRight;
                    labelValue.text = self.wanStatus[@"route"][0][@"target"];
                    [cell.contentView addSubview:labelValue];
                }
            }
            if (indexPath.row == 3) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
                label.text = @"DNS";
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.contentView addSubview:label];
                
                if (self.wanStatus) {
                    UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                    labelValue.textAlignment = NSTextAlignmentRight;
                    labelValue.text = [self.wanStatus[@"dns-server"] componentsJoinedByString:@","];
                    [cell.contentView addSubview:labelValue];
                }
            }
            if (indexPath.row == 4) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
                label.text = @"主机名";
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.contentView addSubview:label];
                
                if (self.networkState) {
                    UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                    labelValue.textAlignment = NSTextAlignmentRight;
                    labelValue.text = self.networkState[@"wan"][@"hostname"];
                    [cell.contentView addSubview:labelValue];
                }
            }
        }
    }
    if ([self.wanStatus[@"proto"] isEqualToString:@"static"]) {
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 150, 21)];
            label.text = @"MAC地址";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:label];
            
            if (self.networkState) {
                UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 250, 21)];
                labelValue.textAlignment = NSTextAlignmentRight;
                labelValue.text = self.networkState[@"wan"][@"macaddr"];
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
