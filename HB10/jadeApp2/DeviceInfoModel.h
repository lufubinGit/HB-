//
//  DeviceInfoModel.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GizSupport.h"
#import <UIKit/UIKit.h>
#import "DataPointModel.h"
@class JDDeviceHistoryRecord;

typedef void(^armBlock)(void);
//中控设备的子设备
@interface JDGizSubDevice : NSObject  <NSCoding>

@property(nonatomic,copy) armBlock armBlock;

//IEEE地址	短地址	     endpoint	       Profile ID	        Device ID（2字节）	          Zone type（2字节）
//8字节	    2字节      1字节（范围1-240）	2字节（目前只支持04 01）   （目前只支持02 04）       （ 0x000D是红外，0x0015是门磁）
@property (nonatomic,strong) NSData *IEEE,*shortAdr, *endpoint,*ProfileID,*DeviceID;
@property (nonatomic,strong) NSData *subDeviceZonetypeData;

//子设备的名字
@property (nonatomic,strong) NSString *subDeviceName;

//子设备ID  17个字节 + 32 字节 名字
@property (nonatomic,strong) NSData *productID;

//状态字节
@property (nonatomic,strong) NSString *stateStr;

//设置字节
@property (nonatomic,strong) NSString *settingStr;

//信号强度
@property (nonatomic,strong) NSString *sis;

//报警状态 子设备是否在线，电池是否低压，防拆开关，当前是否触发报警
@property (nonatomic,assign) BOOL isARMing,isOnline,batteryLow,disassembleEnable,trigger;

//子设备状态描述的文字  不同的设备的描述是不一样的
@property (nonatomic,strong) NSString* onlinestr,*BatteryStr,*disassembleEnableStr,*triggerStr;

//报警延时有效，布防延时有效 ， 白天布防有效，撤防,在家布防有效，外出布防有效
@property (nonatomic,assign) BOOL enableCheackOffline,armDlyEnable,almDlyEnable,daytimeEffective,disArmEffective,stayArmEffective,awayArmEffective;

//子设备的类型 类型名称 类型的图片
@property  (nonatomic,assign) ZoneType subDeviceType;
@property  (nonatomic,strong) NSString *subDeviceTypeName;
@property  (nonatomic,strong) UIImage *subDeviceIcon;

//对于PGM和警号  有自己的ID
@property (nonatomic,strong) NSString *PGMId;
@property (nonatomic,strong) NSString *SirenId;

//对于摄像头  有自己的ID
@property (nonatomic,strong) NSString *cameraID;
//每个摄像头的都会保存自己的主设备的did
@property (nonatomic,strong) NSString *dModelDid;
@property (nonatomic,strong) NSString *cameraName;
- (void)setCameraNewName:(NSString *)cam;
//子设备受控的中控设备
//@property  (nonatomic,weak) DeviceInfoModel *superDevice;



@end

//报警类
@interface NewAlarm : NSObject

@property(nonatomic,strong)NSString *armDate;

@property(nonatomic,strong)JDGizSubDevice *armDevice;

/** 掩码 */ //标识状态发生变化的位，例如掩码为0x01表示本次事件是状态的bit0变化
@property (nonatomic,strong) NSData *maskCode;

/** 事件属性 */
//事件属性其他说明：bit0为1本次事件是报警，bit1为1表示需要推送，bit2为1表示探测器有报警延时，延时结束才报警的，所以此时防区状态可能为0。
@property (nonatomic,strong) NSData *event;

//时间内容
@property (nonatomic,strong) NSArray<NSString *> *content;

//通过数据初始化
- (instancetype)initWithData:(NSData *)data;

@end

@interface DeviceInfoModel : NSObject 

//两次子设备刷新的间隔时间
@property (nonatomic,assign) NSInteger timeOut;

//机智云设备的信息

//机智云上的设备   设置该设备的时候会将网关所有的设备的信息设置到DeviceInfoModel里面
@property (nonatomic,strong) GizWifiDevice *gizDevice;

//机智云上的设备数据点信息
@property (nonatomic,strong) NSDictionary *gizDeviceData;

//获取到的绑定的设备对应的数据点信息
@property (nonatomic,strong) NSMutableArray <DataPointModel*>*gizDeviceDataPointArr;

//设备状态拓展
@property (nonatomic,strong) NSDictionary *gizDeviceAlerts;

//设备的默认信息
@property (nonatomic,strong) NSDictionary *gizDeviceFaults;

//设备的透传信息
@property (nonatomic,strong) NSData *gizDevcieBinary;

//设备状态  离线 在线 可控  不可用
@property (nonatomic,assign) GizWifiDeviceNetStatus gizIsOnline;

//设备名字
@property (nonatomic,strong) NSString *gizDeviceName;

//机智云给设备提供了一个可以更改的备注名字
@property (nonatomic,strong) NSString *gizEnableChangeName;

//网关设备的子设备集合   这里的信息需要根据偷穿的数据来获取
@property (nonatomic,strong) NSMutableArray<JDGizSubDevice*> *subDevices;

//网关设备的历史记录   这里的信息需要根据透传的数据来获取
@property (nonatomic,strong) NSMutableArray<JDDeviceHistoryRecord*> *deviceRecords;

//网关接到的报警事件的集合,这里的数据是根据数据点的信息来获取的
@property (nonatomic,strong) NSMutableArray<NewAlarm *> *anewArms;

//网关设备的类型  可能是不同网关  也可能是摄像头 也可能是探测器设备
@property (nonatomic,assign) GateawayType type;

//详细的探测器类型
@property (nonatomic,assign) DerectorType derectorType;

//推送语言是否可以设置
@property (nonatomic,assign) BOOL setLauEnable;

//是否有卡
@property (nonatomic,assign) BOOL numExist;

//设备语言
@property (nonatomic,assign) DeviceLauType lau;

//曾工的设备还有电话号码。 这里将获取到的号码存在一个数组中
@property (nonatomic,strong) NSMutableArray *phoneNumArr;

//曾工的设备的信号强度  GSM信号  给了三种状态 没插卡／正在搜网／有信号。  其中有信号的时候又会显示6种状态 对应不同的信号强度  对应的图片采用强队的值命名
@property (nonatomic,assign) GateawayDeviceSignalIntensity  SignalIntensity;

//曾工的设备的信号强度 WI-FI信号
@property (nonatomic,assign) GateawayDeviceWifiSingn  WIFISigna;

//曾工的设备数据点  反应设备是不有SIM卡
@property (nonatomic,assign) BOOL  gsm_sim_check;

//曾工的设备数据点  反应设备当前是不是在搜索设备GSM网络
@property (nonatomic,assign) BOOL  gsm_search_network;

//保存所有的设备的ID， 这个ID是一个集合 表示内包含了几个摄像头。
@property (nonatomic,copy) NSMutableArray <NSString*> * cameraIDs;

// 获取不同类型的设备的图片
- (UIImage *)deviceIcon;


- (void)getData:(NSDictionary *)dic;

/**
 * @brief  centerContorllDeviceGetSubDeviceInfo   下发获取子设备的信息
 *
 * @param
 *
 * @return
 */

- (void)getSubDeviceInfo: (void(^)())compelet;

/**
 * @brief  deleteSubDevice   删除子设备
 *
 * @param subdevice  子设备
 *
 * @return
 
 */
- (void)deleteSubDeviceWithSubDevice:(JDGizSubDevice *)subdevice;

/**
 * @brief addSubDevice  打开添加子设备的开关
 *
 * @param
 *
 * @return
 
 */
- (void)openSubDeviceSwitch;



/**
 * @brief  停止添加子设备的开关
 *
 * @param  0
 *
 * @return nil
 
 */
- (void)closeSubDeviceSwitch;

/**
 * @brief  gethistoryData  查询历史记录
 *
 * @param
 *
 * @return
 
 */

- (void)getHistoryDataWithIndexPage:(int )page;

/**
 * @brief  modify subdeviceinfon   修改子设备信息
 *
 * @param subdevice  子设备
 *
 * @return
 */
- (void)modfySubDeviceInfoWithSubDevice:(JDGizSubDevice *)device event:(id)event withType:(ModEventType)type;


/**
 * @brief  queryDevice PhoneNum 查询设备的电话号码
 *
 * @param
 *
 * @return nil
 
 */
- (void)getPhoneNum;



/**
 * @brief  addPhoneNum 添加电话号码
 *
 * @param  Num 用户想要添加的号码
 *
 * @return nil
 
 */

- (void)addDevicePhonNum:(NSString *)num;

/**
 * @brief  modifyDeviceNum Info 修改设备的电话号码的信息
 *
 * @param  type 号码类型
 * 
 * @param  index 号码索引
 * 
 * @param  phoneNum 号码字符
 *
 * @return nil
 
 */
- (void)eidtPhoneInfoWithType:(NSInteger)type index:(NSInteger)index num:(NSString*)phoneNum;

/**
 * @brief  add433TypeSubDevice
 *
 * @param  要添加的子设备类型
 *
 * @return nil
 
 */
- (void)addTypeSubDeviceWith:(ZoneType)type adress:(NSString *)adr;

/**
 * @brief  regiestSubDevice  PGM Siren、
 *
 * @param  要添加的子设备
 *
 * @return nil
 
 */
- (void)regiestAlarmAndPGM:(JDGizSubDevice *)subDevice;


/**
 add Camera ID for Device as subDevice. 添加摄像头

 @param ID 摄像头的ID
 */
- (void)addCameraWithID:(NSString *)ID compelet: (void(^)())action;


/**
 删除摄像头

 @param ID 摄像头的ID
 */
- (void)deleteCameraWithID:(NSString *)ID;


/**
 保存摄像头设置的密码

 @param cameraId 摄像头的ID
 @param psw 需要设置的密码
 */
- (void)saveCameraPswWithId:(NSString *)cameraId psw:(NSString *)psw;


/**
 获取摄像头的密码
 
 @param cameraId 摄像头的🆔
 @return 密码
 */
- (NSString *)getCameraPswWithId:(NSString *)cameraId;


/**
 删除摄像头的密码
 
 @param cameraId 摄像头的ID
 */
- (void)removeCameraPswWithId:(NSString *)cameraId;


/**
 删除保存的摄像头名字

 @param ID 
 */
- (void)removeCameraName:(NSString *)ID;


/**
 判断当前主机是否包含了某个摄像头

 @param ID 摄像头的ID
 */
- (BOOL)isCameraExistWithId: (NSString*)ID;

@end


