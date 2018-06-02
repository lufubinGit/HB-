//
/** @file GWP2PClient+APMode.h @brief 处理AP模式的分类 */
//  P2PSDK
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 gwell. All rights reserved.
//

#import "GWP2PClient.h"

/**
 @brief 处理AP模式的分类
 */
@interface GWP2PClient (APMode)

/**
 切换设备模式：从连网模式至AP模式
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceFromNetworkModeToAPModeWithDeviceID:(NSString *)deviceID
                                      devicePassword:(NSString *)devicePassword
                                     completionBlock:(CompletionBlock)completionBlock;

/**
 获取设备是否连接过wifi (若设备不支持，只会超时，此bug待日后更新)
 
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceWiFiHasBeSettedWithCompletionBlock:(CompletionBlock)completionBlock;

/**
 AP模式下设置设备wifi，设置后设备切回连网模式并连接设置的wifi (若设备不支持，只会超时，此bug待日后更新)
 
 @param wifiName                wifi名
 @param wifiPassword            wifi密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceWifiInAPModeWithWifiName:(NSString *)wifiName
                             wifiPassword:(NSString *)wifiPassword
                          completionBlock:(CompletionBlock)completionBlock;

/**
 AP模式下设置设备wifi密码
 
 @param wifiPassword            wifi密码：8-16位
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceWifiPassword:(NSString *)wifiPassword inAPModeWithCompletionBlock:(CompletionBlock)completionBlock;

@end