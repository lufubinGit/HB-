//
//  FBScanAnimation.m
//  jadeApp2
//
//  Created by JD on 2016/10/27.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "FBScanAnimationPage.h"
#import "UIView+Frame.h"
#import "UIImage+BlendingColor.h"
#import "GizSupport.h"
#import "SoftAPLinkPage.h"
#import "UnbindfViewController.h"
#import "DeviceInfoModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"

#define ViewTitle Local(@"Search for devices")

@implementation FBScanAnimationPage
{
    UIView *_bgView;
    UIButton *_imageButton;
    BOOL _isrippleNow;
    UILabel *_countLabel;
    UIButton *_searchAgainButton;
    UIButton *_intoSoftAPButton;
    NSTimer *_timer;
    int _count;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)viewDidLoad{

    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    self.title = Local(ViewTitle);
    [self initUI];
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
//开启airLink连接设备
- (void)Airlink{

    [[GizSupport sharedGziSupprot] gizSetDeviceWifiAirLinkAtViewControll:self WiFiName:self.wifiName WiFiPassword:self.wifiPassword wifiGAgentType:GizGAgentRTK  Succeed:^{
        [SVProgressHUD showSuccessWithStatus:Local(@"Discovery equipment")];
        
        //找到 设备一秒之后 就会直接进入到局域网中
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UnbindfViewController *unbindpage = [[UnbindfViewController alloc]init];
            [self.navigationController pushViewController:unbindpage animated:YES];
        });
        
//        NSMutableArray *allDevice = [[NSMutableArray alloc]init];
//        for (DeviceInfoModel *device in [GizSupport sharedGziSupprot].deviceList) {
//            NSLog(@" %@ --- %d --- %d",device.gizDeviceName ,device.gizDevice.isSubscribed,device.gizDevice.isBind);
//            //在线没有绑定的设备
//            if(!device.gizDevice.isBind && device.gizDevice.netStatus == GizDeviceOnline ){
//                [allDevice addObject:device];
//            }
//        }
//        if(allDevice.count){
//            UnbindfViewController *unbindpage = [[UnbindfViewController alloc]init];
//            [self.navigationController pushViewController:unbindpage animated:YES];
//        }else{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }

        
    } failed:^(NSString *err){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Local(@"") message:Local(@"Connection failure, please use the phone to connect the device hot spots, enter the SoftAP Direct Connect ...") preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
        }] ];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        _searchAgainButton.enabled = YES;
        _intoSoftAPButton.enabled = YES;
        [_timer invalidate];
        _countLabel.text = Local(@"search again");
        _countLabel.font = [UIFont systemFontOfSize:15];
        _isrippleNow = NO;
    }];
}


- (void)initUI{

    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //添加按钮图片
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH/4.0, WIDTH/4.0)];
    [_imageButton setLayerWidth:3 color:[UIColor whiteColor] cornerRadius:_imageButton.width/2.0 BGColor:[UIColor clearColor]];
    _imageButton.center = _bgView.center;
    [_bgView addSubview:_imageButton];
    [self.view addSubview:_bgView];
    
    [_imageButton setBackgroundImage:[UIImage  imageNamed:@"AddDevice_Search"] forState:UIControlStateNormal] ;
    [_imageButton addTarget:self action:@selector(StartRipple) forControlEvents:UIControlEventTouchUpInside];
    
    //添加中心的倒计时
    _countLabel = [[UILabel alloc]initWithFrame:_imageButton.bounds];
    _countLabel.text = Local(@"Start");
    _countLabel.textColor = [UIColor grayColor];
    _countLabel.font = [UIFont systemFontOfSize:15];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.userInteractionEnabled = NO;
    [_imageButton addSubview:_countLabel];
    //首次进入直接开始搜索
    [self StartRipple];
    
    
    
    //添加下方提示文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, _bgView.y + _bgView.height, WIDTH-20, 100)];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.textColor = APPGRAYBLACKCOLOR;
    label.text = Local(@"Please wait while the peripheral equipment is being scanned. If the device is not found at the end of the countdown, you can choose to re-search or enter the SoftAP connection mode.");
    [self.view addSubview:label];
    
    //对于4S设备  会隐藏这个提示文字
    if(HIGHT == 480){
        label.hidden = YES;
    }
    
    //添加直连按钮和重新搜索按钮
    _searchAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/8.0, HIGHT - 80 - 64, WIDTH/4.0, 40)];
    [_searchAgainButton setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [_searchAgainButton setBackgroundImage:[UIImage createImageWithColor:APPBLUECOlOR] forState:UIControlStateNormal];
    _searchAgainButton.enabled = NO;
    _searchAgainButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_searchAgainButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:nil];
    [_searchAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchAgainButton setTitle:Local(@"search again") forState:UIControlStateNormal];
    [_searchAgainButton addTarget:self action:@selector(StartRipple) forControlEvents:UIControlEventTouchUpInside];
    
    
    _intoSoftAPButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/8.0*5.0, HIGHT - 80 - 64 , WIDTH/4.0, 40)];
    [_intoSoftAPButton setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [_intoSoftAPButton setBackgroundImage:[UIImage createImageWithColor:APPBLUECOlOR] forState:UIControlStateNormal];
    _intoSoftAPButton.enabled = NO;
    _intoSoftAPButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_intoSoftAPButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:nil];
    [_intoSoftAPButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_intoSoftAPButton setTitle:Local(@"Into SoftAP") forState:UIControlStateNormal];
    [_intoSoftAPButton addTarget:self action:@selector(stopRippleTosofSoftAP) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchAgainButton];
    [self.view addSubview:_intoSoftAPButton];
}

- (void)StartRipple{
    
    _searchAgainButton.enabled = NO;
    _intoSoftAPButton.enabled = NO;

    if(!_isrippleNow){
        __block int i = 60;
        _countLabel.text = @"60";
         _countLabel.font = [UIFont systemFontOfSize:30];
        
        if([[UIDevice currentDevice].systemVersion integerValue] >= 10){
            [NSTimer  scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull nowTimer) {
                
                _timer = nowTimer;
                //add ripple
                _countLabel.text = [NSString stringWithFormat:@"%d",--i];
                _isrippleNow = YES;
                UIView *ripleView = [[UIView alloc]init];
                [ripleView setFrame:CGRectMake(0, 0, _imageButton.width, _imageButton.height)];
                ripleView.center = _bgView.center;
                ripleView.backgroundColor = RGBColor(137,192,54, 0.4);
                ripleView.layer.borderColor = [ripleView backgroundColor].CGColor;
                ripleView.layer.borderWidth = 1;
                ripleView.layer.cornerRadius = ripleView.width/2.0 ;
                ripleView.layer.masksToBounds = YES;
                [_bgView addSubview:ripleView];
                [_bgView bringSubviewToFront:_imageButton];
                _bgView.layer.masksToBounds = YES;
                [UIView animateWithDuration:3 animations:^{
                    ripleView.transform = CGAffineTransformScale(ripleView.transform, 5, 5);
                    ripleView.alpha = 0;
                } completion:^(BOOL finished) {
                    [ripleView removeFromSuperview];
                }];
                //            if(arc4random() %10 < 3){
                //                [self addBubble];
                //            }
                if(i == 0){
                    [nowTimer invalidate];
                    _countLabel.text = Local(@"search again");
                    _countLabel.font = [UIFont systemFontOfSize:15];
                    _isrippleNow = NO;
                    _searchAgainButton.enabled = YES;
                    _intoSoftAPButton.enabled = YES;
                }
            }];
        }else{  //10.0以下的系统
            _count = 60;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animation_9:) userInfo:nil repeats:YES];
        }
        
        
    }
    [self Airlink];
}
- (void)animation_9:(NSTimer *)nowTimer{

    _timer = nowTimer;
    //add ripple
    _countLabel.text = [NSString stringWithFormat:@"%d",--_count];
    _isrippleNow = YES;
    UIView *ripleView = [[UIView alloc]init];
    [ripleView setFrame:CGRectMake(0, 0, _imageButton.width, _imageButton.height)];
    ripleView.center = _bgView.center;
    ripleView.backgroundColor = RGBColor(137,192,54, 0.4);
    ripleView.layer.borderColor = [ripleView backgroundColor].CGColor;
    ripleView.layer.borderWidth = 1;
    ripleView.layer.cornerRadius = ripleView.width/2.0 ;
    ripleView.layer.masksToBounds = YES;
    [_bgView addSubview:ripleView];
    [_bgView bringSubviewToFront:_imageButton];
    _bgView.layer.masksToBounds = YES;
    [UIView animateWithDuration:3 animations:^{
        ripleView.transform = CGAffineTransformScale(ripleView.transform, 5, 5);
        ripleView.alpha = 0;
    } completion:^(BOOL finished) {
        [ripleView removeFromSuperview];
    }];
    if(_count == 0){
        [nowTimer invalidate];
        _countLabel.text = Local(@"search again");
        _countLabel.font = [UIFont systemFontOfSize:15];
        _isrippleNow = NO;
        _searchAgainButton.enabled = YES;
        _intoSoftAPButton.enabled = YES;
    }
}


- (void)addBubble{
   
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(arc4random()%(int)WIDTH, arc4random()%(int)WIDTH, 10, 10)];
    UIImage *image = [UIImage imageNamed:@"pubble"];
    imageV.image = [image imageWithColor:RGBColor(arc4random()%256, arc4random()%256, arc4random()%256, 0.5)];
    [_bgView addSubview:imageV];
    [UIView animateWithDuration:2 animations:^{
        imageV.transform = CGAffineTransformRotate(imageV.transform, arc4random()%314*0.01);
        imageV.transform = CGAffineTransformScale(imageV.transform, 4, 4);
        imageV.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        [imageV removeFromSuperview];
    }];
}

- (void)stopRippleTosofSoftAP{

    SoftAPLinkPage *page = [[SoftAPLinkPage  alloc]initWithWifiName:self.wifiName WifiPassword:self.wifiPassword];
    [self.navigationController  pushViewController:page animated:YES];
}

@end
