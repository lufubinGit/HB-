//
//  AddPGMAndSirenPage.h
//  JADE
//
//  Created by JD on 2017/4/28.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EnumHeader.h"
@class DeviceInfoModel;

@interface AddPGMAndSirenPage : BaseViewController
@property(nonatomic,strong) DeviceInfoModel *currentDevie;
@property(nonatomic,assign) ZoneType type;
@end
