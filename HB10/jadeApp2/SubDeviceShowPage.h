//
//  SubDeviceShowPage.h
//  JADE
//
//  Created by JD on 2017/8/4.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;
@interface SubDeviceShowPage : BaseViewController

@property (nonatomic,strong) DeviceInfoModel *model;

- (void)refreshTableView;
@end
