//
//  LinkHostWifiPage.m
//  jadeApp2
//
//  Created by JD on 16/10/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "LinkHostWifiPage.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import "SoftAPLinkPage.h"
#import "FBScanAnimationPage.h"
#import "UIImage+BlendingColor.h"
#import "UnbindfViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"
#import <SVProgressHUD.h>

@interface LinkHostWifiPage ()
@property (weak, nonatomic) IBOutlet UIButton *startAdd;
@property (weak, nonatomic) IBOutlet UITextField *WifiPassTextfiled;
@property (weak, nonatomic) IBOutlet UILabel *WifiName;
@property (weak, nonatomic) IBOutlet UIImageView *WIFIImage;
@property (weak, nonatomic) IBOutlet UILabel *topTip;
@property (weak, nonatomic) IBOutlet UILabel *berif;

@end

@implementation LinkHostWifiPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dismissKeyBEnable = YES;
    [self initUI];
}

- (void)intoLineDevide{

    UnbindfViewController *unbindpage = [[UnbindfViewController alloc]init];
    unbindpage.deviceType = self.deviceType;
    [self.navigationController pushViewController:unbindpage animated:YES];
    return;
}

- (void)initUI{
    self.title = Local(@"Add device");
    //更改XIB部分
    [self.startAdd setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPBLUECOlOR];
    [self.startAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startAdd setTitle:Local(@"GO") forState:UIControlStateNormal];
    self.startAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.startAdd addTarget:self action:@selector(airLinkAddStart) forControlEvents:UIControlEventTouchUpInside];
    self.WifiName.text = APP_WIFIName;
    self.WIFIImage.image = [[UIImage imageNamed:@"Adddevice_WIFI"] imageWithColor:APPBLUECOlOR];
    self.topTip.text = Local(@"Gateway network configuration：");
    self.WifiPassTextfiled.placeholder = Local(@"Please enter Wi-Fi password");
    self.berif.text = Local(@"Make sure that the gateway / host is restored to factory settings (green light is flashing). If the gateway / host is connected to the network, make sure the phone and gateway are in the same WIfi. If the gateway / host is not connected to the network and has not been reset to factory settings, see how the instructions work.");
}


#pragma  mark  events
//airLink模式进入
- (void)airLinkAddStart{
    
    if(!self.WifiPassTextfiled.text.length){
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter Wi-Fi password")];
        return;
    }
    
    if([APP_WIFIName isEqualToString:Local(@"WI-FI is not connected")]){
      
        [SVProgressHUD showInfoWithStatus:Local(@"WI-FI is not connected")];
        return;
    }
    
    FBScanAnimationPage *FBAnimation = [[FBScanAnimationPage alloc]init];
    FBAnimation.wifiName = APP_WIFIName;
    FBAnimation.wifiPassword = self.WifiPassTextfiled.text;
    [self.navigationController pushViewController:FBAnimation animated:YES];
    
}


















































































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
