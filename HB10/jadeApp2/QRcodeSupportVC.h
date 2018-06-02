//
//  QRcodeSupportVC.h
//  jadeApp2
//
//  Created by JD on 16/9/22.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^callback)(AVMetadataMachineReadableCodeObject *);

@interface QRcodeSupportVC : UIViewController
 <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,copy) callback call;
@property (nonatomic,strong)AVCaptureSession *session ;

- (instancetype)initWithBlock:(void(^)(AVMetadataMachineReadableCodeObject *))block;

//生成二维码
- (UIImage *)productQRCodeWithContent:(NSString *)content waterImage:(UIImage *)image;

//扫描二维码
- (void)startQRCode;
@end

