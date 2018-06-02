//
//  GateWayNameEidtPage.h
//  jadeApp2
//
//  Created by JD on 2016/11/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;

@interface GateWayNameEidtPage : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *brief;
@property (strong, nonatomic) UIButton *saveButton;
@property (nonatomic,strong) DeviceInfoModel *centerDevice;
- (void)initUI;

@end
