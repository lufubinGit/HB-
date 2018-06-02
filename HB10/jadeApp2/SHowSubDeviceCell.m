//
//  SHowSubDeviceCell.m
//  jadeApp2
//
//  Created by JD on 2016/11/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SHowSubDeviceCell.h"
#import "UIImage+BlendingColor.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"
@implementation SHowSubDeviceCell
{
    NSTimer *_timer;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubDevice:(JDGizSubDevice *)subDevice{
    
    _subDevice = subDevice;
    self.backgroundColor = APPBACKGROUNDCOLOR;
    self.stateLabel.textColor = [UIColor whiteColor];
    [self.BGimageView setLayerWidth:0 color:nil cornerRadius:0 BGColor:[UIColor whiteColor]];
    self.BGimageView.alpha = 1;
    self.BGimageView.layer.shadowColor = [UIColor redColor].CGColor;
    self.BGimageView.layer.shadowOffset = CGSizeMake(1, 1);
    if(!subDevice.cameraID){
        
        if(subDevice.isOnline){
            [self.stateLabel setLayerWidth:1 color:APPSAFEGREENCOLOR cornerRadius:self.height/8.0 BGColor:APPSAFEGREENCOLOR];
            self.stateLabel.text = Local(@"Online");
        }else{
            [self.stateLabel setLayerWidth:1 color:APPMAINCOLOR cornerRadius:self.height/8.0 BGColor:APPMAINCOLOR];
            self.stateLabel.text = Local(@"Offline");
        }
        self.thumName.text = subDevice.subDeviceName;
        self.subDeviceName.text = subDevice.subDeviceName;
        self.iconImage.image = subDevice.subDeviceIcon;
        self.subDeviceLocal.text = subDevice.subDeviceTypeName;
        
        if(self.subDevice.isARMing){
            
            self.BGimageView.backgroundColor = APPMAINCOLOR;
            self.BGimageView.alpha = 0.4;
            
            if(_timer.valid){
                [_timer invalidate];
                _timer = nil;
            }
            if(!self.armImage.hidden){
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(twinkle) userInfo:nil repeats:YES];
            }
        }
    }else{ //摄像头
        self.stateLabel.hidden = YES;
        self.thumName.text = subDevice.subDeviceTypeName;
        self.subDeviceName.text = subDevice.subDeviceName;
        self.iconImage.image = subDevice.subDeviceIcon;
        self.subDeviceLocal.text = subDevice.subDeviceTypeName;
    }

}
- (void)twinkle{
    if(self.BGimageView.alpha){
    [UIView animateWithDuration:0.75 animations:^{
        self.BGimageView.alpha = 0;
    }];
    }else{
        [UIView animateWithDuration:0.75 animations:^{
            self.BGimageView.alpha = 0.4;
        }];
    }
}

- (void)dealloc{

    [_timer invalidate];
    _timer = nil;
}

@end
