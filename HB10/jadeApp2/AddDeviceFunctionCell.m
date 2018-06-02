//
//  AddDeviceFunctionCell.m
//  jadeApp2
//
//  Created by JD on 16/9/22.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AddDeviceFunctionCell.h"
#import "UIView+Frame.h"
#import "JDAppGlobelTool.h"


@implementation AddDeviceFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = APPBACKGROUNDCOLOR;
    [self.BGimage setLayerWidth:0 color:nil cornerRadius:0 BGColor:[UIColor whiteColor]];
    self.Addlabel.text = Local(@"Add more subdevice");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
