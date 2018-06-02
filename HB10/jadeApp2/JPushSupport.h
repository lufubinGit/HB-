//
//  JPushSupport.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "JPUSHService.h"


@interface JPushSupport : NSObject <JPUSHRegisterDelegate>

+ (JPushSupport*)shareinstance;

+ (void)initJPushWith:(NSDictionary *)launchOptions;

//通知被点击之后 调用
+ (void)JPushHandleReceiveNotification:(NSDictionary *)userInfo application:(UIApplication *)application fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

//接受到消息通知知乎调用
+ (void)JpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

//推送 注册设备
+ (void)JpushRegisterDevice:(NSData *)deviceToken;

//接收 本地通知消息
+ (void)JpushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

//获取推送的ID
+ (NSString *)JPushGetId;

//推送本地的通知
+ (void)localPushApplication:(UIApplication *)application notification:(NSDictionary *)userInfo;
@end
