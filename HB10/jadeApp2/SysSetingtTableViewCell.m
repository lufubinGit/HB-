//
//  SysSetingtTableViewCell.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//
#import "SysSetingtTableViewCell.h"
#import "JDAppGlobelTool.h"

#define OpenNoti Local(@"Receive notifications switch")
#define ClearChace Local(@"Clear cache")
#define ShareApp Local(@"Share app")
#define EvaluationAPP Local(@"Evaluation APP")
#define FeedBack Local(@"FeedBack")
#define PageTitle Local(@"setting")
#define ServerSetting  Local(@"Regional server settings")


@implementation SysSetingtTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(NSString*)str{
    self.itemSwitch.hidden = ![str isEqualToString:OpenNoti];
    if([str isEqualToString:FeedBack] ||[str isEqualToString:ServerSetting]){
        self.arrow.hidden = NO;
    }else{
        self.arrow.hidden = YES;
    }
    self.itemName.text =  str;
    if([str isEqualToString:OpenNoti]){
        // - 获取当前的远程通知设置
        dispatch_async(dispatch_get_main_queue(), ^{
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            // - 判断通知设置类型
            if(setting.types == UIUserNotificationTypeNone){
                self.itemSwitch.on = NO;
            }else{
                self.itemSwitch.on = YES;
            }
        });
    }
  
}

- (IBAction)setSwitch:(id)sender {
    UISwitch *switchView = sender;
    if(self.call){
        self.call(switchView.isOn);
    }   
}

@end
