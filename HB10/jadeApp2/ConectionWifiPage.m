//
//  ConectionWifiPage.m
//  JADE
//
//  Created by JD on 2017/5/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ConectionWifiPage.h"
#import "StartConfirmPage.h"
#import "JDAppGlobelTool.h"

@interface ConectionWifiPage ()
@property (weak, nonatomic) IBOutlet UILabel *tipOne;
@property (weak, nonatomic) IBOutlet UIImageView *showImageOne;
@property (weak, nonatomic) IBOutlet UILabel *tipTwo;
@property (weak, nonatomic) IBOutlet UIImageView *showImageTwo;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation ConectionWifiPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
    
    self.showImageOne.animationDuration = 0.4;
    self.showImageOne.animationImages = @[[UIImage imageNamed:@"JADE_camera01"],[UIImage imageNamed:@"JADE_camera02"],[UIImage imageNamed:@"JADE_camera03"]];
    [self.showImageOne startAnimating];
    self.showImageTwo.image = [UIImage imageNamed:@"JADE_camera04"];
    self.nextButton.layer.cornerRadius = PublicCornerRadius;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = APPBLUECOlOR;
    self.tipOne.text = Local(@"1.Turn on the power and the device enters the waiting state. \nA connection prompt sounds are also issued.");
    self.tipOne.font = [UIFont systemFontOfSize:16];
    self.tipOne.textColor = APPGRAYBLACKCOLOR;
    self.tipTwo.text = Local(@"2. Keep the phone and equipment at 30cm away");
    self.tipTwo.font = [UIFont systemFontOfSize:16];
    self.tipTwo.textColor = APPGRAYBLACKCOLOR;
    
    [self.nextButton setTitle:Local(@"next step") forState:UIControlStateNormal];
    
    self.title = Local(@"tip");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    
    StartConfirmPage *page = [[StartConfirmPage alloc]init];
    page.dModel = self.dModel;
    [self.navigationController pushViewController:page animated:YES];
}


@end
