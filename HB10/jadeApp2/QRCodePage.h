//
//  QRCodePage.h
//  JADE
//
//  Created by JD on 2017/10/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRcodeSupportVC.h"
#import "BaseViewController.h"
#import "DeviceInfoModel.h"

@interface QRCodePage :BaseViewController
/**
 二维码将展示的是设备的ID
 */
@property (nonatomic,strong) DeviceInfoModel *device;

@end
