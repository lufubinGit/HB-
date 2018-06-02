//
//  GziSupport.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GizWifiSDK/GizWifiSDK.h"
#import "EnumHeader.h"


//机智云的 智能网关设备之一
#define XPGAppProductKey @"b5317108281841cda168b49bf014f21c"
#define XPGAppProductSceret @"26590e3728ef4d04bd11b8406a6efd49"

#define XPGAppDetectorProductKey @"7138fa0fd7ff45b4b3d9c49d2da35caa"
#define XPGAppDetectorProductSceret @"440359e62f954cf988cd7d9eb051393a"


#define XPGProDuctInfo 

 

#define JDGizDeviceSoftAPWiFi @"XPG-GAgent"   // 设备热点Wifi 的前缀
#define GizcJSONSendSN   55
@class DeviceInfoModel;
@interface GizSupport : NSObject <GizWifiSDKDelegate,GizWifiDeviceDelegate>
@property (nonatomic,strong) NSString *GizUserName;
@property (nonatomic,strong) NSString *GizUserPassword;
@property (nonatomic,strong) NSString *GizUid;              //登陆成功之后获取到的uid
@property (nonatomic,strong) NSString *GizToken;            //登陆成功之后获取的token
@property (nonatomic,strong) NSMutableArray *deviceList;    //保存当前绑定的设备的数组

@property (nonatomic,strong) GizWifiDevice *gizCurrentDevice;  //保存当前控制的设备


@property (nonatomic,assign) BOOL isLogined;

@property (nonatomic,strong,readonly) NSDictionary *productInfo;

+ (GizSupport*)sharedGziSupprot;

//登录有看头
- (void)logYoosee:(NSString *)token;

//退出有看头
- (void)logoutYooseeConnect;

//初始化
- (void)initSDK;

//绑定推送
- (void)gizBindPush;

//- (void)channelIDBind:(NSString *)token channelID:(NSString *)channelID alias:(NSString *)alias pushType:(GizPushType)pushType;

//发送验证码
- (void)gizGetTestCodeWithPhone:(NSString *)phoneNum
                        Succeed:(void (^ )(void))Sucsse
                         failed:(void (^ )(NSString*))failed;

//手机号加验证码注册
- (void)gizregisterWithPhone:(NSString *)phone
                    testCode:(NSString *)testCode
                    password:(NSString *)psw
                     Succeed:(void (^ )(void))Sucsse
                      failed:(void (^ )(NSString*))failed;

//重置密码
- (void)gizReplacePswWithTestCode:(NSString *)testCode
                         userName:(NSString *)userName
                      newPassword:(NSString *)newPsw
                             type:(GizUserAccountType)userType
                          Succeed:(void (^ )(void))Sucsse
                           failed:(void (^ )(NSString*))failed;

//密码修改
- (void)gizChangePasswordWithOldPassWord:(NSString *)oldPsw
                             newPassword:(NSString *)newPsw
                                 Succeed:(void (^ )(void))Sucsse
                                  failed:(void (^ )(NSString *))failed;


//邮箱注册
- (void)gizRegisteWithUserName:(NSString *)userName
                      password:(NSString *)password
                       Succeed:(void (^ )(void))Sucsse
                        failed:(void (^ )(NSString*))failed;

//登录
- (void)gizLoginWithUserName:(NSString *)userName
                    password:(NSString *)password
                     Succeed:(void (^ )(void))Sucsse
                      failed:(void (^ )(NSString *))failed;

//设备配置  设置设备的Wi-Fi airLink
- (void)gizSetDeviceWifiAirLinkAtViewControll:(UIViewController *)Vc
                                     WiFiName:(NSString *)wifiName
                                 WiFiPassword:(NSString *)PSW
                               wifiGAgentType:(GizWifiGAgentType)GAgentType
                                      Succeed:(void (^ )(void))Sucsse
                                       failed:(void (^ )(NSString *))failed;

//设备配置 设备作为热点呗被手机连接 softAP
- (void)gizSetDeviceWifiSoftAPAtViewControll:(UIViewController *)Vc
                                    WiFiName:(NSString *)wifiName
                                WiFiPassword:(NSString *)PSW
                              wifiGAgentType:(GizWifiGAgentType)GAgentType
                                     Succeed:(void (^ )(void))Sucsse
                                      failed:(void (^ )(NSString *))failed;

//发现设备 这里发现的设备 分三种情况：
//当手机能访问外网时，该接口会向云端发起获取绑定设备列表请求；
//当手机不能访问外网时，局域网设备是实时发现的，但会保留之前已经获取过的绑定设备；
//手机处于无网模式时，局域网未绑定设备会消失，但会保留之前已经获取过的绑定设备；
- (void)gizFindDeviceSucceed:(void (^ )(void))Sucsse
                      failed:(void (^ )(NSString *))failed;

//设备绑定 （通过硬件信息绑定）
- (void)gizDeviceLineWithDevice:(DeviceInfoModel *)device
                        Succeed:(void (^ )(void))Sucsse
                         failed:(void (^ )(NSString *))failed;

//设备绑定  (二维码)
- (void)gizBindDeviceWithQRcodeString:(NSString *)QRcodeString
                              Succeed:(void (^ )(void))Sucsse
                               failed:(void (^ )(NSString *))failed;

//设备解绑 
- (void)gizUnbindDeviceWithDeviceDid:(DeviceInfoModel *)device
                             Succeed:(void (^ )(void))Sucsse;

//登录设备 订阅

- (void)gizDeviceLoginWithDevice:(DeviceInfoModel *)device
                         Succeed:(void (^ )(void))Sucsse;

//登陆之后便可以获取硬件信息了
- (void)gizGetDeviceHardwareInfo:(DeviceInfoModel *)device
                         Succeed:(void (^ )(void))Sucsse
                          failed:(void (^ )(NSString *))failed;

//发送指令
- (void)gizSendOrderWithSN:(int)sn
                    device:(DeviceInfoModel *)device
                 withOrder:(NSDictionary *)order
                  callBack:(void (^ )(NSDictionary*))call;

//查询设备状态
- (void)gizGetDeviceStatesWithSN:(int)sn
                          device:(DeviceInfoModel *)device
                        callBack:(void (^ )(NSDictionary*))call;

//更改设备的名字
- (void)gizModifyDeviceNameWithDevice:(DeviceInfoModel *)device
                                 name:(NSString *)name
                              Succeed:(void (^ )(void))Sucsse
                               failed:(void (^ )(NSString *))failed;
@end
