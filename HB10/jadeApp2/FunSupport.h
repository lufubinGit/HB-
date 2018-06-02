//
//  FunSupport.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FunDelegate.h"
//#import <vector>
//
//const static char* constStrServerAddrs =
//"223.4.33.127;54.84.132.236;112.124.0.188";
//const static short constIntServerPort = 15010;
//
//const static char* constStrApiAppUuid = "1febc30d77e246e38723237f3244ba9b";
//const static char* constStrApiAppKey = "fc847831738d41c6b0f6b837991d3329";
//const static char* constStrApiAppSecret = "52991c81a4f34838ab88fa5c659b9d85";
//const static short constIntApiMoveCard = 8;
//
//enum EDevListMode
//{
//    E_DevList_Local,  //本地设备列表
//    E_DevList_Server, //设备列表通过服务器账户获取
//    E_DevList_AP      // AP模式 ，只有一台设备ap直连
//};
//
//@interface DevInfo : NSObject
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* sn;
//@property (nonatomic, copy) NSString* ip;
//@property (nonatomic) NSInteger port;
//@property (nonatomic, copy) NSString* username;
//@property (nonatomic, copy) NSString* password;
//@property (nonatomic) NSInteger type;
//@end
//
@interface FunSupport : NSObject
//
//@property (nonatomic, copy) NSString* currentUserName;
//@property (nonatomic, copy) NSString* currentPassword;
//@property (atomic) BOOL isLogined;
//@property (nonatomic) int handle;
//@property (atomic) NSMutableArray* arrayDevList;
//@property (atomic) NSMutableArray* arrayDevSearchedList;
//@property (nonatomic) id searchDevListener;
//@property (nonatomic) SEL searchDevAction;
//@property (nonatomic,copy) NSString *resultMsg;
//
////
//+ (FunSupport*)sharedFunSupprot;
////初始化
//- (int)alarmNetinit:(NSString*)deviceToken
//           UserName:(NSString*)userName
//           Password:(NSString*)password;
////初始化sdk
//- (int)initSDK;
////设置设备列表的源（登录模式）
//- (void)setDevListMode:(int)mode;
////用户登录，记录下当前的用户名密码与登录状态
//- (void)userlogined:(NSString*)name andPassword:(NSString*)password;
////用户登出，
//- (void)userlogout;
////设备列表更新
//- (void)deviceUpdated:(SDBDeviceInfo*)dev andCount:(int)count;
////添加设备
//- (void)deviceAdded:(SDBDeviceInfo*)dev;
////移除设备
//- (void)deviceRemoved:(NSString*)sn;
////搜索附近设备
//- (void)searchDeviceWithTimeout:(int)timeout
//                      andTarget:(id)tar
//                      andAction:(SEL)sel;
////取消搜索附近设备（取消通知）
//- (void)cancelSearchDevice;
//
//
////JD‘sfun
////发送手机验证码
//- (void)XmeyeGetTestCodeWithPhoneNum:(NSString *)phoneNum userName:(NSString *)userName result:(void (^ )(NSString* result))result;
//
//// 手机验证码注册
//- (void)XmeyeRegisteWithUserName:(NSString *)userName password:(NSString *)password phoneNum:(NSString *)phoneNum tectCode:(NSString *)testCode result:(void (^ )(NSString*result))result;
////发送邮箱验证码
//- (void)XmeyeGetTestCodeWithEmail:(NSString *)email userName:(NSString *)userName result:(void (^ )(NSString* result))result;
//
////邮箱验证码注册
//- (void)XmeyeRegisterWithEmailTestCode:(NSString *)emailCode userName:(NSString *)userName password:(NSString *)psw Email:(NSString *)email result:(void (^ )(NSString*result))result;
//
//
//// 普通注册
//- (void)XmeyeNormalRegisteWithuserName:(NSString *)userName password:(NSString *)password result:(void (^ )(NSString*result))result;
//
////登录
//- (void)XmeyeLoginWithUserName:(NSString *)userName passWord:(NSString*)password result:(void (^ )(NSString* result))result;
////修改用户密码
//- (void)XmeyeModifyWithUserName:(NSString *)userName oldPsw:(NSString *)oldPsw newPsW:(NSString *)newPsw result:(void (^ )(NSString* result))result;
//
//
////搜索设备  默认的搜索时间60秒
//- (void)XmeyeSearchDeviceWithResult:(void (^ )(NSString* result))result;
//
////配置设备
//- (void)XmeyeConfigDeviceWithDeviceID:(NSString *)deviceId Result:(void (^)(NSString *))result;
//
////雄迈提供了三种配置方式  暂时先接入快速配置的方式
////- (void)XmeyeFastConfigWith
//
//
//
//
@end
