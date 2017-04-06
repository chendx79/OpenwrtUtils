//
//  UWrtApiProtocol.h
//  OpenwrtUtils
//
//  Created by coconut on 2017/4/6.
//  Copyright © 2017年 陈鼎星. All rights reserved.
//

#ifndef UWrtApiProtocol_h
#define UWrtApiProtocol_h

@protocol UWrtApiProtocol <NSObject>
@required
- (NSDictionary *)parameters;
- (BOOL)isReponseSuccess:(id)respoonse;
- (void)decodeResponse:(id)response;
@optional
- (void)decodeError:(id)error;
@end

#endif /* UWrtApiProtocol_h */
