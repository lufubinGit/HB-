//
//  BaseViewController.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "EnumHeader.h"
@class DeviceInfoModel;

@interface BaseViewController : UIViewController

@property (nonatomic,assign) BOOL dismissKeyBEnable;
- (void)dismisKeyB;

@end
