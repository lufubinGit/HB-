//
/** @file GWP2PClient+Sensor.h @brief 处理传感器的分类 */
//  P2PSDK
//
//  Created by apple on 17/3/13.
//  Copyright © 2017年 gwell. All rights reserved.
//




#import "GWP2PClient.h"

#pragma mark - 情景模式设备数据模型
/**
 情景模式设备传感器唯一标识，由三个值标记，硬件规范。特殊传感器（移动侦测和攻防）不需要标识.
 */
typedef struct GWSceneModeDeviceSensorIdentify {
    NSUInteger data0;
    NSUInteger data1;
    NSUInteger data2;
} GWSceneModeDeviceSensorIdentify;


/**
 特殊传感器类型
 */
typedef NS_ENUM(NSUInteger, GWSceneModeDeviceSpecialSensorType) {
    GWSceneModeDeviceSpecialSensorTypeMotionDetect, /**< 0 移动侦测 */
    GWSceneModeDeviceSpecialSensorTypeAttack, /**< 1 防攻击 */
    
    GWSceneModeDeviceSpecialSensorTypeMAX = 8, //
};

/**
 普通传感器及遥控
 */
typedef NS_ENUM(NSUInteger, GWSceneModeDeviceCommonSensorType) {
    //传感器对应的UI                                                     (有无开关，有无情景模式)
    GWSceneModeDeviceCommonSensorTypeRemoteController,  /**< 0 遥控器       (无， 无)  */
    GWSceneModeDeviceCommonSensorTypeDoorSwitch ,       /**< 1 门磁         (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeSmokeTransducer,   /**< 2 烟雾传感器    (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeGasSensor ,        /**< 3 瓦斯探测传感器 (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeLight,             /**< 4 电灯         (有， 无)  */
    GWSceneModeDeviceCommonSensorTypeCurtain,           /**< 5 窗帘         (有， 无)  */
    GWSceneModeDeviceCommonSensorTypeScocket,           /**< 6 插座         (有， 无)  */
    GWSceneModeDeviceCommonSensorTypePIR,               /**< 7 人体红外      (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeWaterInvade,       /**< 8 水浸          (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeUrgency,           /**< 9  急救         (有， 有)  */
    GWSceneModeDeviceCommonSensorTypeWarningSpeaker,    /**< 10 警号         (有， 无)  */
    GWSceneModeDeviceCommonSensorTypeAirConditioner     /**< 11 空调传感器    (有,  无)  */
};


/**
 情景模式设备传感器类型
 
 1 特殊传感器 ：移动侦测、防攻击
 
 0 普通传感器和遥控器 普通传感器类型有：1为门磁；2为烟雾；3为瓦斯；4为电灯；5为窗帘；7为插座；等等...
 */
typedef enum GWSceneModeDeviceSensorMainType{
    GWSceneModeDeviceSensorTypeCommonSensorOrRemoteController, /**< 0 普通传感器及遥控 */
    GWSceneModeDeviceSensorTypeSpecialSensor, /**< 1 特殊传感器 */
} GWSceneModeDeviceSensorMainType;

/**
 情景模式设备传感器类型，硬件规范，用两个值来标识类型
 */
typedef struct GWSceneModeDeviceSensorType {
    GWSceneModeDeviceSensorMainType type; /**< 特殊传感器、普通传感器或遥控器 */
    NSUInteger subType;/**< 根据type的不同，表示不同的传感器 */
} GWSceneModeDeviceSensorType;



/**
 情景模式设备 类型插座的传感器的操作类型
 */
typedef enum GWSensorLikeSocketOperationType {
    GWSensorLikeSocketOperationTypeQuery = 1,//情景模式设备， 查询 类似插座传感器的开关状态
    GWSensorLikeSocketOperationTypeOpen,//情景模式设备， 打开 类似插座传感器的开关
    GWSensorLikeSocketOperationTypeClose,//情景模式设备， 关闭 类似插座传感器的开关
    GWSensorLikeSocketOperationTypeHalfOpen,//情景模式设备， 使类型插座传感器的开关处于 半开 状态
} GWSensorLikeSocketOperationType;







/** @brief 情景模式设备 各种传感器类型值及功能情况
 
 名称        type   subType  有无开关  有无情景模式 有无传感器唯一标识 是否支持名字
 
 移动侦测      1       0         有         有           无          否      特殊传感器
 
 防攻击        1       1         有         有           无          否      特殊传感器
 
 遥控器        0       0         无         无           有          是     下面都是普通传感器或遥控器
 
 门磁          0       1         有         有           有          是
 
 烟雾传感器     0       2         有         有           有          是
 
 瓦斯探测传感器  0       3         有         有           有          是
 
 电灯          0       4         有         无           有          是
 
 窗帘          0       5         有         无           有          是
 
 插座          0       6         有         无           有          是
 
 人体红外       0       7         有         有           有          是
 
 水浸          0       8         有         有           有          是
 
 急救          0       9         有         有           有          是
 
 警号          0       10        有         无           有          是
 
 空调传感器     0       11        有         无           有          是
 */
@interface GWSceneModeDeviceSensorModel : NSObject

//2个值唯一标识某个传感器 硬件规范
@property (nonatomic, assign) GWSceneModeDeviceSensorType sensorType;/**< 传感器类型。从硬件获取到，操作传感器时用，不要更改 */
//3个值唯一标识某个传感器 硬件规范
@property (nonatomic, assign) GWSceneModeDeviceSensorIdentify identify;/**< 传感器唯一标识，特殊传感器（移动侦测、攻防）不用标识。从硬件获取到，操作传感器时用，不要更改。 */

@property (nonatomic, assign) NSUInteger bindedPresetPositionIndex;/**< 绑定的预置位索引 */

//在家模式
@property (nonatomic, assign) BOOL enableAtHome;/**< 在家模式是否开启 */
@property (nonatomic, assign) BOOL enablePushAtHome;/**< 在家模式推送是否开启 */
@property (nonatomic, assign) BOOL enableSnapshotAtHome;/**< 在家模式快照是否开启 */
@property (nonatomic, assign) BOOL enableRecordAtHome;/**< 在家模式录像是否开启 */
@property (nonatomic, assign) NSUInteger warningToneAtHome;/**< 在家模式的报警声音类型 */

//外出模式
@property (nonatomic, assign) BOOL enableGoOut;/**< 外出模式是否开启 */
@property (nonatomic, assign) BOOL enablePushGoOut;/**< 外出模式推送是否开启 */
@property (nonatomic, assign) BOOL enableSnapshotGoOut;/**< 外出模式快照是否开启 */
@property (nonatomic, assign) BOOL enableRecordGoOut;/**< 外出模式录像是否开启 */
@property (nonatomic, assign) NSInteger warningToneGoOut;/**< 外出模式的报警声音类型 */

//睡眠模式
@property (nonatomic, assign) BOOL enableSleep;/**< 睡眠模式是否开启 */
@property (nonatomic, assign) BOOL enablePushSleep;/**< 睡眠模式推送是否开启 */
@property (nonatomic, assign) BOOL enableSnapshotSleep;/**< 睡眠模式快照是否开启 */
@property (nonatomic, assign) BOOL enableRecordSleep;/**< 睡眠模式录像是否开启 */
@property (nonatomic, assign) NSUInteger warningToneSleep;/**< 睡眠模式的报警声音类型 */

@property (nonatomic, copy) NSString *name;/**< 传感器名字 */
@property (nonatomic, assign) BOOL nameHasBeChanged;/**< 名字是否被改过 */

@property (nonatomic, assign) int bLampStatu;/**< 开关状态 */

@end




#pragma mark - GWP2PClient
/**
 @brief 处理传感器的分类
 */
@interface GWP2PClient (Sensor)

#pragma mark - 普通设备传感器
/**
 获取设备已连接的传感器及遥控器
 
 completionBlock返回字典中：
 
 @"sensors" 键对应一个数组（NSMutableArray<NSDictionary *> *），数组中一个字典对应一个设备连接的传感器
 
 传感器的字典中，index 键对应的值为传感器连接设备的防区位置，0-7为遥控器，8-63为普通传感器，64-71为特殊传感器，操作传感器时用做标识， description 键对应的值为字符串描述的传感器类型
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceConnectedSensorsWithDeviceID:(NSString *)deviceID
                               devicePassword:(NSString *)devicePassword
                              completionBlock:(CompletionBlock)completionBlock;

/**
 获取已连接传感器的开关状态（遥控器不支持）
 
 completionBlock返回字典中：
 
 @"swithches status" 键对应一个数组（NSMutableArray<NSDictionary *> *）,数组中的字典个数与传入sensorIndexesArray的NSNumber个数对应，且index相同，字典中 on 键对应的值为BOOL封装的NSNumber类型，表示index下的传感器有没有打开
 
 @param sensorIndexesArray      传感器的索引数组，索引范围为8-71（遥控器没有开关状态），不要重复，若所传的索引未添加传感器，获取到的开关状态会为YES
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceSwitchStateOfConnectedSensorsWithSensorIndexes:(NSArray<NSNumber *> *)sensorIndexesArray
                                                       deviceID:(NSString *)deviceID
                                                 devicePassword:(NSString *)devicePassword
                                                completionBlock:(CompletionBlock)completionBlock;

/**
 获取传感器绑定的预置位（报警时转向预置位）（遥控器不支持）
 
 获取前先调 getMultipledeviceStatusWithDeviceID:password:completionBlock: 获取设备是否支持预置位功能（返回字典中没有支持预置位键 preset position suppurted 就是不支持），支持才获取
 
 completionBlock返回字典中：
 
 @"sensor index" 键对应的值为传感器索引
 
 @"preset position index" 键对应绑定的预置位索引值（0-4），255 表示未绑定预置位
 
 @"alarm type" 暂时不用
 
 @param sensorIndex             传感器的索引值，绑定预置位只支持索引值范围为8-15（普通传感器）、64-71（特殊传感器），其它的不支持
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDevicePresetPositionBindedByConnectedSensorWithSensorIndex:(NSUInteger)sensorIndex
                                                             deviceID:(NSString *)deviceID
                                                       devicePassword:(NSString *)devicePassword
                                                      completionBlock:(CompletionBlock)completionBlock;

/**
 让传感器绑定预置位（报警时转向预置位）（遥控器不支持）
 
 设备不支持时调用无效
 
 @param presetPositionIndex     预置位索引值
 @param sensorIndex             传感器的索引值，绑定预置位只支持索引值范围为8-15（普通传感器）、64-71（特殊传感器），其它的不支持
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)bindPresetPosition:(NSUInteger)presetPositionIndex
       withConnectedSensor:(NSUInteger)sensorIndex
                  deviceID:(NSString *)deviceID
            devicePassword:(NSString *)devicePassword
           completionBlock:(CompletionBlock)completionBlock;

/**
 获取传感器的名字 (一次获取所有已连接传感器的名字)
 
 先调用该接口，看看设备是否支持传感器名字存储，老版本设备不支持，app的名字操作在本地也要同时存储
 
 completionBlock返回字典中：
 
 @"sensor names" 键对应一个数组（NSMutableArray<NSDictionary *> *），数组中的每个字典对应一个传感器的索引（键为 index）和名字（键为 name）
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)getDeviceSensorNamesWithDeviceID:(NSString *)deviceID
                          devicePassword:(NSString *)devicePassword
                         completionBlock:(CompletionBlock)completionBlock;

/**
 设置传感器的名字 （一次只能设置一个传感器的名字）
 
 @param sensorName              要设置的传感器名字，长度为1-16位
 @param sensorIndex             传感器索引值
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setDeviceSensorName:(NSString *)sensorName
            withSensorIndex:(NSUInteger)sensorIndex
                   deviceID:(NSString *)deviceID
             devicePassword:(NSString *)devicePassword
            completionBlock:(CompletionBlock)completionBlock;

/**
 操作一个传感器或遥控器
 
 @param sensorIndex             传感器索引值: 0-7为遥控器，8-63为普通传感器，64-71为特殊传感器，删除时若传入索引未连接传感器，可能会返回删除成功
 @param operationType           操作类型：只支持增加、删除
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)operateASensor:(NSUInteger)sensorIndex
     withOperationType:(P2POperationType)operationType
              deviceID:(NSString *)deviceID
        devicePassword:(NSString *)devicePassword
       completionBlock:(CompletionBlock)completionBlock;

/**
 设置一个传感器（不包括遥控器）的开关状态
 
 @param sensorIndex             传感器索引值: 不支持遥控器，8-63为普通传感器，64-71为特殊传感器
 @param switchOn                操作类型：只支持增加、删除
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)setASensor:(NSUInteger)sensorIndex
       switchState:(BOOL)switchOn
          deviceID:(NSString *)deviceID
    devicePassword:(NSString *)devicePassword
   completionBlock:(CompletionBlock)completionBlock;


#pragma mark - 情景模式设备传感器
/**
 情景模式设备 获取所有传感器信息（包括遥控器、普通传感器、特殊传感器）
 
 completionBlock返回字典中：
 
 @"sensors" 键对应一个 NSArray<GWSceneModeDeviceSensorModel *> * 数组
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceGetSensorsInfomationWithDeviceID:(NSString *)deviceID
                                         devicePassword:(NSString *)devicePassword
                                        completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 操作一个插座类型的传感器的开关状态
 
 插座类型的判断条件
 
 sensorType.type == 0 && //主类型为普通传感器或遥控器
 
 (sensorType.subType == GWSceneModeDeviceCommonSensorTypeScocket || //子类型为 插座
 
 sensorType.subType == GWSceneModeDeviceCommonSensorTypeLight ||  //子类型为 电灯
 
 sensorType.subType == GWSceneModeDeviceCommonSensorTypeCurtain ||  //子类型为 窗帘
 
 sensorType.subType == GWSceneModeDeviceCommonSensorTypeWarningSpeaker ||  //子类型为 警号
 
 sensorType.subType == GWSceneModeDeviceCommonSensorTypeAirConditioner)  //子类型为 空调传感器
 
 @param sensorIdentify          传感器标识，由设备获取
 @param sensorType              传感器类型，由设备获取，类型和标识都要传对
 @param operationType           操作类型，四个枚举值
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceOperateSwitchStateOfSensorLikeSocket:(GWSceneModeDeviceSensorIdentify)sensorIdentify
                                             withSensorType:(GWSceneModeDeviceSensorType)sensorType
                                              operationType:(GWSensorLikeSocketOperationType)operationType
                                                   deviceID:(NSString *)deviceID
                                             devicePassword:(NSString *)devicePassword
                                            completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 设置遥控器名字
 
 @param remoteControlName       遥控器名字，16个字节，大于16个字节后的忽略
 @param remoteControlIdentify   遥控器标识，由设备获取
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceSetRemoteControlName:(NSString *)remoteControlName
                         withSensorIdentify:(GWSceneModeDeviceSensorIdentify)remoteControlIdentify
                                   deviceID:(NSString *)deviceID
                             devicePassword:(NSString *)devicePassword
                            completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 设置传感器名字
 
 @param sensorName              遥控器名字，16个字节，大于16个字节后的忽略,设为空时传 @""
 @param sensorIdentify          传感器标识，由设备获取
 @param sensorType              传感器类型，由设备获取，类型和标识都要传对
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceSetSensorName:(NSString *)sensorName
                  withSensorIdentify:(GWSceneModeDeviceSensorIdentify)sensorIdentify
                          sensorType:(GWSceneModeDeviceSensorType)sensorType
                            deviceID:(NSString *)deviceID
                      devicePassword:(NSString *)devicePassword
                     completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 删除一个遥控器
 
 @param remoteControlIdentify   遥控器标识，由设备获取
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceRemoveARemoteControl:(GWSceneModeDeviceSensorIdentify)remoteControlIdentify
                                   deviceID:(NSString *)deviceID
                             devicePassword:(NSString *)devicePassword
                            completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 删除一个传感器
 
 @param sensorType              传感器类型，由设备获取
 @param sensorIdentify          传感器标识，由设备获取，类型和标识都要传对
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceRemoveASensor:(GWSceneModeDeviceSensorIdentify)sensorIdentify
                      withSensorType:(GWSceneModeDeviceSensorType)sensorType
                            deviceID:(NSString *)deviceID
                      devicePassword:(NSString *)devicePassword
                     completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 连接一个传感器或遥控器
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceConnectASensorOrRemoteControlWithDeviceID:(NSString *)deviceID
                                                  devicePassword:(NSString *)devicePassword
                                                 completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 通过二维码扫描连接一个传感器或遥控器
 
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceConnectASensorOrRemoteControlWithQRCode:(NSString *)codeString
                                                      deviceID:(NSString *)deviceID
                                                devicePassword:(NSString *)devicePassword
                                               completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 设置特殊传感器（包括移动侦测和防攻击。其它的传感器调此指令，即使返回成功，也无实际设置效果）
 
 包括设置情景模式，预置位(需要设备支持)
 
 @param sensorModel             传感器模型
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceSetASpecialSensor:(GWSceneModeDeviceSensorModel *)sensorModel
                            withDeviceID:(NSString *)deviceID
                          devicePassword:(NSString *)devicePassword
                         completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 设置普通传感器情景模式
 
 传感器是否支持情景模式参考 GWSceneModeDeviceSensorModel 的注释
 
 @param sensorModel             传感器模型,只设置情景模式（在家、外出、睡眠三种情景模式的开关，提示音，推送，抓拍，录像情况），模型中其它的数据不处理
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceSetSceneMode:(GWSceneModeDeviceSensorModel *)sensorModel
                       withDeviceID:(NSString *)deviceID
                     devicePassword:(NSString *)devicePassword
                    completionBlock:(CompletionBlock)completionBlock;

/**
 情景模式设备 设置普通传感器预置位（需要设备支持，设置时先获取预置位信息）
 
 @param presetPositionIndex     预置位索引
 @param sensorIdentify          传感器标识，由设备获取，类型和标识都要传对
 @param sensorType              传感器类型，由设备获取
 @param deviceID                设备ID
 @param devicePassword          设备密码
 @param completionBlock         与设备交互完成后的回调Block
 */
- (void)sceneModeDeviceSetCommonSensorPresetPosition:(NSUInteger)presetPositionIndex
                                  withSensorIdentify:(GWSceneModeDeviceSensorIdentify)sensorIdentify
                                          sensorType:(GWSceneModeDeviceSensorType)sensorType
                                            deviceID:(NSString *)deviceID
                                      devicePassword:(NSString *)devicePassword
                                     completionBlock:(CompletionBlock)completionBlock;

#pragma mark - 门铃开锁
- (void)doorbellDeviceUnlockWithDeviceID:(NSString *)deviceID
                          devicePassword:(NSString *)devicePassword
                         completionBlock:(CompletionBlock)completionBlock;

@end
