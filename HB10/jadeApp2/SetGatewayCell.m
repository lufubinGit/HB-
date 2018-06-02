//
//  SetGatewayCell.m
//  jadeApp2
//
//  Created by JD on 2016/11/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SetGatewayCell.h"
#import "EnumHeader.h"

@implementation SetGatewayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setType:(GateWayCellType)Type{
    self.switchItem.hidden = YES;
    self.wordlabel.hidden = YES;
    self.arrowItem.hidden = YES;
//    self.switchItem.tintColor = APPMAINCOLOR;
//    self.switchItem.onTintColor = APPMAINCOLOR;
//    self.switchItem.thumbTintColor = APPMAINCOLOR;
    if(Type == JumpType){
        self.arrowItem.hidden = NO;
    }else if(Type == WordType){
        self.wordlabel.hidden = NO;
        self.wordlabel.text = @" - - - ";
    }else if(Type == SwitchType){
        self.switchItem.hidden = NO;
        [self.switchItem addTarget:self action:@selector(switchItemChange:) forControlEvents:UIControlEventValueChanged];
    }else if(Type == JumpWordType){
        self.describle.hidden = NO;
        self.arrowItem.hidden = NO;
    }
}

- (void)switchItemChange:(UISwitch *)SW{
    if(self.cellB){
        self.cellB(SW.on);
    }
}




@end
