//
//  EnumHeader.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h

//雄迈请求函数seq
typedef enum
{
    RegisterFucSeq = 10001,          //用户注册(手机验证码)
    GetEmailtestCodeSeq,             //获取邮箱验证码
    RegisterWithEmailCodeSeq,        //通过邮箱注册
    NormalRegisterFucSeq,            //无限制用户注册
    LoginFucSeq,                     //用户登录
    ModifyuserPswSeq,                //用户密码修改
    SendPhoneMessageSeq,             //发送手机验证码
    SearchDeviceSeq,                 //搜索周边的设备
    SetDeviceSeq,                    //配置设备（JS）
}XmeyeFuctionSeq;

//设备对应的类型
typedef enum
{
    type1 = 1001,
    type2,
    type3,
    
}JDDeviceType;

//布防状态
typedef enum
{
    ARMAWAY = 101,
    ARMSTAY,
    DIDARM,
    
}JDArmState;

//网关控制的类型
typedef enum
{
    JumpType = 201,
    SwitchType,
    NumType,
    WordType,
    SegmentType,
    JumpWordType,
}GateWayCellType;

//zoneType
typedef enum
{
    MotionSensorType = 251,  //人感红外
    MagnetometerType ,       //门磁
    FireSensorType,          //火感
    WaterSensorType,         //水感应
    GasSensorType,           //气感
    PGMType,                 //PGM
    RemoterContorlType,      //遥控
    DoorRingType,            //门铃
    VibrationType,           //震动感应
    AlarmType,               //报警类型
    APPType,                 //app发送的类型
    SoSType,                 //紧急按钮
    CameraType,              //摄像头设备
    UndownType,              //未知类型感应
}ZoneType;

//0.门磁 1.被动红外 2.烟雾 3.燃气 4.水浸 5.紧急按钮 6.振动 7.玻璃破碎 8.电子围栏 9.红外对射
//0.MGT 1.PRO 2.SMK 3.GAS 4.WAT 5.SOS 6.VTT 7.BTT 8.ECW 9.PRO_S
typedef enum : NSUInteger {
    MGT = 0,
    PRO,
    SMK,
    GAS,
    WAT,
    SOS,
    VTT,
    BTT,
    ECW,
    PRO_S,
    None = 99,
} DerectorType;

typedef NS_OPTIONS(NSInteger, ModEventType) {
    
    ModEventModNameType    = 1 << 0, // 1
    ModEventModArmDlyType  = 1 << 1, // 2  报警延时
    ModEventModAlmDlyType = 1 << 2, // 4   布防延时
    ModEventModDisarmEffectiveType  = 1 << 3, // 8
    ModEventModArmstayEffectiveType  = 1 << 4, // 16
    ModEventModArmawayEffectiveType  = 1 << 5, // 32
    ModEventModSetType = 1 << 6 ,//64
    ModEventCancleFlashesType = 1<<7, //最高了 再移动就没有了  这是唯一的一个修改状态的类型  目的是取消闪灯  其余上面的都是修改设置的数据
};

typedef NS_OPTIONS(NSInteger, ServerType) {
    
    ServerTypeChina    = 1 << 0, // 1 中国
    ServerTypeAE  = 1 << 1, // 2  美东
    ServerTypeUE = 1 << 2, // 4   欧洲
   
};

//typedef NS_ENUM(NSInteger, GateawayType){
//
//    GateawayTypeDeafult = 0 ,   //涂工的设备
//    GateawayTypeOneZigbee = 1 , //曾工的zigbee设备    带电话卡
//    GateawayTypeOneGSMRF = 2 ,  //曾工的RF设备        带电话卡
//    GateawayTypeOneRF = 3 ,     //曾工的RF设备        不带电话卡
//    GateawayTypeOneRF = 3 ,     //曾工的RF设备        不带电话卡
//    GateawayTypeCamer = 5 ,      //摄像头设备
//};

typedef NS_ENUM(NSInteger, GateawayType){
    GateawayTypeDeafult  = 0 ,   //zigbee
    GateawayType433868  = 1 ,    //433/868    
    GateawayTypeWGZ  = 2 ,       //WGZ
    GateawayTypeCamer  = 3,      //摄像头设备
    GateawayTypeDerector  = 4,      //探测器设备
};

typedef NS_ENUM(NSInteger, NumExistType){
    NumExist = 11,          // 有卡类型
    NumNoExist = 12,        // 无卡类型
};

typedef NS_ENUM(NSInteger, DeviceLauType){
    EN = 0,          // 英文
    CH = 1,        // 中文
    RU = 2,        // 俄罗斯
};

typedef NS_ENUM(NSInteger, GateawayDeviceSignalIntensity){  //GSM 的信号展示
    GateawayDeviceNoShow = 0 ,          //不显示
    GateawayDeviceNoSMSCard = 1 ,       //设备没有插入SMS卡
    GateawayDeviceSearching = 2 ,       //设备正在搜索中
    GateawayDeviceIntensityLowest = 3 , //信号强度为 不知道  未知
    GateawayDeviceIntensityOne = 4 ,    //一格信号
    GateawayDeviceIntensityTwo = 5 ,    //两格信号
    GateawayDeviceIntensityThree = 6 ,  //三格信号
    GateawayDeviceIntensityFour = 7 ,   //四格信号
    GateawayDeviceIntensityFive = 8 ,   //五格信号
};

typedef NS_ENUM(NSInteger, GateawayDeviceWifiSingn){  //Wifi 的信号展示
    GateawayDeviceWifiZero = 0 ,        //信号强度0
    GateawayDeviceWifiOne = 1 ,        //信号强度1
    GateawayDeviceWifiTwo  = 2 ,       //信号强度2
    GateawayDeviceWifiThree = 3 ,      //信号强度3
    GateawayDeviceWifiFour = 4 ,       //信号强度4
   };

#endif /* EnumHeader_h */
