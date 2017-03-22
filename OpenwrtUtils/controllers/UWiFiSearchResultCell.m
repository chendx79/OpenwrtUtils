//
//  UWiFiSearchResultCell.m
//  OpenwrtUtils
//
//  Created by lujingyu on 2017/3/22.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import "UWiFiSearchResultCell.h"

#define IMAGE_LOCK           [UIImage imageNamed:@""]
#define IMAGE_WIFI_NORMAL    [UIImage imageNamed:@""]
#define IMAGE_WIFI_CONNECTED [UIImage imageNamed:@""]
#define IMAGE_DETAIL         [UIImage imageNamed:@""]

@interface UWiFiSearchResultCell ()
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *lockView;
@property (nonatomic, strong) UIImageView *wifiView;
@property (nonatomic, strong) UIButton    *detailView;
@end
@implementation UWiFiSearchResultCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.lockView];
        [self.contentView addSubview:self.wifiView];
        [self.contentView addSubview:self.detailView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [self.wifiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.detailView.mas_left).offset(-2);
        }];
        [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.wifiView.mas_left).offset(-2);
        }];
    }
    return self;
}

- (void)configWithData:(URouter *)router {
    self.nameLabel.text = router.ssid;
    self.lockView.image = router.isEncrypt?IMAGE_LOCK:nil;
    self.wifiView.image = router.isConnected?IMAGE_WIFI_NORMAL:IMAGE_WIFI_CONNECTED;
}

- (void)actionDetail:(id)sender {
    if (self.tapDetailBlock) {
        self.tapDetailBlock();
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIImageView *)lockView {
    if (!_lockView) {
        _lockView = [[UIImageView alloc] init];
    }
    return _lockView;
}

- (UIImageView *)wifiView {
    if (!_wifiView) {
        _wifiView = [[UIImageView alloc] init];
    }
    return _wifiView;
}

- (UIButton *)detailView {
    if (!_detailView) {
        _detailView = [[UIButton alloc] init];
        [_detailView setBackgroundImage:IMAGE_DETAIL forState:UIControlStateNormal];
        [_detailView addTarget:self action:@selector(actionDetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailView;
}

@end
