//
//  RootViewController.h
//  jadeApp2
//
//  Created by JD on 16/10/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class EquipmentPage;


@interface RootViewController : BaseViewController
@property(nonatomic,strong) UITableView *tableView;

- (instancetype)initwithEquipage:(EquipmentPage *)vc;

- (void)getCurrentWeather;

- (void)setATableHeardView;


@end
