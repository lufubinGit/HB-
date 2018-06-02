//
//  VideoPlayPage.m
//  JADE
//
//  Created by JD on 2017/6/5.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "VideoPlayPage.h"
//#import "HSLSearchDevice.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "StreamPlayLib.h"
//#import "IPCClientNetLib.h"
//#import "MyGLViewController.h"
#import "LeftSlideViewController.h"
#import "JDAppGlobelTool.h"
#import "UIImage+ColorAtPoint.h"
#import "UIImage+BlendingColor.h"
#import "Masonry.h"
#import "DeviceInfoModel.h"
#import "EquipmentPage.h"
#import <GWP2P/GWP2P.h>


#define snptButtonW  WIDTH * 4/16.0
#define talkButtopnW  WIDTH * 5/16.0
#define funViewH WIDTH * 7/16.0


@interface VideoPlayPage ()
{
    GWP2PVideoPlayer *m_glView;
    int userid;
    int playid;
    int sid;
    BOOL bSnapshot;
    UILabel *lblMsg;
    int event_type;
//    HSLSearchDevice *SDevice;
    BOOL isSound;  //声音开启
    BOOL isTalking;  // 正在对讲， 注意： 对讲和听声音是冲突的， 两者不可同时进行／
    NSArray *Set_Array;
    UITableView *Set_Table;
    UIImageView *_soundImageView;  //展示声音是不是开启的按钮
    UILabel *_title;
    NSTimer *_cricleWaveTimer;
    
}

@end

@implementation VideoPlayPage

#pragma mark -- 界面
- (void)viewDidLoad {
    [super viewDidLoad];
    isSound = YES;   // 开始声音的开关
    isTalking = NO;
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *APPde = (AppDelegate*) [UIApplication sharedApplication].delegate;
    LeftSlideViewController *leftVC = (LeftSlideViewController *)APPde.window.rootViewController;
    [leftVC setPanEnabled:NO];
    DLog(@"%@",self.navigationController.viewControllers.firstObject);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *APPde = (AppDelegate*) [UIApplication sharedApplication].delegate;
    LeftSlideViewController *leftVC = (LeftSlideViewController *)APPde.window.rootViewController;
    [leftVC setPanEnabled:YES];
    DLog(@"%@",self.navigationController.viewControllers.firstObject);
//    x_player_destroyPlayInstance(playid);
    playid = -1;
//    [self.deviceViewPage refrshTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self btnStop];
}



#pragma mark - initUI
- (void)initUI{

    //关闭手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    float h = WIDTH;//self.view.frame.size.width*9/16;
    
    //添加播放部分
    //获取播放器比例
    CGFloat scale = 9/16.0;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    lineView.backgroundColor = APPMAINCOLOR;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*9/16.0 + 64 + 50)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = APPMAINCOLOR;
    [self.view addSubview:lineView];
    m_glView = [[GWP2PVideoPlayer alloc] init];
    m_glView.view.backgroundColor = [UIColor blackColor];
    DLog(@"%f",h);
    m_glView.view.frame = CGRectMake(0, 64, WIDTH, WIDTH*9/16.0);
    [self.view addSubview:m_glView.view];
    [bgView addSubview:m_glView.view];
    
    //底部总控件
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, m_glView.view.bottom, WIDTH, 50)];
    bottomView.backgroundColor = [UIColor blackColor];
    [bgView addSubview:bottomView];
    //添加返回的按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 32, WIDTH*1.5/16.0, WIDTH*1.2/16.0)];
    backButton.centerY = 42;
    [backButton addTarget:self action:@selector(viewBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[[UIImage imageNamed:@"JD_Video_Play_Back"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"JD_Video_Play_Back"] imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateHighlighted];
    backButton.layer.cornerRadius = WIDTH*0.75/16.0;
    backButton.layer.masksToBounds = YES;
    [bgView addSubview:backButton];
    
    //添加标题
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2.0, 40)];
    _title.centerX = bgView.x + bgView.width/2.0;
    _title.centerY = backButton.centerY;
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont systemFontOfSize:17];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = self.camera.cameraName;
    [bgView addSubview:_title];

    //添加删除设备的按钮
    UIButton *deleButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 0, 40, 40)];
    deleButton.backgroundColor = [UIColor clearColor];
    [deleButton setImage:[[UIImage imageNamed:@"JD_Video_Play_delete"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [deleButton setImage:[[UIImage imageNamed:@"JD_Video_Play_delete"] imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateHighlighted];
    [deleButton addTarget:self action:@selector(deleteCamera) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleButton];
    [deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WIDTH*1.2/16.0));
        make.height.equalTo(@(WIDTH*1.2/16.0));
        make.centerY.equalTo(backButton.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset(-20);
    }];
    
    //设置名字的按钮
    UIButton *setNameButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 50)];
    setNameButton.backgroundColor = [UIColor clearColor];
    [setNameButton setImage:[[UIImage imageNamed:@"JD_Video_Play_name"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [setNameButton setImage:[[UIImage imageNamed:@"JD_Video_Play_name"] imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateHighlighted];
    [setNameButton addTarget:self action:@selector(modifyName) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:setNameButton];
    [setNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WIDTH*1.0/16.0));
        make.height.equalTo(@(WIDTH*1.0/16.0));
        make.centerY.equalTo(backButton.mas_centerY);
        make.right.equalTo(deleButton.mas_left).offset(-30);
    }];
    
    // 状态／声音
    lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(10, bgView.bottom - 30, WIDTH/4.0, 30)];
    lblMsg.centerY = bottomView.x + bottomView.height/2.0;
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.backgroundColor = [UIColor clearColor];
    lblMsg.font = [UIFont systemFontOfSize:14];
    lblMsg.layer.cornerRadius = PublicCornerRadius;
    lblMsg.layer.borderWidth = 1.0;
    lblMsg.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    lblMsg.textColor = [UIColor whiteColor];
    lblMsg.layer.masksToBounds = YES;
    lblMsg.text = Local(@"connecting...");
    [bottomView addSubview:lblMsg];

    _soundImageView =  [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 50, 50)];
    _soundImageView.animationImages = @[[[UIImage imageNamed:@"JD_Video_Play_sound1"]imageWithColor:[UIColor whiteColor]],[[UIImage imageNamed:@"JD_Video_Play_sound"]imageWithColor:[UIColor whiteColor]]];
    _soundImageView.animationDuration = 1;
    [_soundImageView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSound)];
    bgView.userInteractionEnabled = YES;
    bottomView.userInteractionEnabled = YES;
    _soundImageView.userInteractionEnabled = YES;
    [_soundImageView addGestureRecognizer:tap];
    [bottomView addSubview:_soundImageView];
    [_soundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WIDTH*1.5/16.0));
        make.height.equalTo(@(WIDTH*1.5/16.0));
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset(-10);
    }];

    
    //对讲按钮
//    UIButton *sayButton = [[UIButton alloc]initWithFrame:CGRectZero];
//    sayButton.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:sayButton];
//    [deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(WIDTH*1.2/16.0));
//        make.height.equalTo(@(WIDTH*1.2/16.0));
//        make.centerY.equalTo(backButton.mas_centerY);
//        make.right.equalTo(bgView.mas_right).offset(-20);
//    }];
    
    //录制和截屏的模块View
    UIView *funcView = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.x + bgView.height, WIDTH, funViewH)];
    funcView.backgroundColor = [UIColor clearColor];
    
    //对讲按钮
    UIButton *talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    talkButton.frame = CGRectMake(0, 0, talkButtopnW, talkButtopnW);
    talkButton.centerX = funcView.centerX;
    talkButton.centerY = funcView.height/2.0;
    talkButton.backgroundColor = [UIColor clearColor];
    [talkButton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchDown];
    [talkButton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [talkButton setImage:[UIImage imageNamed:@"JD_cmeraMike01"] forState:UIControlStateNormal];
    [talkButton setImage:[UIImage imageNamed:@"JD_cmeraMike02"] forState:UIControlStateHighlighted];


    funcView.userInteractionEnabled = YES;
    [funcView addSubview:talkButton];
    [self.view addSubview:funcView];
    
//    UIButton *snptButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    snptButton.frame = CGRectMake(0, 0,  snptButtonW,  snptButtonW);
//    snptButton.centerX =
      //上
    UISwipeGestureRecognizer *SwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    SwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [m_glView.view addGestureRecognizer:SwipeUp];
    //下
    UISwipeGestureRecognizer *SwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    SwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [m_glView.view addGestureRecognizer:SwipeDown];
    //左
    UISwipeGestureRecognizer *SwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    SwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [m_glView.view addGestureRecognizer:SwipeLeft];
    //右
    UISwipeGestureRecognizer *SwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    SwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [m_glView.view addGestureRecognizer:SwipeRight];
}

//对讲按钮
- (void)talkButtonClick:(UIButton *)btn{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isTalking = !isTalking;
        DLog(@" %d ",isTalking);
        if(isTalking){    //对讲
            if(isSound){  //如果当前正在播放声音
                [self btnCloseSound];
            }
            [self btnOpenTalk];
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setImage:[UIImage imageNamed:@"JD_cmeraMike02"] forState:UIControlStateNormal];
                [self addCricleWaveForView:btn];
            });
        }else{
            if(isSound){  //如果当前正在播放声音
                [self btnOpenSound];
            }
            [self btnCloseTalk];
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setImage:[UIImage imageNamed:@"JD_cmeraMike01"] forState:UIControlStateNormal];
                [_cricleWaveTimer invalidate];
                _cricleWaveTimer = nil;
            });
        }
    });
}

//addCricleWave
- (void)addCricleWaveForView:(UIButton *)aView{
    _cricleWaveTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(creartWave:) userInfo:aView repeats:YES];
}

- (void)creartWave:(NSTimer *)ti{
    UIButton *aView = ti.userInfo;
    UIView *wave = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aView.width*0.8, aView.height*0.8)];
    wave.center = aView.center;
    wave.layer.borderColor = APPBLUECOlOR.CGColor;
    wave.backgroundColor = APPBLUECOlOR;
    wave.alpha = 0.8;
    wave.layer.cornerRadius = wave.width/2.0;
    wave.layer.masksToBounds = YES;
    wave.layer.borderWidth = 1.0;
    [aView.superview addSubview:wave];
    [aView.superview sendSubviewToBack:wave];
    [UIView animateWithDuration:1.0 animations:^{
        wave.transform = CGAffineTransformScale(wave.transform, 1.5, 1.5);
        wave.alpha = 0;
    } completion:^(BOOL finished) {
        [wave removeFromSuperview];
    }];
}

//修改名字的按钮
- (void)modifyName{

    Local(@"Modify remarks");
    __weak typeof(self) weakSlef = self;
    UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:Local(@"Modify remarks") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = Local(@"Remarks name");
    }];
    [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textF = alertVC1.textFields.firstObject;
        if(textF.text.length == 0){
            [SVProgressHUD showInfoWithStatus:Local(@"Please enter a remark name.")];
            return ;
        }
        _title.text = textF.text;
        [self.camera setCameraNewName:_title.text];
        DLog(@"现在还什么都没有做。");
        [alertVC1 dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC1 dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC1 animated:YES completion:nil];
    
    
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Eidt") preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Modify remarks") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC dismissViewControllerAnimated:YES completion:^{
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:Local(@"Modify remarks") message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            [alertVC1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = Local(@"Remarks name");
//            }];
//            [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField *textF = alertVC1.textFields.firstObject;
//                if(textF.text.length == 0){
//                    [SVProgressHUD showInfoWithStatus:Local(@"Please enter a remark name.")];
//                    return ;
//                }
//                                _title.text = textF.text;
//                                [self.camera setCameraNewName:_title.text];
//                DLog(@"现在还什么都没有做。");
//                [alertVC1 dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [alertVC1 dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [weakSlef presentViewController:alertVC1 animated:YES completion:nil];
//            
//        });
//
//    }]];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Modify the device password") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC dismissViewControllerAnimated:YES completion:^{
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:Local(@"Modify password") message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            [alertVC1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = Local(@"new password");
//            }];
//            [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField *textF = alertVC1.textFields.firstObject;
//                if(textF.text.length == 0){
//                    [SVProgressHUD showInfoWithStatus:Local(@"Please enter the camera password.")];
//                    return ;
//                }
//                DLog(@"现在还什么都没有做。");
//                if(textF.text.length <6 || textF.text.length>30){
//                    [SVProgressHUD showInfoWithStatus:Local(@"The password is 6-30 characters")];
//                }
//                
//                [[GWP2PClient sharedClient] setDeviceAdministratorPasswordWithOldPassword:[DeviceInfoModel getCameraPswWithId:weakSlef.camera.cameraID] newPassword:[NSString stringWithFormat:@"a%@",textF.text] deviceID:weakSlef.camera.cameraID completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
//                    if(success){
//                        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
//                        [DeviceInfoModel saveCameraPswWithId:weakSlef.camera.cameraID psw:[NSString stringWithFormat:@"a%@",textF.text]];
//                    }else{
//                        [SVProgressHUD showInfoWithStatus:Local(@"Failed")];
//                    }
//                }];
//                [alertVC1 dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [alertVC1 addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [alertVC1 dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [weakSlef presentViewController:alertVC1 animated:YES completion:nil];
//        });
//
//    }]];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    
//    
//    [self presentViewController:alertVC animated:YES completion:nil];

}

//删除摄像头
- (void)deleteCamera{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Local(@"") message:Local(@"Are you sure you want to delete the camera?") preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.dModel deleteCameraWithID:self.camera.cameraID];
        [self viewBack];  //删除之后返回
        [alertVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//点击声音的按钮 静音活着关闭
- (void)changeSound{
    isSound = !isSound;
    if(isSound){  //开启声音
        [self btnOpenSound];
        _soundImageView.animationImages = @[[[UIImage imageNamed:@"JD_Video_Play_sound1"]imageWithColor:[UIColor whiteColor]],[[UIImage imageNamed:@"JD_Video_Play_sound"]imageWithColor:[UIColor whiteColor]]];
        [_soundImageView startAnimating];
        
    }else{ //关闭声音
        [self btnCloseSound];
        _soundImageView.animationImages = @[[[UIImage imageNamed:@"JD_Video_Play_nosound"]imageWithColor:[UIColor whiteColor]]];
        [_soundImageView startAnimating];

    }
    
}

//推出模态弹窗
- (void)viewBack{
    m_glView = nil;
    [self btnStop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上下左右
- (void)Swipe:(UISwipeGestureRecognizer *)Ges{
    
    if (Ges.direction == UISwipeGestureRecognizerDirectionUp) {
        [m_glView p2pTurnDirection:GWP2PPTZDirectionUp];
    }else if (Ges.direction == UISwipeGestureRecognizerDirectionDown){
        [m_glView p2pTurnDirection:GWP2PPTZDirectionDown];
    }else if (Ges.direction == UISwipeGestureRecognizerDirectionLeft){
        [m_glView p2pTurnDirection:GWP2PPTZDirectionLeft];
    }else if (Ges.direction == UISwipeGestureRecognizerDirectionRight){
        [m_glView p2pTurnDirection:GWP2PPTZDirectionRight];
    }
}

#pragma mark - initData
- (void)initData{
    
    [self btnConnect];
}

#pragma mark - 局域网搜索
- (void)LANSearch{
//    SDevice.searchDelegate = self;
//    [SDevice Search];
}

#pragma mark - HSLSearchDeviceDelegate 局域网搜索代理
- (void)SearchDevice:(int)DeviceType MAC:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(int)port DeviceID:(NSString *)did SmartConnect:(int)smartconnection{
    NSLog(@"name:%@ did:%@",name,did);
}
#pragma mark - 事件
//连接设备
- (void)btnConnect
{
    
    lblMsg.text = Local(@"connecting...");
    __weak typeof(self) weakSelf = self;
    __block NSString *str = @"";
    NSString *cameraPsw = [self.dModel getCameraPswWithId:self.camera.cameraID];
    [m_glView p2pCallDeviceWithDeviceId:self.camera.cameraID password:cameraPsw deviceType:GWP2PDeviceTypeIPC deviceSubtype:GWP2PDeviceIPCSubtypeNormal calling:^(NSDictionary *parameters) {
        NSLog(@"[p2pCallDevice-Calling],paras=%@",parameters);
 
        dispatch_async(dispatch_get_main_queue(), ^{
            str = Local(@"connecting...");
            lblMsg.text = str;
        });

    } accept:^(NSDictionary *parameters) {
        NSLog(@"[p2pCallDevice-Accept],paras=%@",parameters);
        str = Local(@"Succeeded");
        dispatch_async(dispatch_get_main_queue(), ^{
            lblMsg.text = str;
        });
    } reject:^(GWP2PCallError error, NSString *errorCode) {
        str = Local(@"Offline");
        dispatch_async(dispatch_get_main_queue(), ^{
            lblMsg.text = str;
            //失败之后会继续重连
            [weakSelf btnConnect];
        });

        
        NSLog(@"[p2pCallDevice-Reject],error=%ld,errorCode=%@",(unsigned long)error, errorCode);
    } ready:^{
        str = Local(@"Online");
        dispatch_async(dispatch_get_main_queue(), ^{
            lblMsg.text = str;
        });
        NSLog(@"[p2pCallDevice-Ready] %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
}

//停止播放
- (void)btnStop
{
    [m_glView p2pStop];  //停止播放

}

//关闭录像
- (void)btnCloseVideo
{

}

/*!!!!!!!!!!!!!!请注意监听和对讲互斥!!!!!!!!!!!!!!!!!!!!*/
- (void)btnOpenSound
{
    m_glView.mute = NO;  //关闭静音
}

//关闭监听
- (void)btnCloseSound
{
    m_glView.mute = YES;  //设置成静音
}

//开启对讲
- (void)btnOpenTalk
{
    [m_glView p2pEnableSpeak:NO];
}

//关闭对讲
- (void)btnCloseTalk
{
    [m_glView p2pEnableSpeak:YES];

}

//截屏
- (void)btnSnapshot
{

}


- (void)btnGetParam{


}

//开始录制
- (void)btnRecord{
}

//停止录制
- (void)btnStopRecord{

}

//播放录制的视屏
- (void)btnPlayRecord{
    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    NSLog(@"record path:%@", betaCompressionDirectory);
    MPMoviePlayerViewController *MoviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:betaCompressionDirectory]];
    //MoviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self presentMoviePlayerViewControllerAnimated:MoviePlayerView];
    [MoviePlayerView.moviePlayer play];
}


/*
 * 事件处理，若显示到控件必须转到主线程处理
 */
- (void)ProcessEvent:(int)nType
{

}

- (void)ProcessP2pMode:(int)mode
{
    NSLog(@"P2P Mode = %d",mode);
}

- (void)ProcessAlarmMessage:(int)nType
{
    NSLog(@"alarm type = %d", nType);
}

- (void)ProcessGetParam:(int)nType Data:(const char*)szMsg DataLen:(int)len
{

}

- (void)ProcessSetParam:(int)nType Result:(int)result
{

}

@end
