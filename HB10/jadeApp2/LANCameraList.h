//
//  LANCameraList.h
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;
@interface LANCameraList : BaseViewController

//需要摄像头绑定的设备
@property (nonatomic,strong) DeviceInfoModel *dModel;

@end
