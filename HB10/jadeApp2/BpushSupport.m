//
//  BpushSupport.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/9.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BpushSupport.h"
static BOOL isBackGroundActivateApplication;

@implementation BpushSupport
+ (BpushSupport*)shareinstance{
    static BpushSupport* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[BpushSupport alloc] init];
    });
    return sharedSupport;
}

+ (void)initBPushWith:(NSDictionary *)launchOptions{
    
    
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
// 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BpushAPIKey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:nil useBehaviorTextInput:YES isDebug:YES];
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    //角标清0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


+ (void)BpushLocalNoti{
    NSLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil useBehaviorTextInput:YES];
}
+ (void)BpushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
    
}


// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
+ (void)BPushHandleReceiveNotification:(NSDictionary *)userInfo application:(UIApplication *)application fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"acitve ");
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
//        SkipViewController *skipCtr = [[SkipViewController alloc]init];
//        // 根视图是nav 用push 方式跳转
//        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
//        NSLog(@"applacation is unactive ===== %@",userInfo);
//        /*
//         // 根视图是普通的viewctr 用present跳转
//         [_tabBarCtr.selectedViewController presentViewController:skipCtr animated:YES completion:nil]; */
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
//        NSLog(@"background is Activated Application ");
//        // 此处可以选择激活应用提前下载邮件图片等内容。
//        isBackGroundActivateApplication = YES;
//        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
    }
    
    NSLog(@"%@",userInfo);

}
+ (void)BpushRegisterDevice:(NSData *)deviceToken{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            NSLog(@"==%@",myChannel_id);
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"result ============== %@",result);
                }
            }];
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
}

+ (void)BpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
     
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
      
    }
    NSLog(@"%@",userInfo);
}

@end
