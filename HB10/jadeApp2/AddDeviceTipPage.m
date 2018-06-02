//
//  AddDeviceTipPage.m
//  jadeApp2
//
//  Created by JD on 2017/3/6.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AddDeviceTipPage.h"
#import "LinkHostWifiPage.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"

@interface AddDeviceTipPage ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextbutton;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIView *bgLabel;

@end

@implementation AddDeviceTipPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    
    self.title = Local(@"Add device");
    
    self.tipLabel.text = Local(@"Press and hold the device reset button until the device prompt is flashing, and then click Next to start connecting to Wi-Fi.");
    self.tipLabel.textColor = APPGRAYBLACKCOLOR;
    [self.nextbutton setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.nextbutton setBackgroundImage:[UIImage createImageWithColor:APPBLUECOlOR ] forState:UIControlStateNormal];
    self.nextbutton.layer.cornerRadius = PublicCornerRadius;
    self.nextbutton.layer.masksToBounds = YES;
    [self.nextbutton setTitle:Local(@"Next") forState:UIControlStateNormal];
    self.nextbutton.enabled = NO;
    [self.nextbutton addTarget:self action:@selector(intoAlarming) forControlEvents:UIControlEventTouchUpInside];
    
    [self.OKButton setBackgroundImage:[[UIImage imageNamed:@"selector"] imageWithColor:APPMAINCOLOR] forState:UIControlStateSelected];
    [self.OKButton setBackgroundImage:[[UIImage imageNamed:@"selector"] imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.OKButton setLayerWidth:2.0 color:[UIColor grayColor] cornerRadius:self.OKButton.width/2.0 BGColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OKAction)];
    [self.bgLabel addGestureRecognizer:tap];
//    [self.OKButton addTarget:self action:@selector(OKAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tips.textColor = [UIColor grayColor];
    self.tips.text = Local(@"The above steps have been completed");

    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    UIImage *image1 = [UIImage imageNamed:@"1show"];
    UIImage *image2 = [UIImage imageNamed:@"2show"];
    UIImage *image3 = [UIImage imageNamed:@"3show"];
    UIImage *image4 = [UIImage imageNamed:@"4show"];

    
    if(self.deviceType == GateawayTypeDerector){
        image1 = [UIImage imageNamed:@"1show"];
        image2 = [UIImage imageNamed:@"2show"];
        image3 = [UIImage imageNamed:@"3show"];
        image4 = [UIImage imageNamed:@"4show"];
//        [self.nextbutton addTarget:self action:@selector(intoAlarming) forControlEvents:UIControlEventTouchUpInside];

    }

    
    [imageArr addObject:image1];
    [imageArr addObject:image2];
    [imageArr addObject:image2];
    [imageArr addObject:image2];
    [imageArr addObject:image3];
    [imageArr addObject:image4];
    [imageArr addObject:image3];
    [imageArr addObject:image4];
    self.showImage.animationImages = imageArr;
    self.showImage.animationRepeatCount = MAXFLOAT;
    self.showImage.image = (UIImage *)imageArr.firstObject;
    self.showImage.animationDuration = imageArr.count * 0.5;
    [self.showImage startAnimating];
    
}

- (void)OKAction{

    self.OKButton.selected = !self.OKButton.selected;
    if(self.OKButton.selected){
        [self.OKButton setLayerWidth:0.0 color:[UIColor clearColor] cornerRadius:self.OKButton.width/2.0 BGColor:nil];
    }else{
        [self.OKButton setLayerWidth:2.0 color:[UIColor grayColor] cornerRadius:self.OKButton.width/2.0 BGColor:[UIColor clearColor]];
    }
    self.nextbutton.enabled = !self.nextbutton.enabled;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.showImage startAnimating];
}

- (void)intoAlarming{
    LinkHostWifiPage *page = [[LinkHostWifiPage alloc]init];
    page.deviceType = self.deviceType;
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
