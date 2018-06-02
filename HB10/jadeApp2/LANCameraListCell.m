//
//  LANCameraListCell.m
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "LANCameraListCell.h"
#import "DeviceInfoModel.h"
#import "CameraModel.h"
#import "JDAppGlobelTool.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"

@interface LANCameraListCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *cameraName;
@property (weak, nonatomic) IBOutlet UILabel *cameraID;
@property (weak, nonatomic) IBOutlet UIImageView *isNewDevice;

@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@end

@implementation LANCameraListCell

- (IBAction)bind:(id)sender {
    if(self.bind !=nil){
        self.bind();
    }
}

- (void)setCellModel:(CameraModel *)model dModel:(DeviceInfoModel*)dModel{
    self.cameraName.text = model.cameraName;
    self.cameraID.text = [NSString stringWithFormat:@"ID:%@",model.cameraID];
    self.isNewDevice.hidden = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(dModel.gizDevice.did)];  //如果没有被绑定主设备，则标示新设备
    self.icon.image = RepalceImage(@"Devcie_Camer_onlin");
     NSString *buttonStr = @"";
    if([dModel isCameraExistWithId:model.cameraID]){
        buttonStr = Local(@"Binded");
        self.bindButton.enabled = NO;
        self.bindButton.backgroundColor = [UIColor grayColor];
    }else{
        buttonStr = Local(@"Binding");
        self.bindButton.enabled = YES;
        self.bindButton.backgroundColor = APPBLUECOlOR;
    }
    [self.bindButton setTitle:buttonStr forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bindButton.layer.cornerRadius = PublicCornerRadius;
    self.bindButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
