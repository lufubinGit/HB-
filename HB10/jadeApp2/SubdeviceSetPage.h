//
//  SubdeviceSetPage.h
//  jadeApp2
//
//  Created by JD on 2016/12/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;
@class JDGizSubDevice;
@interface SubdeviceSetPage : BaseViewController
- (instancetype)initWithSubdevice:(JDGizSubDevice *)subdevice andCenterDevice:(DeviceInfoModel*)centerDevice;
- (void)refrshData;
@end
