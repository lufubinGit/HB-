//
//  SHowSubDeviceCell.h
//  jadeApp2
//
//  Created by JD on 2016/11/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDGizSubDevice;
@interface SHowSubDeviceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *intoVideoButton;
@property (weak, nonatomic) IBOutlet UIImageView *armImage;
@property (weak, nonatomic) IBOutlet UIImageView *BGimageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *subDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *subDeviceLocal;
@property (weak, nonatomic) IBOutlet UILabel *thumName;

@property (nonatomic,strong) JDGizSubDevice *subDevice;

@end
