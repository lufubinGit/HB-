//
//  XGPushSupport.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/9.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGPush.h"

@interface XGPushSupport : NSObject

+ (XGPushSupport*)shareinstance;
+ (void)initXGPush;
+ (void)XGPushRegisterDevice:(NSData *)Token;
+ (void)XgPushHandleReceiveNotification:(NSDictionary *)userInfo;
+ (void)XgPushHandleLaunching:(NSDictionary *)launchOptions;
+ (void)XGPushUnRegisterDevice;

@end
