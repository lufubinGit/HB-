//
//  GWNet.h
//  GWNet
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 YHQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#ifndef GWNetSingleton
#define GWNetSingleton [GWNet shareInstance]
#endif

//success仅代表网络请求是否成功,不代表相应的操作结果,具体的要从errorCode判断
typedef void(^GWNetCompletionBlock)(BOOL success, NSString *errorCode, NSString *errorString, NSDictionary *json);


@interface GWNet : NSObject

@property (nonatomic, assign) BOOL connectWithHttps;/**< 以https的方式连接我们的服务器.默认为NO,用http的方式连接 */

@property(nonatomic,assign)NSInteger theTag;//这个相当于Tag
@property(nonatomic,copy)NSString* theTagString;//这个相当于String类型的Tag

#pragma mark - 获取单例
/**获取单例,注意,本程序并不是全单例,而是半单例,本程序并没有重写alloc方法,所以alloc出来的依然是独立的地址*/
+(instancetype)shareInstance;//获取单例

#pragma mark - 设置为输出日志
-(void)stOutputLog:(BOOL)outputLog;

#pragma mark - 必需设置的参数,如果不设置这些参数,会导致SDK传递的信息不正确
/**
 中文简体  中文繁体 英文 日语 韩语 德语 俄语
 zh-Hans zh-Hant en  ja  ko   de  ru ,其它语言请自行查询
 */
@property(nonatomic,copy)NSString* theAppLanguage;//设置SDK的语言,如果服务器支持的话,服务器会返回相应的语言,默认为iOS系统语言
@property(nonatomic,copy)NSString* theAppVersion;//APP的版本,类似于 2.3.4.7 这样的版本号,默认为 0.0.0.0
@property(nonatomic,copy)NSString* theAppName;//App名称,请尽可能提供相应的名称
@property(nonatomic,copy)NSString* theAppId;//APPID要与技威公司联系申请,否则SDK不能正常使用
@property(nonatomic,copy)NSString* theAppToken;//AppToken要与技威公司联系申请,否则SDK不能正常使用

/**
 服务器列表,自建服务器时才需要设置
 默认:
 @[@"api1.cloudlinks.cn",//中国大陆第一台
 @"api2.cloudlinks.cn",//中国大陆第二台
 @"api3.cloud-links.net",//外国第一台
 @"api4.cloud-links.net"];//外国第二台
 */
@property(nonatomic,copy)NSArray<NSString*>* serverList;

#pragma mark - 登录
//关于ID号,(10000|0x80000000 = -2147473648, -2147473648&0x7fffffff = 10000,01000是显示给用户的ID号,-2147473648是传给服务器的,它们之间要互相转换)
-(void)loginWithUserName:(NSString*)name//可以为手机,如 +86-15200002222,或者邮箱地址,或者ID号,例如-2147473648
            withPassword:(NSString*)pwd//密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
          withAppleToken:(NSString*)token//苹果设备Token,用来远程推送,可空,空时则无法推送
              completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 第三方登录
-(void)thirdLoginWithPlatformType:(NSString*)platformType//平台,1.微信 2.匿名登录 3 混合登录 ,此参数不可空
                      withUnionID:(NSString*)unionID//第三方平台的唯一标识符,如果是匿名登录,提供设备的唯一标识即可,不可空
                         withUser:(NSString*)user//用户名,可为手机,如+86-15200002222,或邮箱,或ID号,如010000,绑定账号时不可空
                     withPassword:(NSString*)pwd//密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密,绑定账号时不可空
                   withAppleToken:(NSString*)token//苹果设备Token,用来远程推送,可空,空时则无法推送
                       withOption:(NSString*)option//1仅登录 2绑定老用户并登录 3登录,若不存在则自动注册
                      withStoreID:(NSString*)storeID//商城ID,需要商城版功能时必须上传,可空,不懂的话留空即可
                       completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 退出登录
-(void)unLoginWithUserId:(NSString*)userId//这个应该从登录时返回的json里获取
           withSessionId:(NSString*)sessionId//这个应该从登录时返回的json里获取
              completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 邮箱注册
-(void)regEmailWithEmail:(NSString*)name //邮箱地址
                 withPwd:(NSString*)pwd //密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
               withRePwd:(NSString*)rePwd//再次密码,两次的密码应当一致
              completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 手机号注册
-(void)regPhoneWithNum:(NSString*)num//手机号
       withCountryCode:(NSString*)cCode//国码,中国为 86,不要写成+86
          withPassword:(NSString*)pwd//密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
             withRePwd:(NSString*)rePwd//再次密码
           withSmsCode:(NSString*)smsCode//短信验证码
            completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 手机找回的时候不要用这个方法
#pragma mark 发验证码
-(void)sendSmsWithCountryCode:(NSString*)code//国码
                 withPhoneNum:(NSString*)num//手机号
                   completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark 验证验证码
-(void)checkSmsWithCountryCode:(NSString*)code//国码
                  withPhoneNum:(NSString*)num//手机号
                withVerifyCode:(NSString*)vCode//短信验证码
    completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 通过邮箱找回
-(void)findFromEmailWithEmail:(NSString*)email//会向这个邮箱发一封找回的邮件,仅此而已
                   completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 通过手机找回来重置密码必需严格按顺序按照下面3步执行,过程中会用到2个不同的vKey,都是由服务器返回
#pragma mark 1.通过手机找回,服务器会自动发验证码,不需要调用上面发验证码的方法
-(void)findFromPhoneWithCountryCode:(NSString*)countryCode//国码,中国为 86,不要写成+86
                       withPhoneNum:(NSString*)num//手机号
                         completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark 2.验证手机找回,用这个方法来验证刚才通过找回的验证码是否正确
-(void)checkFindFromPhoneWithID:(NSString*)theId//这个应该从返回的json里获取
                       withVkey:(NSString*)vKey//这个应该从返回的json里获取
                withCountryCode:(NSString*)cCode//国码
                   withPhoneNum:(NSString*)num//手机号
                    withSmsCode:(NSString*)smsCode//短信验证码
                     completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark 3.通过手机重置密码
-(void)reSetPasswordWithId:(NSString*)theId//这个应该从返回的json里获取
                  withVkey:(NSString*)vkey//这个应该从返回的json里获取
                withNewPwd:(NSString*)pwd//密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
                 withRePwd:(NSString*)rePwd//再次密码
                completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 检查账号是否存在
-(void)checkAccountIsExistWithAccount:(NSString*)account//账号可以是邮箱或者手机
                           completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 获取账户信息
-(void)gtUserInfoWithUserID:(NSString*)userID//这个应该从登录时返回的json里获取
              withSessionID:(NSString*)sessionID//这个应该从登录时返回的json里获取
                 completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark 设置账户信息,用于绑定邮箱和手机号
-(void)stUserInfoWithUserID:(NSString*)userID//这个应该从登录时返回的json里获取
              withSessionID:(NSString*)sessionID//这个应该从登录时返回的json里获取
                  withEmail:(NSString*)email//绑定邮箱,此参数当bFlag=2或者0时有效,为空则解除绑定邮箱
            withCountryCode:(NSString*)cCode//国码,此参数当bFlag=1或者0时有效,为空则解除绑定手机
               withPhoneNum:(NSString*)phone//手机号,此参数当bFlag=1或者0时有效,为空则解除绑定手机,绑定的手机应该是未被注册过的手机
                withUserPwd:(NSString*)Pwd//绑定邮箱或者手机需要验证密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
               withBindFlag:(NSString*)bFlag//绑定标志(0:同时绑定手机和邮箱 1:仅绑定手机 2:仅绑定邮箱) 不可空
                    withSms:(NSString*)sms//当绑定手机的时候需要提供手机验证码,可以调发验证码的接口就行了
                 completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 修改用户账号密码
-(void)changeUserPasswordWithUserID:(NSString*)userID//用户iD
                      withSessionID:(NSString*)sessionID//会话ID
                         withOldPwd:(NSString*)oldPwd//账号的原密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
                            withPwd:(NSString*)pwd//账号的新密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
                          withRePwd:(NSString*)rePwd//两次确认的新密码,需要32位的md5加密处理,如果提供明文密码,内部会自动加密
                         completion:(GWNetCompletionBlock)completion;//请求完成回调

#pragma mark - 设备同步-增加设备
-(void)addDeviceWithUserID:(NSString*)userID//用户ID
                 sessionID:(NSString*)sessionID//会话ID
                modifyTime:(NSString*)modifyTime//客户端本地修改时的UTC时间戳
                  deviceID:(NSString*)deviceID//设备ID
                 devicePwd:(NSString*)devicePwd//设备加密后的密码
                remarkName:(NSString*)remarkName//设备昵称
                completion:(GWNetCompletionBlock)completion;

#pragma mark - 设备同步-删除设备
-(void)deleteDeviceWithUserID:(NSString*)userID//用户ID
                    sessionID:(NSString*)sessionID//会话ID
                   modifyTime:(NSString*)modifyTime//客户端本地修改时的UTC时间戳
                     deviceID:(NSString*)deviceID//设备ID
                   completion:(GWNetCompletionBlock)completion;

#pragma mark - 设备同步-修改设备
-(void)modifyDeviceWithUserID:(NSString*)userID//用户ID
                    sessionID:(NSString*)sessionID//会话ID
                   modifyTime:(NSString*)modifyTime//客户端本地修改时的UTC时间戳
                     deviceID:(NSString*)deviceID//设备ID
                     devicePwd:(NSString*)devicePwd//设备加密后的密码
                   remarkName:(NSString*)remarkName//设备昵称
                   completion:(GWNetCompletionBlock)completion;

#pragma mark - 设备同步-批量更新设备
/**
 注：
 DeviceInfo格式说明（两台设备信息之间用英式','分隔，各个信息字段用英式'|'分隔）：
 操作选项1|修改时间1|设备信息版本号1|分组ID1|设备ID1|权限1|秘钥1|备注名1,
 操作选项2|修改时间2|设备信息版本号2|分组ID2|设备ID2|权限2|秘钥2|备注名2。
 DeviceInfo最大包含200个成员，操作选项取值：1（添加）、2（删除）、3（修改）。
 */
-(void)upgradeDevicesWithUserID:(NSString*)userID//用户ID
                    sessionID:(NSString*)sessionID//会话ID
                     deviceInfo:(NSString*)deviceInfo//设备信息
                     completion:(GWNetCompletionBlock)completion;

#pragma mark - 设备同步-拉取设备信息
/**
 注：
 返回的结果DeviceInfo格式说明,和批量更新不完全一致（两台设备信息之间用英式','分隔，各个信息字段用英式'|'分隔）：
 修改时间1|设备信息版本号1|分组ID1|设备ID1|权限1|秘钥1|备注名1|状态1,
 修改时间2|设备信息版本号2|分组ID2|设备ID2|权限2|秘钥2|备注名2|状态2。
 这里的“状态”取值：0（已标记为删除【实际上不会真正删除数据】，APP不要显示）、1（正常）。
 */
-(void)loadDevicesWithUserID:(NSString*)userID//用户ID
                   sessionID:(NSString*)sessionID//会话ID
                 preDeviceID:(NSString*)preDeviceID//上次拉取时获取到的最后一个设备ID（第一次拉取填0）
                requestCount:(NSUInteger)requestCount//请求拉取的设备数量（每次最大200个）
                 upgradeFlag:(NSString*)upgradeFlag//本地缓存的列表最后更新标志
                  completion:(GWNetCompletionBlock)completion;

@end
