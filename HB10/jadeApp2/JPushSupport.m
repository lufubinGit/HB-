//
//  JPushSupport.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "JPushSupport.h"
#import "JPUSHService.h"
#import "EBForeNotification.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"

@class UNNotificationResponse;

@implementation JPushSupport

+ (JPushSupport*)shareinstance{
    static JPushSupport* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[JPushSupport alloc] init];
    });
    return sharedSupport;
}

+ (void)initJPushWith:(NSDictionary *)launchOptions{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //1 配置远程推送收到消息后的状态:有脚标 有声音 有弹框
    UIUserNotificationSettings *set = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    //2 将配置添加进远程托送的设置中
    [[UIApplication sharedApplication]registerUserNotificationSettings:set];
    //3 注册远程推送
    [[UIApplication sharedApplication]registerForRemoteNotifications];

    
    
#else
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
#endif

    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_10_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。.
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

}

+ (void)JpushRegisterDevice:(NSData *)deviceToken{

    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);

}

+ (void)JpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
  
    if([JDAppGlobelTool shareinstance].enableNotic){
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS6及以下系统，收到通知:%@", [[JPushSupport shareinstance] JNSLogDic:userInfo]);
    }

}

+ (void)JPushHandleReceiveNotification:(NSDictionary *)userInfo application:(UIApplication *)application fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if([JDAppGlobelTool shareinstance].enableNotic){
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS7及以上系统，收到通知:%@", [[JPushSupport shareinstance] JNSLogDic:userInfo]);
        [JPushSupport localPushApplication:application notification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}


/* 接到推送之后 在本地的推送中也进行一个推送 */
+ (void)localPushApplication:(UIApplication *)application notification:(NSDictionary *)userInfo {
    
    BOOL isIOS10 = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        isIOS10 = YES;
    }

    [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:isIOS10];
    
}

+ (void)JpushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if([[UIDevice currentDevice].systemVersion integerValue] < 10){
        [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    }
}

+ (NSString *)JPushGetId{

    return [JPUSHService registrationID];
}

- (NSString *)JNSLogDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =[NSPropertyListSerialization
                    propertyListWithData:tempData
                    options:NSPropertyListImmutable
                    format:nil
                    error:nil];
    return str;
}

#ifdef NSFoundationVersionNumber_iOS_10_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif



@end
