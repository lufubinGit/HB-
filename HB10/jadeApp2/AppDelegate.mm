//
//  AppDelegate.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "FunSupport.h"
#import "GizSupport.h"
#import "XGPushSupport.h"
#import "BpushSupport.h"
#import "JDNetWorkTool.h"
#import "JDAppGlobelTool.h"
#import "JPushSupport.h"
#import "LeftSlideViewController.h"
#import "RootViewController.h"
#import "EquipmentPage.h"
#import "UMFeedback.h"
#import <CoreLocation/CoreLocation.h>
#import "EBForeNotification.h"
#import "GWNet.h"
#import <GWP2P/GWP2P.h>

//youmeng 
#define UMAppkey @"57fe14d2e0f55afab1003df8"

//qq
#define QQAppKey @"krSY6bo3XT9WNqmc"
#define QQAppID @"1105742153"

//xinlang 
#define SinaAppKey @"2803962212"
#define SinaAppSecret @"1b4af5858497d41de234b84de8c328a9"

//weixin 
#define WechatAppKey @"wx666660ea30ce3734"
#define WechatAppSecret @"83fae4060d9576976a8588a3e9190663"

//feisibuke 
#define FaceBookAppKey @"1721026174874814"
#define FaceBookAppSecret @"1522a96f53a6b4cf63d7dbf1a8ca3c46"

//whatsapp
#define WhatsAppKey @"cc"
#define WhatsAppSecret @"cc"

//推特
#define TwitterAppKey @"cc"
#define TwitterAppSecret @"cc"



@interface AppDelegate ()<CLLocationManagerDelegate>
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic,strong) NSTimer *myTimer;

@end

@implementation AppDelegate
{
    CLLocationManager *_locationManager;
    NSDictionary *_launchOptions;
    int _i;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setLocalLanguage];        //设置本地化语言包
    NSLog(@"%@",[JDAppGlobelTool shareinstance].currentWifiName);
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    EquipmentPage *equipage = [[EquipmentPage alloc]init];
    RootViewController *rootVc = [[RootViewController alloc]initwithEquipage:equipage];
    self.window.rootViewController = [[LeftSlideViewController alloc]initWithLeftView:rootVc andMainView:[[UINavigationController alloc]initWithRootViewController:equipage]];
    self.window.backgroundColor = APPMAINCOLOR;
    [self.window makeKeyAndVisible];
    [self setSVPHUD];
    [self initgizwit];              //初始化机智云
    [self setJPush:launchOptions];  //内部包含了对消息的处理
    [self setUMeng];                //初始化友盟
    [self initVideo];               //初始化播放
    [self getCurrentAdrss];         //获取当前的地址
    [[JDNetWorkTool shareInstance] addobserverforNet]; //添加网路监听
    //添加一个通知 用于冲更新注册推送通知的功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotic) name:ResetNotifition object:nil];
    _launchOptions = launchOptions;
    [[JDAppGlobelTool shareinstance] addMaskAtView:self.window];  //视图放大效果
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    return YES;
}

- (void)resetNotic{
    [self setJPush:_launchOptions];  //内部包含了对消息的处理
}

//初始化视频播放
- (void)initVideo{
    //以下GWNet初始化参数仅在本项目测试使用,和bundleID是绑定的,放到其他项目调用GWNet接口会返回errorCode20000
    GWNetSingleton.theAppName = @"JADEGateway";
    GWNetSingleton.theAppVersion = @"04.27.00.00";
    GWNetSingleton.theAppId = @"59238432465598b40d1f74fa04a79587";
    GWNetSingleton.theAppToken = @"7408738e3dc9acecb0c7290f5e0743df9a0101c331b531ab4be3c215bf041b50";
    GWNetSingleton.connectWithHttps = YES;
}


- (void)setLocalLanguage{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
        }else if ([language hasPrefix:@"ru"]){
             [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:appLanguage];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//获取当前的地址
- (void)getCurrentAdrss{

    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
//地址获取回调
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            [JDAppGlobelTool shareinstance].currentCity = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            if([city containsString:@"市"]){
            
                [city substringToIndex:city.length-1];
            }
            [JDAppGlobelTool shareinstance].currentCity = city;
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}


//整体风格 导航栏等

//设置APP的四个界面
- (void)setAppMainFrame{

}

//设置相关的三方库
- (void)setSVPHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}
//设置友盟
- (void)setUMeng{
    // 集成反馈
    [UMFeedback setAppkey:UMAppkey];
    
    // 集成分享
    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
//   
//    //设置友盟appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppkey];
//    
//    // 获取友盟social版本号
//    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
//    
//    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatAppKey appSecret:WechatAppKey redirectURL:@"http://mobile.umeng.com/social"];
//    
//   
//    //设置分享到QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    
//    
//    //设置Facebook
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:FaceBookAppKey  appSecret:FaceBookAppSecret redirectURL:nil];
//
////    //设置whatsAPP
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Whatsapp appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
//    //设置Twitter的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
//    
//
    // 如果不想显示平台下的某些类型，可用以下接口设置
//      [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_Whatsapp),@(UMSocialPlatformType_Twitter)]];
}




//初始化机智云
- (void)initgizwit{
    [[GizSupport sharedGziSupprot] initSDK];
}
//设置激光推送
- (void)setJPush:(NSDictionary *)launchOptions
{
    [JPushSupport initJPushWith:launchOptions];
}

//分享的回调
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
////    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}




-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    NSLog(@"远程推送能力注册成功，deviceToken:%@",deviceToken);
    //注册设备
   [JPushSupport JpushRegisterDevice: deviceToken];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"远程推送注册失败 原因是：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"推送内容是:%@",userInfo);
    [JPushSupport JpushApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"推送内容是:%@",userInfo);
    [JPushSupport JPushHandleReceiveNotification:userInfo application:application fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {


    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[JDAppGlobelTool shareinstance] addMaskAtView:self.window];

    self.backgroundUpdateTask =[application beginBackgroundTaskWithExpirationHandler:^(void) {
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在次Block块中执行一些清理工作。
        // 如果清理工作失败了，那么将导致程序挂掉
        // 清理工作需要在主线程中用同步的方式来进行

        [self endBackgroundTask];
    }];
    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                   
                                                   target:self
                   
                                                 selector:@selector(timerMethod:)  userInfo:nil
                   
                                                  repeats:YES];
    
    
    //清理角标
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = 0;
        // 通知内容
        notification.alertBody = nil;
        notification.applicationIconBadgeNumber = -99;
        // 通知被触发时播放的声音
        notification.soundName = nil;
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [JPUSHService setBadge:0];
    [[GizSupport sharedGziSupprot] logoutYooseeConnect];
}

- (void) timerMethod:(NSTimer *)paramSender{
    
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        NSLog(@"Background Time Remaining = Undetermined");
    } else {
        
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
        if([[JDAppGlobelTool shareinstance].currentWifiName containsString:@"XPG"]){
            
            [[JDAppGlobelTool shareinstance] pushWithLinkCenterDevice];
            [paramSender invalidate];
            paramSender = nil;
            self.backgroundUpdateTask = UIBackgroundTaskInvalid;
        }
    }
}

- (void) endBackgroundTask{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];// 停止定时器
            [[UIApplication sharedApplication]endBackgroundTask:self.backgroundUpdateTask];
            
            // 销毁后台任务标识符
            strongSelf.backgroundUpdateTask = UIBackgroundTaskInvalid;
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    [self.myTimer invalidate];
    self.myTimer = nil;
    [[JDAppGlobelTool shareinstance] addMaskAtView:self.window];  //视图放大效果
    [JPUSHService setBadge:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.myTimer invalidate];
    self.myTimer = nil;
    [[GizSupport sharedGziSupprot] logYoosee:nil];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [[GizSupport sharedGziSupprot] logoutYooseeConnect];

}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jade-iot.www.jadeApp2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"jadeApp2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"jadeApp2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
