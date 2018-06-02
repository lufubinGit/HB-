//
//  SoftAPLinkPage.m
//  jadeApp2
//
//  Created by JD on 2016/10/26.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SoftAPLinkPage.h"
#import "GizSupport.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import "FBSoftAPAnimation.h"
#import "DeviceInfoModel.h"
#import "UnbindfViewController.h"
#import "UIImage+BlendingColor.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"

#define  ViewTitle @"SoftAP"

@interface SoftAPLinkPage ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *demonstrateImage;
@property (weak, nonatomic) IBOutlet UILabel *berif;
@property (weak, nonatomic) IBOutlet UILabel *connectionTip;

@end

@implementation SoftAPLinkPage
{
    NSString *_WifiName;
    NSString *_WifiPsw;
    FBSoftAPAnimation *_softAnimation;

}
- (SoftAPLinkPage *)initWithWifiName:(NSString *)wifiName WifiPassword:(NSString *)PSW{

    self = [super init];
    if(self){
    
        self = [[SoftAPLinkPage alloc]init];
        _WifiPsw = PSW;
        _WifiName = wifiName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    self.title = Local(ViewTitle);
    [self.nextButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPBLUECOlOR];
    [self.nextButton setTitle:Local(@"Next") forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(startLink) forControlEvents:UIControlEventTouchUpInside];
    _softAnimation = [[FBSoftAPAnimation alloc]initWithFrame:CGRectMake(WIDTH/2.0-(WIDTH*0.66 -20)/2.0-5, WIDTH/2.0-100, WIDTH*0.66 -20, 200)];
    _softAnimation.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_softAnimation];
    self.berif.text = Local(@"Ensure that the currently connected WI-FI hotspot is device-owned (contains the XPG-GAent field). Click on the bottom of the \"next\", the direct connection.");
    self.connectionTip.text = Local(@"Loading");
    self.connectionTip.hidden = YES;
    
    //对于4S设备  会隐藏这个提示文字
    if(HIGHT == 480){
        _berif.hidden = YES;
    }
    
    //左边的按钮
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.frame = CGRectMake(5, 20, 80, 44);
    leftNavButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 56);
    leftNavButton.titleEdgeInsets = UIEdgeInsetsMake(10, -15, 10, 0);
    leftNavButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftNavButton setImage:[UIImage imageNamed:@"Commend_back"] forState:UIControlStateNormal];
    [leftNavButton setImage:[[UIImage imageNamed:@"Commend_back"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
    [leftNavButton setTitle:Local(@"Device") forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
}

- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startLink{
 
    //先要确保手机已经连上了设备的热点
    if(![[JDAppGlobelTool shareinstance].currentWifiName containsString:JDGizDeviceSoftAPWiFi]){
#ifdef __IPHONE_10_0
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:Local(@"Please connect your phone with\" Settings \" - \"Wireless LAN \" to connect to the device hotspot. The device hotspot contains \" %@ \"field."),JDGizDeviceSoftAPWiFi] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            return ;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
#endif
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Please connect the device WiFi first. Will you connect now?") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Local(@"Go") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            return ;
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
#endif
    }
    else{

        if([[UIDevice currentDevice].systemVersion integerValue] >= 10){
            [NSTimer scheduledTimerWithTimeInterval:2.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [_softAnimation drawWithProcess];
            }];
        }else{
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Animation_9:) userInfo:nil repeats:YES];
        }
        [SVProgressHUD showInfoWithStatus:Local(@"SoftAP direct connection ...")];
        self.connectionTip.hidden = NO;
        [[GizSupport sharedGziSupprot] gizSetDeviceWifiSoftAPAtViewControll:self WiFiName:_WifiName WiFiPassword:_WifiPsw wifiGAgentType:GizGAgentRTK Succeed:^{
             NSMutableArray *allDevice = [[NSMutableArray alloc]init];
            for (DeviceInfoModel *device in [GizSupport sharedGziSupprot].deviceList) {
                
                NSLog(@" %@ --- %d --- %d",device.gizDeviceName ,device.gizDevice.isSubscribed,device.gizDevice.isBind);
                //在线没有绑定的设备
                if(!device.gizDevice.isBind && device.gizDevice.netStatus == GizDeviceOnline ){
                    [allDevice addObject:device];
                }
            }
            if(allDevice.count){
                UnbindfViewController *unbindpage = [[UnbindfViewController alloc]init];
                [self.navigationController pushViewController:unbindpage animated:YES];
            }else{
                [self back];
            }
            
            
            [SVProgressHUD showSuccessWithStatus:Local(@"Discovery equipment")];
            NSLog(@"%@",[GizSupport sharedGziSupprot].deviceList);

            self.connectionTip.hidden = YES;

        } failed:^(NSString *err){
            [SVProgressHUD showErrorWithStatus:Local(@"Failed")];
            self.connectionTip.hidden = YES;
           
        }];
    }
}

- (void)Animation_9:(NSTimer *)timer{
     [_softAnimation drawWithProcess];
}



@end
