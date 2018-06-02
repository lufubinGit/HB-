
//
//  EquipmentSectionView.m
//  jadeApp2
//
//  Created by JD on 2016/11/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "EquipmentSectionView.h"
#import "UIImage+BlendingColor.h"
#import "DeviceInfoModel.h"
#import "Masonry.h"
#import "EquipmentPage.h"
#import "JDAppGlobelTool.h"
#import "DeviceRecordPage.h"
#define BottomeButtonhei 60
#define SectionViewHei 90

#define DisArm Local(@"disarm")
#define AwayArm Local(@"armaway")
#define StayArm Local(@"armstay")
#define Record Local(@"record")
#define Setting Local(@"setting")

#define DeleteTip Local(@"The device is offline. If you remove the device, you can not obtain real-time information about the device after the device goes online. Are you sure you want to delete the device ?")

@implementation EquipmentSectionView
{
    NSTimer *_timer;
    CGFloat _cellHei;
    UIView *_BGview;
}


- (instancetype)initWithFrame:(CGRect)frame device:(DeviceInfoModel *)device tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        _cellHei = frame.size.height;
        self.devcieModel = device;
        self.tableView = tableView;
        self.isShow = NO;  //一开始都不是展示的
        [self initUI];
    }
    return self;
}

//GWView.tag = section + 10000;
//GWView.devcieModel = sectionDevice;

- (void)initUI{

//    [self setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1]] forState:UIControlStateHighlighted];
    
    UIView *backGround = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, SectionViewHei)];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:backGround];
    //图片
    self.iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [self.iconImageV setLayerWidth:0 color:nil cornerRadius:10 BGColor:nil];
    self.iconImageV.tag = 1001;
    self.iconImageV.centerY = backGround.centerY;
    [backGround addSubview:self.iconImageV];
    
    //名字和描述  单行文字  定高度为20
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageV.x + self.iconImageV.width+10, 0, WIDTH/2.0, 20)];
    self.nameLabel.text = @"1212";
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = APPGRAYBLACKCOLOR;
    self.nameLabel.centerY = backGround.centerY - 15;
    self.nameLabel.tag = 1002;
    [backGround addSubview:self.nameLabel];
    
    self.briefLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, 0, WIDTH/2.0, 20)];
    self.briefLabel.textColor = [UIColor grayColor];
        self.briefLabel.font = [UIFont systemFontOfSize:12];
    self.briefLabel.textAlignment = NSTextAlignmentLeft;
    self.briefLabel.centerY = backGround.centerY + 15;
    self.briefLabel.tag = 1003;
    [backGround addSubview:self.briefLabel];
    [self.iconImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGround.mas_left).offset(10);
        make.centerY.equalTo(backGround.mas_centerY);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));

    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageV.mas_right).offset(10);
        make.centerY.equalTo(backGround.mas_centerY).offset(-15);
        make.width.equalTo(@(WIDTH/2.0));
        make.height.equalTo(@(20));

    }];
    [self.briefLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageV.mas_right).offset(10);
        make.centerY.equalTo(backGround.mas_centerY).offset(15);
        make.width.equalTo(@(WIDTH/2.0));
        make.height.equalTo(@(20));
    }];
    
    //添加WIFI信号小图标
    CGFloat WH = 20;
    self.signalImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - WH - 10 , 5, WH, WH)];
    if (self.devcieModel.gizIsOnline == GizDeviceOffline){
            self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_0"]];
    }else{
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_%ld",(long)self.devcieModel.WIFISigna]];
    }
    self.signalImage.tag = 1004;
    [backGround addSubview:self.signalImage];

    //添加GSM信号小图标
    WH = 20;
    self.GSMSignalImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - WH - 10 , 5, WH, WH)];
    self.GSMSignalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_GSMSigan_%ld",(long)self.devcieModel.SignalIntensity - 1 ]];
    self.GSMSignalImage.tag = 1007;
    self.GSMSignalImage.hidden = !self.devcieModel.numExist; //如果不带卡的酒会隐藏起来
    [backGround addSubview:self.GSMSignalImage];
    [self.GSMSignalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.signalImage.mas_left).offset(-10);
        make.centerY.equalTo(self.signalImage.mas_centerY);
        make.width.equalTo(@(WH));
        make.height.equalTo(@(WH));
    }];
    
    // 设置和删除按钮
    if(_tableView.x == 0){
        //添加设置按钮
        self.setbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.setbutton.frame = CGRectMake(self.width - 50, 0, 50, self.height);
        self.setbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.setbutton setTitle:Local(@"setting") forState:UIControlStateNormal];
        //self.setbutton.backgroundColor = APPLINECOLOR;
        self.setbutton.backgroundColor = [UIColor whiteColor];

        [self.setbutton setTitleColor:APPMAINCOLOR forState:UIControlStateNormal];
        [self.setbutton setBackgroundImage:[UIImage createImageWithColor:APPMAINCOLOR] forState:UIControlStateHighlighted];
        [self.setbutton setTitleColor:[UIColor whiteColor ] forState:UIControlStateHighlighted];

        self.setbutton.alpha = 0;
        self.setbutton.tag = 1006;
        [backGround addSubview:self.setbutton];
        [self.setbutton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backGround.mas_right);
            make.top.equalTo(backGround.mas_top);
            make.width.equalTo(@50);
            make.height.equalTo(@(_cellHei));
        }];
        
        //添加状态小图标
        self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
        [self.stateLabel setLayerWidth:1 color:APPMAINCOLOR cornerRadius:PublicCornerRadius BGColor:nil];
        self.stateLabel.textColor = APPMAINCOLOR;
        self.stateLabel.tag = 1008;
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.font = [UIFont systemFontOfSize:12];
        [backGround addSubview:self.stateLabel];
        [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.signalImage.mas_right);
            make.top.equalTo(backGround.mas_bottom).with.offset(-35);
            make.width.equalTo(@85);
            make.height.equalTo(@25);
        }];
        
        //添加报警按钮
        self.armImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 20 - 2*WH , 5, WH, WH)];
        self.armImage.image = [UIImage imageNamed:@"srnon"];
//        self.armImage.hidden = YES;  //只有报警的时候这个图标才会亮出来
        
        self.armImage.tag = 1005;
        [backGround addSubview:self.armImage];
        [self.armImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.stateLabel.mas_left).with.offset(-5);
            make.centerY.equalTo(self.stateLabel.mas_centerY);
            make.width.equalTo(@(WH));
            make.height.equalTo(@(WH));
        }];
       
        self.iconImageV.image = RepalceImage(@"Device_getaway_online");
//      设置按钮左边的竖线
        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.setbutton.height)];
        leftLineView.backgroundColor = APPLINECOLOR;
        [self.setbutton addSubview:leftLineView];
        
        [leftLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.setbutton.mas_left);
            make.top.equalTo(self.setbutton.mas_top);
            make.width.equalTo(@1);
            make.height.equalTo(self.setbutton.mas_height);

        }];
        [self addEidtButtonAtScreenFooter];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, SectionViewHei + BottomeButtonhei, WIDTH, 20);
        bottomView.backgroundColor = APPBACKGROUNDCOLOR ;
        [self addSubview:bottomView];
        
    }else{  //对于离线设备
    
        //添加删除 按钮
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(self.width - 50, 0, 50, self.height);
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.deleteButton setTitle:Local(@"delete") forState:UIControlStateNormal];
//        self.deleteButton.backgroundColor = [UIColor purpleColor];
        self.deleteButton.backgroundColor = [UIColor whiteColor];

        [self.deleteButton setTitleColor:APPMAINCOLOR forState:UIControlStateNormal];
        self.deleteButton.tag = 1007;
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backGround.mas_right);
            make.top.equalTo(backGround.mas_top);
            make.width.equalTo(@50);
            make.height.equalTo(@(SectionViewHei));
        }];
        
        self.signalImage.x = WIDTH - 30 - 50;
        
        self.signalImage.image = [UIImage imageNamed:@"centerDevice_WIFIOff"];
        self.userInteractionEnabled = YES;
        self.iconImageV.image = RepalceImage(@"Device_getaway_offline");

        //设置按钮左边的竖线
        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.deleteButton.height)];
        leftLineView.backgroundColor = APPLINECOLOR;
        [self.deleteButton addSubview:leftLineView];
        
        [leftLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteButton.mas_left);
            make.top.equalTo(self.deleteButton.mas_top);
            make.width.equalTo(@1);
            make.height.equalTo(self.deleteButton.mas_height);
            
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, SectionViewHei, WIDTH, 20);
        bottomView.backgroundColor = APPBACKGROUNDCOLOR ;
        [self addSubview:bottomView];
        
    }
    

    
    
//    //上边线
//    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
//    topLine.backgroundColor = [UIColor grayColor];
//    [self addSubview:topLine];
//    
//    //下边线
//    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
//    bottomLine.backgroundColor = [UIColor grayColor];
//    [self addSubview:bottomLine];

}

//添加底部的按钮
- (void)addEidtButtonAtScreenFooter{
    if(_BGview){
        [_BGview removeFromSuperview];
    }
    _BGview = [[UIImageView alloc]initWithFrame:CGRectMake(0, SectionViewHei, WIDTH, BottomeButtonhei)];
    _BGview.backgroundColor  = [UIColor clearColor];
    _BGview.userInteractionEnabled = YES;
    
    //添加毛玻璃效果
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEff = [[UIVisualEffectView alloc]initWithEffect:eff];
    visualEff.frame = _BGview.bounds;
    [_BGview addSubview:visualEff];
    NSArray *buttonImageArr = @[Local(@"Device_getaway_disarm_EN_off"),Local(@"Device_getaway_armaway_EN_off"),Local(@"Device_getaway_armstay_EN_off"),Local(@"Device_getaway_record_EN_off"),Local(@"Device_getaway_setting_EN_off")];
    NSArray *arr = @[DisArm,AwayArm,StayArm,Record,Setting];
    float count = arr.count;
    for (int i = 0; i < count; i++) {
        UIImage *buttonImage = [UIImage imageNamed:buttonImageArr[i]];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/count *i, 0, WIDTH/count, _BGview.height)];
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(5, (WIDTH/count - _BGview.height +25)/2.0, 20, (WIDTH/count - _BGview.height +25)/2.0)];
        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(_BGview.height - 20, -WIDTH/count, 0, 0)];
        button.tag = i +1000;
        //        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:APPGRAYBLACKCOLOR forState:UIControlStateNormal];
        [button setImage:[buttonImage imageWithColor:APPGRAYBLACKCOLOR]  forState:UIControlStateNormal];
        [button setTitleColor:APPMAINCOLOR forState:UIControlStateHighlighted];
        [button setImage:[buttonImage imageWithColor:APPMAINCOLOR] forState:UIControlStateSelected];
        [button setTitleColor:APPMAINCOLOR forState:UIControlStateSelected];
        [button setImage:[buttonImage imageWithColor:APPMAINCOLOR] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(startControllAlram:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_BGview addSubview:button];
    }
    [self addSubview:_BGview];
}

//点击下方的4个按钮
- (void)startControllAlram:(UIButton *)button{
    
    button.selected = YES;
    [self performSelector:@selector(buttonReview:) withObject:button afterDelay:0.3];
    NSDictionary *order = [[NSDictionary alloc]init];
    switch (button.tag-1000) {
        case 0:
        {
            NSLog(@"撤防");
            order = @{@"armState" :@(0)};
        }
            break;
        case 1:
        {
            NSLog(@"外出");
            order = @{@"armState" :@(2)};
        }
            break;
        case 2:
        {
            NSLog(@"留守");
            order = @{@"armState" :@(1)};
        }
            break;
        case 3:
        {
            NSLog(@"记录");
            DeviceRecordPage *page = [[DeviceRecordPage alloc]init];
            page.currentDevice = self.devcieModel;
            [_lastPage.navigationController pushViewController:page animated:YES];
            order = nil;
        }
            break;
        case 4:
        {
            NSLog(@"设置");
            [_lastPage intoGetwaySettingPage:self.devcieModel];
            
            order = nil;
        }
            break;
        default:
            order = nil;
            break;
    }
    if(order){
        [SVProgressHUD showWithStatus:Local(@"setting armState...")];
        [[GizSupport sharedGziSupprot] gizSendOrderWithSN:11 device:self.devcieModel withOrder:order callBack:^(NSDictionary *datamap) {
            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
            
        }];
    }
}
- (void)buttonReview:(UIButton *)button{
    button.selected= NO;
}

- (void)deleteCenterDevice{

    [[GizSupport sharedGziSupprot] gizUnbindDeviceWithDeviceDid:_devcieModel Succeed:^{
        NSLog(@"OK  ");
        [self.tableView reloadData];
    }];
}

- (void)showSectionCell{
    
    for (UIView *subV in [self subviews]) {
        switch (subV.tag) {
            case 1004:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 30 - 50;
                }];
            }
                break;
           
            case 1005:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 105 - 50;
                }];
            }
                break;
            case 1007:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 60 - 50;
                }];
            }
                break;
            case 1008:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 75 - 50;
                }];
            }
                break;
            case 1006:
            {
                if(subV.alpha == 0){
                    [UIView animateWithDuration:0.5 animations:^{
                        subV.alpha = 1;
                    }];
                }
            }
                break;
            default:
                break;
        }
    }
    self.isShow = YES;

}

//隐藏cell的同时将 两个图标的位置复原
- (void)hidenSectionCell{
    
    for (UIView *subV in [self subviews]) {
        switch (subV.tag) {
            case 1004:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 30;
                }];
            }
                break;
            case 1005:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 105;
                }];
            }
                break;
            case 1007:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 60;
                }];
            }
                break;
            case 1008:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    subV.x = WIDTH - 75;
                }];
            }
                break;
            case 1006:
            {
                if(subV.alpha == 1){
                    [UIView animateWithDuration:0.5 animations:^{
                        subV.alpha = 0;
                    }];
                }
            }
                break;
            default:
                break;
        }
    }
    self.isShow = NO;
}

- (void)refrshDataWithModel:(DeviceInfoModel *)model{

    NSString *stateStr = nil;
//    NSLog(@"%@",self.devcieModel.gizDeviceData);
    [self.setbutton setTitle:Local(@"setting") forState:UIControlStateNormal];
    BOOL srnon = [model.gizDeviceData[@"srnOn"] boolValue];
    if(model.gizDeviceData[@"armState"]){
        switch ([model.gizDeviceData[@"armState"] integerValue]) {
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
//        self.stateLabel.x = 
        self.stateLabel.text = stateStr;
    }
    
    self.nameLabel.text = model.gizDeviceName;
    NSString *string = Local(@"Number of managed devices:");
    self.briefLabel.text = [NSString stringWithFormat:@"%@%lu",string,model.subDevices.count];
    self.armImage.hidden = !srnon;
    if(_timer.valid){
        [_timer invalidate];
        _timer = nil;
    }
    if(!self.armImage.hidden){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(twinkle) userInfo:nil repeats:YES];
        
    }
    self.GSMSignalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_GSMSigan_%ld",(long)self.devcieModel.SignalIntensity]];
    self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"JDDevice_WIFISIngn_%ld",(long)self.devcieModel.WIFISigna]];
    
}

- (void)twinkle{
    [UIView animateWithDuration:0.75 animations:^{
        if(self.armImage.alpha > 0 ){
            self.armImage.alpha = 0;
        }else{
            self.armImage.alpha = 1;
        }
    }];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
