//
//  StateTableViewCell.h
//  jadeApp2
//
//  Created by JD on 16/9/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfoModel.h"

@class StateTableViewCell;
@class GizWifiDevice;
@class DataPointModel;

typedef void(^callBlock)(void);

@protocol StateTableViewCellDelegate <NSObject>

- (void)StateTableViewCell:(StateTableViewCell *)cell clickDeviceState:(DeviceInfoModel *)device AtArmaway:(UIButton *)armaway;
- (void)StateTableViewCell:(StateTableViewCell *)cell clickclickDeviceState:(DeviceInfoModel *)device AtArmstay:(UIButton *)armsaty;
- (void)StateTableViewCell:(StateTableViewCell *)cell clickDeviceState:(DeviceInfoModel *)device AtDisarm:(UIButton *)disarm;


@end
typedef  void(^SetState)(JDArmState);
@interface StateTableViewCell : UITableViewCell

@property (nonatomic,assign) JDArmState jdState;
@property (weak, nonatomic) IBOutlet UILabel *currentDeviceStatus;
@property (weak, nonatomic) IBOutlet UIButton *armAway;
@property (weak, nonatomic) IBOutlet UIButton *armStay;
@property (weak, nonatomic) IBOutlet UIButton *disArm;
@property (copy,nonatomic) SetState setState;
@property (weak, nonatomic) IBOutlet UIImageView *SetingImage;
@property (nonatomic,weak) id<StateTableViewCellDelegate> delegate;
@property (nonatomic,strong) DeviceInfoModel *currentDevice;

@property (nonatomic,copy) callBlock call;

@property (nonatomic,strong) DataPointModel *model;

@end
