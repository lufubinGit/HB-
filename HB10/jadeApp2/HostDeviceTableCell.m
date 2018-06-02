//
//  HostDeviceCell.m
//  JADE
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "HostDeviceTableCell.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"


@interface HostDeviceTableCell ()
// 在线设备
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *deviceDes;
@property (strong, nonatomic) IBOutlet UIButton *disarm;
@property (strong, nonatomic) IBOutlet UIButton *armAway;
@property (strong, nonatomic) IBOutlet UIButton *armStay;
@property (strong, nonatomic) IBOutlet UIButton *history;
@property (strong, nonatomic) IBOutlet UIButton *setting;
@property (strong, nonatomic) IBOutlet UIImageView *alarmImage;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UIImageView *signalImage;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

// 离线设备
@property (weak, nonatomic) IBOutlet UIImageView *offLineIcon;
@property (weak, nonatomic) IBOutlet UILabel *offLineName;
@property (weak, nonatomic) IBOutlet UILabel *offLineDes;
@property (weak, nonatomic) IBOutlet UIImageView *offLinSig;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

@end

@implementation HostDeviceTableCell
{
    NSTimer *_timer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stateLabel setLayerWidth:1 color:APPMAINCOLOR cornerRadius:PublicCornerRadius BGColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setOnlineModel:(DeviceInfoModel *)devcieModel{
    // 名字 描述
    self.deviceName.text = devcieModel.gizDeviceName;
    NSString *string = Local(@"Number of managed devices:");
    self.deviceDes.text = [NSString stringWithFormat:@"%@%lu",string,devcieModel.subDevices.count];
    
    // 警号
    BOOL srnon = [devcieModel.gizDeviceData[@"srnOn"] boolValue];
    self.alarmImage.hidden = !srnon;
    
    if(_timer.valid){
        [_timer invalidate];
        _timer = nil;
    }
    
    if(!self.alarmImage.hidden){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(twinkle) userInfo:nil repeats:YES];
    }else{
        [_timer invalidate];
    }
    
    // 状态
    NSString *stateStr = nil;
    if(devcieModel.gizDeviceData[@"armState"]){
        switch ([devcieModel.gizDeviceData[@"armState"] integerValue]) {
            case 0:
                stateStr = Local(@"Disarm");
                break;
            case 1:
                stateStr = Local(@"ArmStay");
                break;
            case 2:
                stateStr = Local(@"Armaway");
                break;
            default:
                break;
        }
    }else{
        stateStr = Local(@"Loading");
    }
    if(stateStr){
        self.stateLabel.text = stateStr;
    }
    
    // 信号
    if (devcieModel.gizIsOnline == GizDeviceOffline){
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_0"]];
    }else{
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_%ld",(long)devcieModel.WIFISigna]];
    }
    
    // WIFI 强度
    self.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_GSMSigan_%ld",(long)devcieModel.SignalIntensity - 1 ]];
    self.cardImage.hidden = !devcieModel.numExist; //如果不带卡的酒会隐藏起来
}

- (void)twinkle{
    [UIView animateWithDuration:0.75 animations:^{
        if(self.alarmImage.alpha > 0 ){
            self.alarmImage.alpha = 0;
        }else{
            self.alarmImage.alpha = 1;
        }
    }];
}

- (void)setOffLineModel:(DeviceInfoModel *)devcieModel{
    // 名字 描述
    self.offLineName.text = devcieModel.gizDeviceName;
    NSString *string = Local(@"Number of managed devices:");
    self.offLineDes.text = [NSString stringWithFormat:@"%@%lu",string,devcieModel.subDevices.count];
    
    // 删除按钮
    self.deletBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deletBtn setTitle:Local(@"delete") forState:UIControlStateNormal];
    
    // 信号
    if (devcieModel.gizIsOnline == GizDeviceOffline){
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_0"]];
    }else{
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_%ld",(long)devcieModel.WIFISigna]];
    }
}

- (IBAction)deleteModel:(id)sender {
    if(self.deleteModel){
        self.deleteModel();
    }
}



@end

