//
//  SearchCameraPage.h
//  JADE
//
//  Created by JD on 2017/5/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;

@interface SearchCameraPage : BaseViewController

@property (nonatomic,strong) NSString *SSID;   //用户选择的Wi-Fi

@property (nonatomic,strong) NSString *psw;    //WIfi 密码

@property (nonatomic,strong) DeviceInfoModel *dModel;  //跟随入网的设备  作为一个全局变量


@end
