//
//  BpushSupport.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/9.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPush.h"

#define BpushAppID @"8611309"
#define BpushAPIKey @"ccp4nENnY3C7vb7HwwhWfd0n"



//***********************关于如何设置badge角标加1的方法***********************

/*
 服务端推送的badge是几就会显示几,你只需要跟服务端同步消息数目，然后让服务端自己，该推送几，就推送几,比如你应用打开的时候，或者进入后台的时候跟服务端同步，这个点，需要你们自己去设计，应用没有消息的时候，服务端推送了1，当应用打开时候，告诉服务端，app没点击通知，那下次应用推送2,依次类推。
 */


@interface BpushSupport : NSObject

//单例
+ (BpushSupport*)shareinstance;

//初始化 包涵设置百度云的推送和注册远程推送
+ (void)initBPushWith:(NSDictionary *)launchOptions;

//通知被点击之后 调用
+ (void)BPushHandleReceiveNotification:(NSDictionary *)userInfo application:(UIApplication *)application fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

//接受到消息通知知乎调用
+ (void)BpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

// 推送 注册设备
+ (void)BpushRegisterDevice:(NSData *)deviceToken;

//本地通知
+ (void)BpushLocalNoti;

//接收 本地通知消息
+ (void)BpushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;



//+ (void)BPushHandleReceiveNotification:(NSDictionary *)userInfo;
//+ (void)BPushHandleLaunching:(NSDictionary *)launchOptions;
//+ (void)BPushUnRegisterDevice;
@end
