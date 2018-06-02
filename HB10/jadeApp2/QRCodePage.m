//
//  QRCodePage.m
//  JADE
//
//  Created by JD on 2017/10/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "QRCodePage.h"
#import "QRcodeSupportVC.h"
#import "JDAppGlobelTool.h"
#import "GizSupport.h"

@interface QRCodePage ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *describel;

@end

@implementation QRCodePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.describel.backgroundColor = [UIColor clearColor];
    self.describel.textColor = APPBLUECOlOR;
    self.describel.text = Local(@"Use another user to scan the QR code to gain permission on the device");
    self.describel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    self.title = Local(@"share device");
    
    QRcodeSupportVC *suppet = [[QRcodeSupportVC alloc] init];
    
    NSString *content = [NSString stringWithFormat:@"%@|%@|%@",self.device.gizDevice.macAddress,self.device.gizDevice.productKey,GizSupport.sharedGziSupprot.productInfo[self.device.gizDevice.productKey]];
    DLog(@"%@",content);
    self.codeImage.image = [suppet productQRCodeWithContent:content waterImage:[UIImage imageNamed:@"JADE_Device_getaway_online"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
