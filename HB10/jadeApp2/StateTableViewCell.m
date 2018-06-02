//
//  StateTableViewCell.m
//  jadeApp2
//
//  Created by JD on 16/9/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "StateTableViewCell.h"
#import "GizSupport.h"
#import "DeviceInfoModel.h"
#import "DataPointModel.h"
#import "JDAppGlobelTool.h"

@class GizWifiDevice;
@implementation StateTableViewCell
{
    UIButton *_oldButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.armAway.layer.cornerRadius = PublicCornerRadius;
    self.armStay.layer.cornerRadius = PublicCornerRadius;
    self.disArm.layer.cornerRadius = PublicCornerRadius;
    
    self.armStay.layer.masksToBounds = YES;
    self.armAway.layer.masksToBounds = YES;
    self.disArm.layer.masksToBounds = YES;

    self.armAway.layer.borderWidth = 1.0;
    self.armAway.layer.borderColor = APPMAINCOLOR.CGColor;
    _oldButton = self.armAway;

    self.armStay.layer.borderWidth = 1.0;
    self.armStay.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.disArm.layer.borderWidth = 1.0;
    self.disArm.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.armAway setTitle:@"ARMAWAY" forState:UIControlStateNormal];
    [self.armStay setTitle:@"ARMSTAY" forState:UIControlStateNormal];
    [self.disArm setTitle:@"DISARM" forState:UIControlStateNormal];
    
    [self.armAway setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.armStay setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.disArm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_oldButton setTitleColor:APPMAINCOLOR forState:UIControlStateNormal];
}


- (void)setModel:(DataPointModel *)model{

    NSString *str = @"no signal";
    if([model.dataPointValue integerValue] == 0){
        str = @"disarm";
    }else if ([model.dataPointValue integerValue] == 1){
        str = @"armstay";
    }else if ([model.dataPointValue integerValue] == 2){
        str = @"armaway";
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"current state：%@",str]];
    [string addAttribute:NSForegroundColorAttributeName value:APPSAFEGREENCOLOR range:NSMakeRange(14, string.length-14)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(14, string.length-14)];
    
    self.currentDeviceStatus.attributedText = string;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)setStateArmAway:(id)sender {
    [self.delegate StateTableViewCell:self clickDeviceState:self.currentDevice AtArmaway:sender];
    [self setState:sender];
    _jdState = ARMAWAY;
}

- (IBAction)setStateArmStay:(id)sender {
    [self.delegate StateTableViewCell:self clickclickDeviceState:self.currentDevice AtArmstay:sender];
    [self setState:sender];
    _jdState = ARMSTAY;
}

- (IBAction)intoSetPage:(id)sender {
    if(self.call){
    
        self.call();
    }
}



- (IBAction)setStateDisArm:(id)sender {
    [self.delegate StateTableViewCell:self clickDeviceState:self.currentDevice AtDisarm:sender];
    [self setState:sender];
    _jdState = DIDARM;
}

- (void)setState:(UIButton *)button{
    _oldButton.layer.borderColor = [UIColor grayColor].CGColor;
    [_oldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    button.layer.borderColor = APPMAINCOLOR.CGColor;
    [button setTitleColor:APPMAINCOLOR forState:UIControlStateNormal];
    _oldButton = button;
    if(self.setState){
        self.setState(_jdState);
    }
}

@end
