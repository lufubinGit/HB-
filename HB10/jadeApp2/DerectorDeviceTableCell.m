

//
//  DerectorDeviceTableCell.m
//  JADE
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DerectorDeviceTableCell.h"
#import "DeviceInfoModel.h"
#import "DeviceInfoModel+DerectorDevice.h"
@interface DerectorDeviceTableCell ()

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UIImageView *signal;
@property (strong, nonatomic) IBOutlet UILabel *state;

@end
@implementation DerectorDeviceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = APPLINECOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DeviceInfoModel *)model{
    self.name.text = model.gizDeviceName;
    self.type.text = [NSString stringWithFormat:@"%@",[model devType]] ;
//    self.signal.image =
    self.state.text = [NSString stringWithFormat:@"%d",[model gizIsOnline]];
    
}

@end
