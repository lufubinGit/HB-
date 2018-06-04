//
//  DerectorDetailPage.h
//  JADE
//
//  Created by BennyLoo on 2018/6/4.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class DeviceInfoModel;

@interface DerectorDetailPage : BaseViewController

@property (nonatomic,strong) DeviceInfoModel *currentDevice;

- (instancetype)initWithDevcie:(DeviceInfoModel *)device;

- (void)refreshPageWithDevice:(DeviceInfoModel *)device;

@end
