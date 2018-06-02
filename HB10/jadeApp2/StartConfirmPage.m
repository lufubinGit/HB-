//
//  StartConfirmPage.m
//  JADE
//
//  Created by JD on 2017/5/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "StartConfirmPage.h"
#import "SearchCameraPage.h"
#import "UIView+Frame.h"
#import "JDAppGlobelTool.h"
@interface StartConfirmPage ()
@property (weak, nonatomic) IBOutlet UILabel *bigtip;
@property (weak, nonatomic) IBOutlet UILabel *secondTip;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UITextField *firstText;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UITextField *secondText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation StartConfirmPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

/**
 initui   初始化UI
 @return nil
 */
- (void)initUI{
    self.dismissKeyBEnable = YES;
    [self.nextButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPSAFEGREENCOLOR];
    self.firstText.text = [JDAppGlobelTool.shareinstance currentWifiName];
    self.nextButton.layer.cornerRadius = PublicCornerRadius;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = APPBLUECOlOR;
    [self.nextButton setTitle:Local(@"next step") forState:UIControlStateNormal];
    self.secondText.placeholder = Local(@"Please enter Wi-Fi password");
    self.bigtip.text = Local(@"The device requires an online Wi-Fi");
    self.bigtip.textColor = APPGRAYBLACKCOLOR;
    self.secondTip.textColor = [UIColor grayColor];
    self.secondTip.text = Local(@"The device does not support 5G networks");
    self.title = Local(@"Start the connection");
}


/**
  点击下一步的按钮 执行帮助摄像头联网的操作
  @param sender 按钮
 */
- (IBAction)next:(id)sender {
    if(self.firstText.text.length<1){
        [SVProgressHUD showInfoWithStatus: Local(@"The device requires an online Wi-Fi")];
        return;
    }
    
    if(self.secondText.text.length<1){
        [SVProgressHUD showInfoWithStatus: Local(@"Please enter Wi-Fi password")];
        return;
    }
    
    
    SearchCameraPage *page = [[SearchCameraPage alloc]init];
    page.dModel = self.dModel;
    page.SSID = self.firstText.text;
    page.psw = self.secondText.text;
    [self.navigationController pushViewController:page animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
