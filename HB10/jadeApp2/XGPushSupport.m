//
//  XGPushSupport.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/9.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "XGPushSupport.h"
#import "XGPush.h"

#define XGPushAppID @"2200219068"
#define XGPushAppKey @"I5JHT2M836RW"
@implementation XGPushSupport

+ (XGPushSupport*)shareinstance{
    static XGPushSupport* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[XGPushSupport alloc] init];
    });
    return sharedSupport;
}

+ (void)initXGPush{
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
    [XGPush startApp:(uint32_t)[XGPushAppID integerValue] appKey:XGPushAppKey];
    [XGPush setAccount:@"zhang12345"];
}

+ (void)XGPushRegisterDevice:(NSData *)Token{
    [XGPush registerDevice:Token];
    
}

+ (void)XgPushHandleReceiveNotification:(NSDictionary *)userInfo{
    [XGPush handleReceiveNotification:userInfo];
    NSLog(@"App运行时候出来的推送%@",userInfo);
}

+ (void)XgPushHandleLaunching:(NSDictionary *)launchOptions{
    [XGPush handleLaunching:launchOptions];
    NSLog(@"App后台时候出来的推送%@",launchOptions);
}

+ (void)XGPushUnRegisterDevice{

}
@end
