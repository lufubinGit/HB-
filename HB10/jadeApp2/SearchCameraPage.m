//
//  SearchCameraPage.m
//  JADE
//
//  Created by JD on 2017/5/27.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SearchCameraPage.h"
#import "JDAppGlobelTool.h"
#import <GWP2P/GWP2P.h>
#import "AddCameraWithIDPage.h"
#import "DeviceInfoModel.h"
#import "LANCameraList.h"
#import "UIImage+BlendingColor.h"

@interface SearchCameraPage ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UIView *lingView;
@property (weak, nonatomic) IBOutlet UILabel *timerCount;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (strong,nonatomic) UIImageView *waveImage;
@property (strong, nonatomic) IBOutlet UIButton *addCameraBtn;
@property (strong, nonatomic) IBOutlet UIButton *flagBtn;
@property (strong, nonatomic) IBOutlet UILabel *tipContent;

@end

@implementation SearchCameraPage
{
    NSTimer *_timer;
    NSTimer *_timer1;
    NSInteger _timeCount;
    CGFloat _scale;
    BOOL isExit;
    NSTimer *SearchTimer;
    int CountNub;
    NSMutableArray *_currentDevcie;  //进行搜索以后获取的设备的个数
    NSMutableArray *_orignDevice;    //一开始进入扫描状态之前，获取的设备个数
    void *context;
    BOOL isFound;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //先进行一次局域网扫描
    //开始搜索设备
    [self KConfigCamera];
    [self initData];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _waveImage.hidden = YES;
    [_showImage removeFromSuperview];
    [self dismiss];
}

// 界面初始化
- (void)initUI{
    
    self.tips.text = Local(@"Connect the process for about 1-2 minutes, please be patient");
    self.tips.textColor = APPGRAYBLACKCOLOR;
    //添加滑动的波纹
    _waveImage = [[UIImageView alloc]initWithFrame:CGRectMake(-WIDTH*_scale, 0, WIDTH*_scale, WIDTH*_scale)];
    [self.view addSubview:_waveImage];
    _waveImage.image = [UIImage imageNamed:@"JADE_camera_wave"];
    _waveImage.backgroundColor = APPBACKGROUNDCOLOR;
    _timeCount = 120;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(waveShow) userInfo:nil repeats:YES];
    self.timerCount.text = [NSString stringWithFormat:@"%lds",(long)_timeCount];
    [self.view bringSubviewToFront:self.showImage];
    
    [self.flagBtn setImage:[UIImage imageNamed:@"addCamremaCancle"] forState:UIControlStateNormal];
    [self.flagBtn setImage:[UIImage imageNamed:@"addCamremaOK"] forState:UIControlStateSelected];
    
    self.addCameraBtn.enabled = NO;
    self.addCameraBtn.layer.cornerRadius = PublicCornerRadius;
    self.addCameraBtn.backgroundColor = APPLINECOLOR;

    self.tipContent.text = Local(@"Hear the camera suggested that the connection was successful");
    [self.addCameraBtn setTitle:Local(@"Add camera") forState:UIControlStateNormal];
}

- (void)waveShow{
    _timeCount--;
    if(_timeCount == 0){
        [_timer invalidate];
    }
    _waveImage.centerY = _showImage.centerY;
    [UIView animateWithDuration:1.4 animations:^{
        _waveImage.x = WIDTH*(1+_scale);
    } completion:^(BOOL finished) {
        _waveImage.right = 0;
    }];
}

#pragma mark - 设置
- (void)initData{
    _scale = 1.0/6.0;
    CountNub = 120;      //默认两分钟之内。
    //需要注意代码块会被回调许多次
    [[GWP2PDeviceLinker shareInstance] p2pSmartLinkDeviceWithWiFiSSID:self.SSID password:self.psw deviceLinkIn:^(NSDictionary *deviceDict) {
        
        if(!isFound){
            isFound = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
                LANCameraList *page = [[LANCameraList alloc] init];
                page.dModel = self.dModel;
                [self.navigationController pushViewController:page animated:YES];
            });
            [[GWP2PDeviceLinker shareInstance]  p2pStopSmartLink];
            NSString *deviceID = [deviceDict[@"deviceID"] stringValue];
            NSString *password = @"123";
            [self.dModel saveCameraPswWithId:deviceID psw:password];
            if (![deviceDict[@"isInitPassword"] boolValue]) { //设备没有初始化密码,设置密码
                [[GWP2PClient sharedClient] setDeviceInitialPassword:password  withDeviceID:deviceID completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
                    NSLog(@"success:%i %@",success,dataDictionary);
                    if (success) {
                        DLog(@"初始化密码成功");
                        //保存
                    }
                }];
            } else { //设备已经初始化密码,可以让用户输入正确的密码验证通过后加到本地列表,这里直接使用123
                
                [[GWP2PClient sharedClient] setDeviceAdministratorPasswordWithOldPassword:@"123" newPassword:password deviceID:deviceID completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
                    if(success){
                        DLog(@"修改密码成功");
                    }else{
                        DLog(@"初始密码不是 123  ");
                    }
                }];
            }
        }
    }];
}
- (IBAction)connectOK:(id)sender {
    self.addCameraBtn.enabled = !self.addCameraBtn.enabled;
    self.addCameraBtn.backgroundColor = self.addCameraBtn.enabled?APPBLUECOlOR:APPLINECOLOR;
    self.flagBtn.selected = !self.flagBtn.selected;
}

- (IBAction)addCamera:(id)sender {
    AddCameraWithIDPage *page = [[AddCameraWithIDPage alloc] init];
    page.dModel = self.dModel;
    [self.navigationController pushViewController:page animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//开始搜索设备
#pragma mark - 摄像机用
- (void)KConfigCamera{

    if (SearchTimer == nil) {
        CountNub = 120;
        SearchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(KCountDown) userInfo:nil repeats:YES];
    }
}

//倒计是结束 或者找到设备的时候就停止
- (void)KCountDown{
    CountNub -- ;
    self.timerCount.text = [NSString stringWithFormat:@"%lds",(long)CountNub];
    if (CountNub == 0) {
        if (SearchTimer != nil) {
            [SearchTimer invalidate];
            SearchTimer = nil;
            [SVProgressHUD showInfoWithStatus:Local(@"Failed")];
        }
    }
    NSLog(@"%d",CountNub);
}

- (void)dismiss{
    
    
    [_timer invalidate];
    [_timer1 invalidate];
    _timer1 = nil;
    _timer = nil;
    [SearchTimer invalidate];
    SearchTimer = nil;
    [self KStopSearch];

}

- (void)KStopSearch{
    [[GWP2PDeviceLinker shareInstance]  p2pStopSmartLink];
}


@end
