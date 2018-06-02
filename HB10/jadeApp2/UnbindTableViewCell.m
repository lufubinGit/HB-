//
//  UnbindTableViewCell.m
//  jadeApp2
//
//  Created by JD on 2016/11/17.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UnbindTableViewCell.h"
#import "DeviceInfoModel.h"
#import "GizSupport.h"
#import "UIView+Frame.h"
#import "JDAppGlobelTool.h"

@implementation UnbindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.subButton setTitle:Local(@"Binding") forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DeviceInfoModel *)model{
    _model = model;
    [self.subButton setLayerWidth:0 color:nil cornerRadius:self.height/8.0 BGColor:APPMAINCOLOR];
    self.deviceName.text = model.gizDeviceName;
    self.deviceImage.image = RepalceImage(@"Device_getaway_online");
    
    if([model.gizDevice.productKey isEqualToString:XPGAppDetectorProductKey]){ //探测器
        self.deviceImage.image = RepalceImage(@"Device_getaway_offline");
    }
    
    self.mac.text = model.gizDevice.macAddress;

}
- (IBAction)subModel:(id)sender {
    if(self.callback){
        self.callback();
    }
}

@end
