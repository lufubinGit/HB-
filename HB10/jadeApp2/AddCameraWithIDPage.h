//
//  AddCameraWithIDPage.h
//  
//
//  Created by JD on 2018/4/17.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class DeviceInfoModel;
@interface AddCameraWithIDPage : BaseViewController

@property (nonatomic,strong) DeviceInfoModel *dModel;  //跟随入网的设备  作为一个全局变量

@end
