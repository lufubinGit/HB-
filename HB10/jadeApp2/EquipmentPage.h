//
//  EquipmentPage.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EquipmentPage : BaseViewController

/*
 跳转视图
 */
-(void)navPushToVc:(UIViewController* )vc;
- (void)refrshTableView;  //刷新所有的数据
//本地化语言的设置
- (void)localLanguage;
- (void)intoGetwaySettingPage:(DeviceInfoModel *)device;

@end
