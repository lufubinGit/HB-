//
//  AddMoreSubDevciePage.h
//  jadeApp2
//
//  Created by JD on 2016/11/28.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "EnumHeader.h"
@class DeviceInfoModel;

@interface AddMoreSubDevciePage : BaseViewController

@property(nonatomic,strong) DeviceInfoModel *currentDevie;
@property(nonatomic,assign) ZoneType type;

@end
