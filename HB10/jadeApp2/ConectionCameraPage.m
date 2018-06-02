//
//  ConectionCameraPage.m
//  JADE
//
//  Created by JD on 2017/5/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ConectionCameraPage.h"
#import "ConectionWifiPage.h"
#import "JDAppGlobelTool.h"
#import "LANCameraList.h"
#import "DeviceInfoModel.h"

@interface ConectionCameraPage ()

@property (weak, nonatomic) IBOutlet UILabel *tipTitle;
@property (weak, nonatomic) IBOutlet UIButton *conectionCamera;
@property (weak, nonatomic) IBOutlet UIButton *searchLan;
@property (weak, nonatomic) IBOutlet UILabel *conectionTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;

@end

@implementation ConectionCameraPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
    self.title = Local(@"Access the camera");
    self.tipTitle.text = Local(@"Please choose a suitable connection");
    self.tipTitle.textColor =  APPGRAYBLACKCOLOR;
    self.tipTitle.font = [UIFont systemFontOfSize:17];
    self.conectionTitle.textColor = APPGRAYBLACKCOLOR;
    self.searchTitle.textColor = APPGRAYBLACKCOLOR;
    self.conectionTitle.text = Local(@"Smart connection");
    self.searchTitle.text = Local(@"Add a LAN camera");

}

- (IBAction)wifiConnection:(id)sender {
    DLog(@"进入Wi-Fi链接设备的界面");
    ConectionWifiPage *page = [[ConectionWifiPage alloc]init];
    page.dModel = self.deviceModel;
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)lanSearch:(id)sender {
    DLog(@"进入局域网扫描界面");
    LANCameraList *page = [[LANCameraList alloc]init];
    page.dModel = self.deviceModel;
    [self.navigationController pushViewController:page animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLog(@"内存溢出了");
}


@end
