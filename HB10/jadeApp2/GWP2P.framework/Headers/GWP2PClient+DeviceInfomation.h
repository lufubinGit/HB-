//
/** @file GWP2PClient+DeviceInfomation.h @brief 该文件为P2PClient获取和设置设备状态信息的分类 */
//  P2PSDK
//
//  Created by apple on 17/2/24.
//  Copyright © 2017年 gwell. All rights reserved.
//




#import "GWP2PClient.h"



/**
 @brief 该分类可获取和设置设备各种状态信息
 */
@interface GWP2PClient (DeviceInfomation)

#pragma mark - 获取设备状态
/**
 获取多项设备状态：以下key返回结果里没有时表示设备不支持该功能
 
 completionBlock返回：
 
 @"defence state" （布防状态）: 类型：BOOL （YES 布防 , NO 撤防）
 
 @"buzzer state" （蜂鸣器蜂鸣时长）: 0 off , 1 2 3 min 蜂鸣时长 类型：NSNumber
 
 @"motion detect state"（移动侦测状态）:  类型：BOOL (NO off; YES on)
 
 @"record type" （录像类型） : manual; alarm; schedule  返回字典， record type 键对应 GWP2PRecordType 枚举
 
 @"manual record state" （手动录像开关） : 类型：BOOL (NO off; YES on)
 
 @"planed record time" （计划录像时间）:返回字典，对应的值为 NSNumber类型，保存开始时间的时分，结束时间的时分四个键值对（24小时制）
 
 @"video format" （视频格式） 返回字符串 : NTSC , PAL 返回字典：
 
 @"alarm record time" （报警录像时间）
 
 @"net type" （网络类型） : 0 有线; 1 wifi; 2 两者都有
 
 @"volume" （音量）: 0-9整数
 
 @"auto update" （自动升级）: NO off; YES on
 
 @"body infrared state" （人体红外状态） : NO off; YES on
 
 @"wired alarm input" （有线报警输入状态） : NO off; YES on
 
 @"wired alarm output" （有线报警输出状态） : NO off; YES on
 
 @"time zone" （时区） : 0-24
 
 @"password" （用户密码）
 
 @"image reverse state" （图像倒转状态）返回BOOL值 : NO 非倒转; YES 是倒转
 
 @"prerecord state" （预录像状态） : NO off YES on
 
 @"lamp state" （灯光控制状态） : NO off YES on
 
 @"visitor password" （访客密码） : 由非0开头的数字组成
 
 @"focus zoom" （变焦 变倍） : 0 都没有; 1 只有变倍; 2 只有变焦; 3 变倍变焦都有
 
 @"AP Mode" （AP模式） : 0 不支持; 1 支持(mode!=ap); 2 支持(mode=ap)
 
 @"type" （设备主类型）： GWDeviceType 类型,（如IPC、NPC...） （设备返回的主类型不准）
 
 @"subtype" （设备子类型）： GWDeviceSubtype 类型,（如30只支持868；31支持868+情景模式；32支持868+情景模式+分享）
 
 @"preset position suppurted" （是否支持预置位）: NO 不支持; YES 支持
 
 @param deviceID                设备ID
 @param password                设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getMultipleDeviceStatusWithDeviceID:(NSString *)deviceID
                                   password:(NSString *)password
                            completionBlock:(CompletionBlock)completionBlock;


/**
 获取设备信息
 
 completionBlock 返回字典对应的key:
 
 @"firmware version" 固件版本
 
 @"uBoot uersion" uBoot版本
 
 @"kernel version" 内核版本
 
 @"system version" 系统版本

 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceInfomationWithDeviceID:(NSString *)deviceID
                         devicePassword:(NSString *)devicePassword
                        completionBlock:(CompletionBlock)completionBlock;

#pragma mark - 下载文件
/**
 从设备下载文件,下载结果在 GWP2PClientProtocol 的方法 client:didDownloadFile:withFilePath:deviceID: 中

 @param deviceID        设备ID
 @param devicePassword  设备密码
 @param remoteFilePath  远程文件路径,一般由设备返回
 @param localFilePath   下载后文件在本地的保存路径,文件在沙盒中的保存路径(包括文件名及文件扩展名),下载成功后文件直接保存在此路径

 @return 下载是否开始
 */
- (BOOL)downloadFileWithDeviceID:(NSString *)deviceID
                  devicePassword:(NSString *)devicePassword
                  remoteFilePath:(NSString *)remoteFilePath
                   localFilePath:(NSString *)localFilePath;

/**
 从设备下载报警时的截图, 下载结果在 GWP2PClientProtocol 的 client:didDownloadFile:withFilePath:deviceID:result: 方法中回调

 @param deviceID        设备ID
 @param devicePassword  设备密码
 @param pictureNumber   报警时截图的数量,设备推送报警时,会推送此数据
 @param toDownloadIndex 要下载的图片索引, <= (pictureNumber - 1)
 @param remoteFilePath  图片的路径,设备推送报警时,会推送此数据
 @param localFilePath   下载后图片在本地的保存路径,图片在沙盒中的保存路径(包括图片名及图片扩展名),下载成功后文件直接保存在此路径

 @return 下载是否开始
 */
- (BOOL)downloadAlarmPictureWithDeviceID:(NSString *)deviceID
                          devicePassword:(NSString *)devicePassword
                           pictureNumber:(NSUInteger)pictureNumber
                         toDownloadIndex:(NSUInteger)toDownloadIndex
                          remoteFilePath:(NSString *)remoteFilePath
                           localFilePath:(NSString *)localFilePath;

#pragma mark - 网络
/**
 获取设备搜索到的Wifi列表
 
 获取网络类型请调 getMultipledeviceStatusWithDeviceID:password:completionBlock:
 
 completionBlock返回字典:
 
 @"wifi count" : wifi数目
 
 @"current wifi index" : 正在使用的wifi索引值 索引值从0开始
 
 @"wifi list" : wifi列表数组,数组内一个字典对应一个wifi的信息(wifi名,是否加密,wifi强度) @[@{@"wifi name" : @"wifi名", @"has encrypted" : @(YES), @"wifi strength" : @"wifi强度"}]
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceWifiListWithDeviceID:(NSString *)deviceID
                       devicePassword:(NSString *)devicePassword
                      completionBlock:(CompletionBlock)completionBlock;

/**
 连网模式下设置设备当前Wifi，设置后设备会连接到设置的wifi
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param encrypted               wifi是否加密(可由获取到的wifi列表得到)
 @param wifiName                wifi名
 @param wifiPassword            wifi密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceWifiInNetworkModeWithDeviceID:(NSString *)deviceID
                                devicePassword:(NSString *)devicePassword
                            wifiHasBeEncrypted:(BOOL)encrypted
                                      wifiName:(NSString *)wifiName
                                  wifiPassword:(NSString *)wifiPassword
                               completionBlock:(CompletionBlock)completionBlock;


#pragma mark - 时间时区
/**
 获取设备时间 : 返回 年 月 日 时 分 的数值, 不是NSDate,避免时区出错
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceTimeWithDeviceID:(NSString *)deviceID
                   devicePassword:(NSString *)devicePassword
                  completionBlock:(CompletionBlock)completionBlock;

/**
 设置设备时间
 
 @param date                    要设置的时间
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceTime:(NSDate *)date
         withDeviceID:(NSString *)deviceID
       devicePassword:(NSString *)devicePassword
      completionBlock:(CompletionBlock)completionBlock;

/**
 设置设备时区
 
 获取时区请调 getMultipledeviceStatusWithDeviceID:password:completionBlock:
 
 @param timeZone                要设置的时区,可设置如下数字:-11, -10, -9, -8, -7, -6, -5, -4, -3.5, -3, -2, -1, 0, 1, 2, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 8, 9, 9.5, 10, 11, 12
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceTimeZone:(float)timeZone
             withDeviceID:(NSString *)deviceID
           devicePassword:(NSString *)devicePassword
          completionBlock:(CompletionBlock)completionBlock;


#pragma mark - 安全
/**
 设置初始密码
 
 必须保证手机与设备在同一局域网中,否则回调只会收到参数错误. 这一接口在发指令时会把deviceID转成4位设备IP的最后一位,若不在同一局域网,获取不到设备IP,转不成功,会判定设备ID这一参数不正确
 
 @param initialPassword         初始密码,必须为包含字母、数字、其它字符中两种的6~30位的字符串
 @param deviceID                设备ID,直接传设备ID,内部处理成IP地址
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceInitialPassword:(NSString *)initialPassword
                    withDeviceID:(NSString *)deviceID
                 completionBlock:(CompletionBlock)completionBlock;

/**
 设置管理员密码
 
 @param oldPassword             老的管理员密码,可能为简单的初始密码,如123
 @param newPassword             新的管理员密码,必须为包含字母、数字、其它字符中两种的6~30位的字符串
 @param deviceID                设备ID
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceAdministratorPasswordWithOldPassword:(NSString *)oldPassword
                                          newPassword:(NSString *)newPassword
                                             deviceID:(NSString *)deviceID
                                      completionBlock:(CompletionBlock)completionBlock;

/**
 设置访客密码
 
 @param newVisitorPassword      新的访客密码(必须为非零开头的小于等于9位的数字)
 @param administratorPassword   管理员密码
 @param deviceID                设备ID
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceVisitorPassword:(NSString *)newVisitorPassword
       withAdministratorPassword:(NSString *)administratorPassword
                        deviceID:(NSString *)deviceID
                 completionBlock:(CompletionBlock)completionBlock;

#pragma mark - 更新
/**
 设置自动更新状态
 
 如果获取不到设备的自动更新状态,表明设备不支持,调此方法是收不到回调数据,只会超时
 
 获取自动更新状态请调 getMultipledeviceStatusWithDeviceID:password:completionBlock:
 
 @param isAutoUpdate            是否自动更新
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceAutoUpdateState:(BOOL)isAutoUpdate
                    withDeviceID:(NSString *)deviceID
                  devicePassword:(NSString *)devicePassword
                 completionBlock:(CompletionBlock)completionBlock;

/**
 检查设备是否可更新
 
 completionBlock返回字典对应的键值：
 
 @"current version" 当前固件版本
 
 @"update version" 待更新的版本
 
 @"can update"  （是否可更新）：对应值为 NSNumber 包装的 BOOL 类型
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)checkDeviceUpdateWithDeviceID:(NSString *)deviceID
                       devicePassword:(NSString *)devicePassword
                      completionBlock:(CompletionBlock)completionBlock;

/**
 执行设备更新
 
 completionBlock返回字典对应的键值：
 
 @"has begin update" （是否开始更新）：对应值为 NSNumber 包装的 BOOL 类型
 
 @"update progress" （更新进度）：对应值为 NSNumber 包装的 int 类型
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)performUpdateWithDeviceID:(NSString *)deviceID
                   devicePassword:(NSString *)devicePassword
                  completionBlock:(CompletionBlock)completionBlock;

/**
 取消设备更新
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)cancelUpdateWithDeviceID:(NSString *)deviceID
                  devicePassword:(NSString *)devicePassword
                 completionBlock:(CompletionBlock)completionBlock;

#pragma mark - 获取用户及设备列表在线状态等信息
/**
 获取好友用户及设备列表在线状态等信息,此指令不能同时发两条,第二条要等第一条回调后再发,网络超时为25s
 
 completionBlock返回字典数据结构:
 
 @{ @"result" : @(NO),
    @"description" : @"success",
    @"操作描述" : @"获取好友用户及设备列表在线状态等信息",
    @"status" : @[  @{//一个字典对应一个设备或一个好友用户信息
                    @"deviceID" : @"设备ID或好友用户ID",
                    @"defence flag" : @(-1),//布防状态获取的时间标识,此值越大,表示获取的时间越晚,用于判断是否要刷新布防状态. -1表示不支持或设备不在线
                    @"defence state" : @(-1),//-1表示不支持或设备不在线
                    @"online state" : @(YES),//接口一定支持
                    @"subtype" : @(-1)//-1表示不支持或设备不在线
                    }
                ]
 }
 
 @param deviceIDsArray          设备ID数组,如果是用户(GWNet登陆的用户)ID,请在数字前加0,用于区分是设备ID还是用户ID
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDevicesOrUersStatusWithDeviceIDs:(NSArray<NSString *> *)deviceIDsArray
                      completionBlock:(CompletionBlock)completionBlock;

@end
