//
//  SubDeviceTableViewCell.m
//  jadeApp2
//
//  Created by JD on 2016/12/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SubDeviceTableViewCell.h"
#import "JDAppGlobelTool.h"

@implementation SubDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
- (void)setIsArm:(BOOL)isArm{
    _isArm = isArm;
    if(isArm){
        self.state.textColor = APPMAINCOLOR;
    }else{
        self.state.textColor = APPBLUECOlOR;
    }
}


@end
