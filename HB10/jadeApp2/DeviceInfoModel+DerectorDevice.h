//
//  DeviceInfoModel+DerectorDevice.h
//  JADE
//
//  Created by JD on 2018/4/25.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"


@interface DeviceInfoModel (DerectorDevice)

// 触发状态
- (BOOL)trig;

- (BOOL)antiTamper;

- (BOOL)lowBat;

- (BOOL)alarm;

- (BOOL)arm;

- (BOOL)fault;

- (GateawayDeviceWifiSingn)rssi;

- (DerectorType)derectorType;

@end
