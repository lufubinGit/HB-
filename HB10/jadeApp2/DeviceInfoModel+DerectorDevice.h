//
//  DeviceInfoModel+DerectorDevice.h
//  JADE
//
//  Created by JD on 2018/4/25.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DeviceInfoModel.h"

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
} DerectorType;

@interface DeviceInfoModel (DerectorDevice)

// 触发状态
- (BOOL)trig;

- (BOOL)antiTamper;

- (BOOL)lowBat;

- (BOOL)alarm;

- (DerectorType)devType;

- (BOOL)arm;

- (BOOL)fault;

- (GateawayDeviceWifiSingn)rssi;

- (BOOL)isDerectorDevice;

@end
