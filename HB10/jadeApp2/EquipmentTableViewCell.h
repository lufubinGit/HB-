//
//  EquipmentTableViewCell.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceInfoModel;
@class DataPointModel;
@interface EquipmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *Switch;

@property (weak, nonatomic) IBOutlet UILabel *deviceBrief;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceState;
@property (nonatomic,strong)  DataPointModel *model;
@property (weak, nonatomic) IBOutlet UILabel *isOline;
@property (weak, nonatomic) IBOutlet UIImageView *BGimage;

@end
