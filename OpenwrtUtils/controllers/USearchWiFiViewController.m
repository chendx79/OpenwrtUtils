//
//  USearchWiFiViewController.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/17.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "USearchWiFiViewController.h"
#import "UWiFiPwdViewController.h"
#import "URouterConfig.h"
#import "UWiFiSearchResultCell.h"

#define WIFI_OTHER @"其他..."

@interface USearchWiFiViewController () <UITableViewDataSource, UITableViewDelegate, URouterConfigProtocol>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation USearchWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"搜索无线热点";
    
    self.datasource = [NSMutableArray array];
    [self.datasource addObject:WIFI_OTHER];
    [self.view addSubview:self.tableView];
    
    [[URouterConfig sharedInstance] searchingRouters:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionInputPassword:(URouter *)router {
    UWiFiPwdViewController *vc = [[UWiFiPwdViewController alloc] init];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)actionGoToDetail:(URouter *)router {
    
}

- (void)actionGoToOther {
    
}

- (void)routerConfig:(URouterConfig *)router didSearchRouters:(NSArray *)routers {
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:routers];
    [self.datasource addObject:WIFI_OTHER];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = [self.datasource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[URouter class]]) {
        [self actionInputPassword:obj];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        [self actionGoToOther];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.datasource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[URouter class]]) {
        static NSString *identifier = @"UWiFiSearchResultCell";
        UWiFiSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UWiFiSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        URouter *router = (URouter *)obj;
        [cell configWithData:router];
        
        @weakify(self);
        cell.tapDetailBlock = ^() {
            @strongify(self);
            [self actionGoToDetail:router];
        };
        return cell;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        static NSString *identifier = @"other";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *text = (NSString *)obj;
        cell.textLabel.text = text;
        return cell;
    }
    else {
        static NSString *identifier = @"xxx";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
        header.backgroundColor = [UIColor lightGrayColor];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CGRectGetHeight(header.frame))];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = @"选取网络";
        lb.font = [UIFont systemFontOfSize:13];
        [header addSubview:lb];
        return header;
    }
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
