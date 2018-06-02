//
//  JDAppGlobelTool.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SVProgressHUD.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Availability.h>
#import "AppDelegate.h"
#import "SecondaryController.h"
#import "NSString+NSLocalPrintf.h"
#import "Strings.h"
#import "EnumHeader.h"
#import "UIView+Frame.h"
#import "UIColor+HexColorChange.h"
#import "BaseViewController.h"
#import "JADE-Swift.h"
#import "GizSupport.h"

@class DeviceInfoModel;

typedef void(^DelayCall)(void);

typedef void(^HollowCall)(void);

@interface JDAppGlobelTool : NSObject

//APP之间的复用属性
@property (nonatomic,strong) NSString *officialEmail;
@property (nonatomic,strong) NSString *officialProductUrl;
@property (nonatomic,strong) NSString *companyUrl;
@property (nonatomic,strong) NSString *officialTel;
@property (nonatomic,strong) UIColor *aPPMAINCOLOR;
@property (nonatomic,strong) UIColor *aPPAMAINNAVCOLOR;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *GizAPPId;
@property (nonatomic,strong) NSString *GizAPPKey;
@property (nonatomic,strong) NSString *JpushId;
@property (nonatomic,strong) NSString *JpushKey;

+ (JDAppGlobelTool*)shareinstance;

//替换不同的APP的图片
- (UIImage *)repalceImage:(NSString *)imageName;

/** 延时执行的一个方法 */
- (void) delayTimer:(NSTimeInterval )timerInterval doBlock:(void (^ )(void))completion;

//添加会放大的图片
- (void)addMaskAtView:(UIView*)View;

// 这个数组是一个全局的字典，将保存所有的已经被绑定过的摄像头。 数据在每次获得摄像头设备的时候获取（ 可能还需要在添加设备的时候也获取 ）
// 字典将网关的did作为key ，将摄像头的did的集合（这里可能有多个摄像头）作为Value,这里的vlaue实际上就是个数组
@property (nonatomic,strong) NSDictionary *camreDic;

@property (nonatomic,strong) NSString *currentCity;

@property (nonatomic,copy) NSString *currentWifiName;   //当前连接的Wi-Fi名字

@property (nonatomic,assign) BOOL enableNotic;   //推送注册的开关

@property (nonatomic,assign) BOOL isFirstUser;

@property (nonatomic,copy) HollowCall hollow;

@property (nonatomic,copy) DelayCall delay;
@property (nonatomic,copy) DelayCall delay1;
@property (nonatomic,copy) DelayCall delay2;



//获取当前Wi-Fi
- (NSDictionary*)getCurrentWifiNameAndPassWord;

//撤销指定页面的键盘 参数为View
- (void)registerKeyBForView:(UIView *)view;

////显示根目录
//- (CGFloat)showRootMenu;
//
////隐藏跟目录
//- (CGFloat)hidenRootMenu;

//时间戳转话为当前时间 天 时 分 秒
- (NSString *)getTimeWithUnixtime:(NSTimeInterval )timeInterval;

//时间转户为时间戳
-(NSTimeInterval )TimeStamp:(NSString *)strTime;

//解析扫描二维码得到的数据
- (NSDictionary *)getScanResult:(NSString *)result;

//AsciI 转 NSString
- (NSString *)stringWithAsciiStr:(NSString *)str;

//将 data 获取出来，转化成 二进制 样式的字符串
- (NSString *)getBinaryByhex:(NSData *)hex;

////将data转话成相应的 字面字符
//- (NSString *)getStringByData:(NSData *)data;

//将 字符 样式的字符 转化成data
- (NSData *)getHexBybinary:(NSString *)binary;

//解析状态码 掩码 事件属性三者 获取事件的内容
- (NSArray *)getContentWithEventData:(NSData *)eventData type:(ZoneType)type;

//ABCdef -> 10 11 12 13 14 15 
- (NSString*)charToInt:(NSString *)S;

//将字面址为<546465474 6d545de5 > 字符转成data
- (NSData *)hex2data:(NSString *)hex;

//更改连接设备的热点成功之后的本地通知
- (void)pushWithLinkCenterDevice;

//计算文本高度
- (CGFloat)getStrHeiWithString:(NSString *)string width:(CGFloat)width font:(CGFloat)font;

//创建镂空涂层
- (void)creatHollowInMap:(UIView *)map withHollowRect:(CGRect)hollowRect color:(UIColor*)color handleBlock:(void (^ )(void))hand;


@end
