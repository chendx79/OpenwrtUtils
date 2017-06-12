//
//  UWrtHttpEngine.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UWrtApiProtocol.h"
#import "UWrtCheckUBusApi.h"
#import "UWrtLoginApi.h"
#import "UWrtGetLanConfigApi.h"
#import "UWrtGetLanDHCPApi.h"
#import "UWrtGetSSHStatusApi.h"
#import "UWrtGetWanStatusApi.h"
#import "UWrtGetWirelessConfigApi.h"
#import "UWrtGetShadowsocksConfigApi.h"
#import "UWrtGetPdnsdConfigApi.h"
#import "UWrtScanWiFiApi.h"
#import "UWrtSetShadowsocksConfigApi.h"
#import "UWrtGetDHCPLeasesApi.h"
#import "UWrtCommitApi.h"
#import "UWrtApplyApi.h"
#import "UWrtGetSystemInfoApi.h"
#import "UWrtGetSystemBoardApi.h"
#import "UWrtGetNetworkStateApi.h"
#import "UWrtGetIWInfoDeviceApi.h"
#import "UWrtGetIWInfoInfoApi.h"

@interface UWrtHttpEngine : NSObject
+ (UWrtHttpEngine *)sharedInstance;
- (void)post:(id<UWrtApiProtocol>)api result:(void (^)(BOOL rst, id obj))result;
@end
