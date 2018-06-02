//
//  QRcodeSupportVC.m
//  jadeApp2
//
//  Created by JD on 16/9/22.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "QRcodeSupportVC.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"
#import <Photos/Photos.h>
@interface QRcodeSupportVC ()

@end

@implementation QRcodeSupportVC
{

    NSTimer  *_timer;
}
- (instancetype)initWithBlock:(void(^)(AVMetadataMachineReadableCodeObject *))block
{
    self = [super init];
    if (self) {
        self.call = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Local(@"QR code");
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    [self startQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//生成二维码
- (UIImage *)productQRCodeWithContent:(NSString *)content waterImage:(UIImage *)image{
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.返回二维码
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:1000 waterimage:image];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size waterimage:(UIImage *)waterImage
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size/10.0, size/10), bitmapImage);

    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);

    return [UIImage imageWithCGImage:scaledImage];
}


/**
   如果没有开启摄像头的权限的时候 会进行一个提示
 */
- (void)noCammerAction{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Local(@"No camera permissions") message:Local(@"Please turn on the camera permissions for 'Iot-Alarm'APP' in the phone's settings.") preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertVC dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popoverPresentationController];  //没有权限的话 就会返回了
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//扫描二维码
- (void)startQRCode{
    AVAuthorizationStatus anthor = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (anthor == AVAuthorizationStatusRestricted || anthor == AVAuthorizationStatusDenied){
        [self noCammerAction];
        return;
    }

    
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    // 2.添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(!device) {return;}
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    // 3.添加输出数据(示例对象-->类对象-->元类对象-->根元类对象)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    // 3.1.设置输入元数据的类型(类型是二维码数据)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeDataMatrixCode]];
    // 3.2 设置 sessionPreset 属性
    [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];

    // 5.添加遮掩涂层
    CGRect conteneRect = CGRectMake(WIDTH/8.0, HIGHT/2.0 - 64 - WIDTH*0.375 , WIDTH*0.75, WIDTH*0.75);
    UIView *Bgview = [[UIView alloc]initWithFrame:self.view.bounds];
    Bgview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    //创建一个全屏大的path111
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    //创建一个方形的 path
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:conteneRect];
    [path appendPath:rectPath];
    CAShapeLayer *SPlayer = [CAShapeLayer layer];
    
    SPlayer.path = path.CGPath;
    SPlayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则 这里采用的是奇偶规则
    SPlayer.fillColor = [UIColor grayColor].CGColor;
    SPlayer.opacity = 0.8;
    Bgview.layer.mask = SPlayer;
    Bgview.layer.masksToBounds = NO;
    [self.view addSubview:Bgview];
    
    //6.添加方框图片和扫描横条
    UIImageView *rectImageV = [[UIImageView alloc]initWithFrame:conteneRect];
    rectImageV.image = [[UIImage imageNamed:@"QRCodeFrame"] imageWithColor:APPMAINCOLOR];
    [self.view addSubview:rectImageV];
    //7.添加扫描动画
    UIImageView *lineimageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/8.0, HIGHT/2.0 - 64 - WIDTH*0.375, WIDTH*0.75, WIDTH*0.75 * 3/230.0)];
    lineimageV.image = [UIImage imageNamed:@"QRCodeLine"];
    [self scanAnimation:lineimageV];
    
    if([[UIDevice currentDevice].systemVersion integerValue] >= 10){
        [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _timer = timer;
            [self scanAnimation:lineimageV];
        }];
    }else{
        
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Animation_9:) userInfo:lineimageV repeats:YES];
    }
    [self.view addSubview:lineimageV];
    //8.添加描述文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, rectImageV.y + rectImageV.height + 10, WIDTH*0.75 , 0)];
    label.text = Local(@"The two-dimensional code into the scan box.");
    [label sizeToFit];
    label.centerX = self.view.centerX;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    // 9.开始扫描
    [session startRunning];
}

//10.0以下的系统 的动画效果
- (void)Animation_9:(NSTimer *)timer{
    _timer = timer;
    UIImageView *linView = timer.userInfo;
    [self scanAnimation:linView];

}

- (void)scanAnimation:(UIImageView*) lineimageV{
    [UIView animateWithDuration:2.5 animations:^{
        lineimageV.y = HIGHT/2.0 - 64 - WIDTH*0.375 +  (WIDTH*0.75 - WIDTH*0.75 * 3/230.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.5 animations:^{
            lineimageV.y = HIGHT/2.0 - 64 - WIDTH*0.375;
        }];
    }];
}

// 当扫描到数据时就会执行该方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        //获得扫描数据，最后一个时最新扫描的数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"%@", object.stringValue.description);
        
        if(self.call){
            self.call(object);
        }
        // 停止扫描
        if ([self.session isRunning]){
            [self.session stopRunning];
        }
        [self.navigationController popViewControllerAnimated:YES];
        // 将预览图层移除
//        [self.view.layer removeFromSuperlayer];
        
    } else {
        NSLog(@"没有扫描到数据");
    }
}
- (void)dealloc{

    [_timer invalidate];
    _timer = nil;
    
}

@end
