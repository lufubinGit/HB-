//
//  BaseSubDevicePage.h
//  jadeApp2
//
//  Created by JD on 2016/12/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceInfoModel;
@class JDGizSubDevice;

@interface BaseSubDevicePage : BaseViewController
@property (nonatomic,strong) UIButton *BgButton;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *arrawImage;
@property (nonatomic,strong) DeviceInfoModel *currentDevice;

//从上级页面传过来
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIImage *icon;

- (void)initUI;

- (instancetype)initWithDevice:(JDGizSubDevice *)device centerDevice:(DeviceInfoModel *)centerDevice;


@end
