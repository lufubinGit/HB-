//
//  UnbindTableViewCell.h
//  jadeApp2
//
//  Created by JD on 2016/11/17.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceInfoModel;

typedef void(^UnbindTableViewCellcall)(void);

@interface UnbindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (nonatomic,copy) UnbindTableViewCellcall callback;
@property (weak, nonatomic) IBOutlet UILabel *mac;
@property (nonatomic,strong) DeviceInfoModel *model;

@end
