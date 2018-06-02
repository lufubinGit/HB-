//
//  SetGatewayArmStateCell.m
//  jadeApp2
//
//  Created by JD on 2016/11/21.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SetGatewayArmStateCell.h"
#import "JDAppGlobelTool.h"

@implementation SetGatewayArmStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.segmentItem setTitle:Local(@"ArmStay") forSegmentAtIndex:1];
    [self.segmentItem setTitle:Local(@"Disarm") forSegmentAtIndex:0];
    [self.segmentItem setTitle:Local(@"Armaway") forSegmentAtIndex:2];
    [self.segmentItem setTintColor:APPMAINCOLOR];
}

- (void)setType:(GateWayCellType)Type{

    if(Type == SegmentType){
    
        [self.segmentItem addTarget:self action:@selector(chooseArm:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)chooseArm:(UISegmentedControl *)seg{
    if(self.cellB){
        self.cellB(seg.selectedSegmentIndex);
    }
}
@end
