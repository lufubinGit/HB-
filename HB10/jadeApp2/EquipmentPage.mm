
//
//  EquipmentPage.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "EquipmentPage.h"
#import "EquipmentTableViewCell.h"
#import "DeviceInfoModel.h"
#import "StateTableViewCell.h"
#import "AddDeviceFunctionCell.h"
#import "GizSupport.h"
#import "DataPointModel.h"
#import "LeftSlideViewController.h"
#import "UIImage+BlendingColor.h"
#import "DeviceRecordPage.h"
#import "UserLoginPage.h"
#import "SwitchTableViewCell.h"
#import "SliderTableViewCell.h"
#import "SetGatewayPage.h"
#import "LinkHostWifiPage.h"
#import "SHowSubDeviceCell.h"
#import "QRcodeSupportVC.h"
#import "EquipmentSectionView.h"
#import "UnbindfViewController.h"
#import "AddMoreSubDevciePage.h"
#import "BaseSubDevicePage.h"
#import "MJRefresh.h"
//#import "CamerDeviceShowButton.h"
#import "AddDeviceTipPage.h"
#import "ChooseSubDeviceType.h"
#import "JDAppGlobelTool.h"
#import "ConectionCameraPage.h"
#import "AddCameraOrOtherPage.h"
#import "VideoPlayPage.h"
#import "SubDeviceShowPage.h"
#import "DerectorDetailPage.h"

#define SectionViewHei 90
#define BottomeButtonhei 60

#define ScorllHeardViewHei 60

#define DisArm Local(@"disarm")
#define AwayArm Local(@"armaway")
#define StayArm Local(@"armstay")
#define Record Local(@"record")

#define AddCamerCode     if(camerDevice.camerNetIsonline){[self.onlineCamerArr addObject:[self creatCamerShowingButton:camerDevice inTableView:self.talbeView]];}else{[self.offlinCamerArr addObject:[self creatCamerShowingButton:camerDevice inTableView:self.rightTableView]];}if((self.onlineCamerArr.count + self.offlinCamerArr.count) == camerArr.count){dispatch_async(dispatch_get_main_queue(), ^{[self.talbeView reloadData];[self.rightTableView reloadData];[self showNoOfflinDevcie];[self showNoOnlinDevcie];}); }

//弹窗文字
#define AlertTitle Local(@"Device")
#define AlertMessage Local(@"You can choose one of the following ways to add equipment.")
#define DeleteTip Local(@"The device is offline. If you remove the device, you can not obtain real-time information about the device after the device goes online. Are you sure you want to delete the device ?")

@interface EquipmentPage ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
    
@property (nonatomic,strong) UITableView *talbeView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *sectionDeviceArr;
@property (nonatomic,strong) DeviceInfoModel *currentDevice;   //当前选中的设备
@property (nonatomic,strong) UIView *currentDeviceSectionView;   //当前选中的设备对应的SectionView
@property (nonatomic,strong) NSMutableArray *currentArr;  //当前选中的设备的数据点的数组
@property (nonatomic,strong) SetGatewayPage *gatewayPage;
@property (nonatomic,strong) BaseSubDevicePage *subDevicePag;
@property (nonatomic,assign) BOOL isFirst;                //当前APP是否是第一次登陆


//重新设计之后  APP主界元素
@property (nonatomic,strong) UIScrollView *scrollView;  //左右滚动
@property (nonatomic,strong) UIButton *oldLineButton;   //当前选中的scorllView的头部的按钮  用于改变状态
@property (nonatomic,strong) UIButton *leftLineButton;  //左边按钮
@property (nonatomic,strong) UIButton *rightLineButton; //右边按钮
@property (nonatomic,strong) UIView *lineView;          //scorllView的头部 滚条线
@property (nonatomic,strong) UIView *noOnlineDevcieView;         //没有在线设备的时候展示的图
@property (nonatomic,strong) UIView *noOfflineDevcieView;        //没有离线设备的时候展示的图
@property (nonatomic,strong) UITableView *rightTableView; //右边是图 的tableView
@property (nonatomic,strong) NSMutableArray *onlineArr;   //在线HB10设备的数组
@property (nonatomic,strong) NSMutableArray *offLineArr;  //离线HB10设备的数组
@property (nonatomic,strong) NSMutableArray *onlineDerectorArr;   //在线HB10设备的数组
@property (nonatomic,strong) NSMutableArray *offLineDerectorArr;  //离线HB10设备的数组
@property (nonatomic,strong) NSMutableArray<EquipmentSectionView*>*  onlineSectionView;   //在线 HB10 section
@property (nonatomic,strong) NSMutableArray<EquipmentSectionView*>*  offlineSectionView;  //离线 HB10 section

@property (nonatomic,strong) NSMutableArray<EquipmentSectionView*>*  onlineDerectorSectionView;   //在线 探测器 section
@property (nonatomic,strong) NSMutableArray<EquipmentSectionView*>*  offlineDerectorSectionView;  //离线 探测器 section

@property (nonatomic,strong) DeviceInfoModel *oldModel;

//添加摄像头元素
@property (nonatomic,strong) NSMutableArray *onlineCamerArr,*offlinCamerArr ;  //摄像头设备的数组

@end

@implementation EquipmentPage
    {
        UIButton *_showMenuBUtton;
        UIImageView *_BGview;
        MJRefreshNormalHeader *_head;
        NSTimeInterval _timeOut;
    }
    
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
    
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = AlertTitle;
    if([JDAppGlobelTool shareinstance].isFirstUser){
        [self firstLog];                             //第一次登陆会展示引导图
        self.isFirst = YES;
    }
    [self addDeviceButton];                       //添加右上小按钮
    [self addMenuButton];                         //左上菜单
    [self.view addSubview:self.scrollView];
    [self.view addSubview:[self creatScrollHeardView]];
    [self.scrollView addSubview:self.talbeView];
    [self.scrollView addSubview:self.rightTableView];
    [self autoLoginGiz];                          //开启自动登录
    [self addnoti];                               //添加通知
    [self.talbeView addSubview:self.noOnlineDevcieView];
    
    //启动之后五秒刷新数据信息
    [self performSelector:@selector(initData) withObject:nil afterDelay:5];
    _head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(stopRefrsh) withObject:nil afterDelay:10];
        [self initData];
        [_head endRefreshing];
    }];
    self.talbeView.mj_header = _head;
    _head.stateLabel.textColor = APPMAINCOLOR;
    [_head setTitle:Local(@"MJRefreshHeaderIdleText") forState:MJRefreshStateIdle];
    [_head setTitle:Local(@"MJRefreshHeaderPullingText") forState:MJRefreshStatePulling];
    [_head setTitle:Local(@"MJRefreshHeaderRefreshingText") forState:MJRefreshStateRefreshing];
    _head.lastUpdatedTimeLabel.hidden = YES;
    _head.arrowView.image = [_head.arrowView.image imageWithColor:APPMAINCOLOR];
    self.talbeView.mj_header.tintColor = APPMAINCOLOR;
}
    
    
- (void)firstLog{
    UIImage *image = [UIImage imageNamed:Local(@"handleImageEN")];
    __block  UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH*300/645.0)];
    imageV.image = image;
    [[JDAppGlobelTool shareinstance] creatHollowInMap:APPWindow withHollowRect:CGRectMake(WIDTH - 44, 20, 40, 40) color:[UIColor grayColor] handleBlock:^{
        
        [self chooseLinkStyle];
        [imageV removeFromSuperview];
    }];
    [APPWindow addSubview:imageV];
    [APPWindow bringSubviewToFront:imageV];
}
    
    //刷新所有设备的信息
- (void)initData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
            [self refresh];
            [self stopRefrsh];
        } failed:^(NSString *) {
        }];
        for (DeviceInfoModel *model in self.onlineArr) {
            [[GizSupport sharedGziSupprot] gizGetDeviceStatesWithSN:90 device:model callBack:^(NSDictionary * datamap) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refresh];
                    [self stopRefrsh];
                });
            }];
        }
    });
}
    
    //addnot
- (void)addnoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:GizDeviceRefrsh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:GizLoginSuc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:GizLogOutSuc object:nil];
}
    
    //添加水印
- (void)addWaterPrintf{
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2.0 - 21 , 10 + ScorllHeardViewHei , 36, 10)];
    imageV.image = [RepalceImage(@"NULL") imageWithColor:[UIColor grayColor]];
    [self.view addSubview:imageV];
    [self.view sendSubviewToBack:imageV];
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
}
    
    //创建滑动小控件
- (UIView *)creatScrollHeardView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ScorllHeardViewHei)];
    view.backgroundColor = [UIColor whiteColor];
    
    //设置成模糊效果背景  后期改动  去掉了模糊效果
    //    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    UIVisualEffectView *effView = [[UIVisualEffectView alloc]initWithEffect:eff];
    //    effView.frame = view.bounds;
    //    [view addSubview:effView];
    
    //添加两个按钮
    for(int i = 0 ;i < 2 ;i++){
        UIButton *LineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        LineButton.frame = CGRectMake(view.width/2.0*i, 0, view.width/2.0, view.height);
        [LineButton setTitle:Local(@"Online") forState:UIControlStateNormal];
        if(i == 1){
            [LineButton setTitle:Local(@"Offline") forState:UIControlStateNormal];
            [LineButton setImage:[[UIImage imageNamed:@"centerDeviceOffline"] imageWithColor:APPGRAYBLACKCOLOR]  forState:UIControlStateNormal];
            [LineButton setImage:[[UIImage imageNamed:@"centerDeviceOffline"] imageWithColor:APPMAINCOLOR]  forState:UIControlStateSelected];
            self.rightLineButton = LineButton;
        }else{
            _oldLineButton = LineButton;
            _oldLineButton.selected= YES;
            self.leftLineButton = LineButton;
            [LineButton setImage:[[UIImage imageNamed:@"centerDeviceOnline"] imageWithColor:APPGRAYBLACKCOLOR]  forState:UIControlStateNormal];
            [LineButton setImage:[[UIImage imageNamed:@"centerDeviceOnline"] imageWithColor:APPMAINCOLOR]  forState:UIControlStateSelected];
        }
        
        LineButton.imageEdgeInsets = UIEdgeInsetsMake(15, 40 , 15, 40);
        LineButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,0);
        LineButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [LineButton setTitleColor:APPGRAYBLACKCOLOR forState:UIControlStateNormal];
        [LineButton setTitleColor:APPMAINCOLOR forState:UIControlStateSelected];
        LineButton.backgroundColor = [UIColor clearColor];
        [LineButton addTarget:self action:@selector(lineButtonClick:) forControlEvents:UIControlEventTouchUpInside];  //点击事件
        [view addSubview:LineButton];
    }
    
//添加小竖线
    UIView *verticalView = [[UIView alloc]initWithFrame:CGRectMake(view.width/2.0 - 0.5, 10, 1, view.height - 20)];
    verticalView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [view addSubview:verticalView];
    
    //添加滚动条的底槽
    CGFloat linviewHei = 3.0f;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, view.height - linviewHei, view.width, linviewHei)];
    line.backgroundColor = APPLINECOLOR;
    line.alpha = 0.6;
    [view addSubview:line];
    
//添加滚动线
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view.height - linviewHei, view.width/2.0f, linviewHei)];
    self.lineView.backgroundColor = APPMAINCOLOR;
    self.lineView.layer.cornerRadius = linviewHei/2.0f;
    self.lineView.alpha = 0.6;
    [view addSubview:self.lineView];
    return view;
}
    
//创建每一个网关的展示图
- (EquipmentSectionView *)creatGetwayViewForDevice:(DeviceInfoModel *)device inTableView:(UITableView *)tableView{
    
    EquipmentSectionView *GWView = [[EquipmentSectionView alloc]initWithFrame:CGRectMake(0, 8, WIDTH, SectionViewHei)device:device tableView:tableView];
    [GWView.deleteButton addTarget:self action:@selector(deleteleView:) forControlEvents:UIControlEventTouchUpInside];
    return GWView;
}
    
- (UIView *)creatNoDevcieView:(NSString *)text {
    
    int labelHei = 20;
    int imageHei = 100;
    int labelW = 150;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelW, labelHei + imageHei)];
    view.centerX = self.talbeView.centerX;
    view.centerY = self.talbeView.centerY*0.6;
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((labelW-imageHei)/2.0, 0, imageHei, imageHei)];
    imageV.image = [UIImage imageNamed:@"noDevice"];
    [view addSubview:imageV];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHei, labelW, labelHei)];
    [view addSubview:textLabel];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = APPLINECOLOR;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = text;
    return view;
}

    //添加左上角 显示菜单的按钮
- (void)addMenuButton{
    _showMenuBUtton = NavLeftButton;
    [_showMenuBUtton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [_showMenuBUtton setImage:[[UIImage imageNamed:@"menu"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
    [_showMenuBUtton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_showMenuBUtton];
}

    //添加右上角 进入添加设备的按钮
- (void)addDeviceButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(chooseLinkStyle)];
}

#pragma mark evevnts
    
    //语言本地化内容
- (void)localLanguage{
    self.navigationItem.title = AlertTitle;
    [self.leftLineButton setTitle:Local(@"Online") forState:UIControlStateNormal];
    [self.rightLineButton setTitle:Local(@"Offline") forState:UIControlStateNormal];
    [self refresh];
    [_head setTitle:Local(@"MJRefreshHeaderIdleText") forState:MJRefreshStateIdle];
    [_head setTitle:Local(@"MJRefreshHeaderPullingText") forState:MJRefreshStatePulling];
    [_head setTitle:Local(@"MJRefreshHeaderRefreshingText") forState:MJRefreshStateRefreshing];
}
    
    //自动登里机智云
-(void)autoLoginGiz{
    NSString *accout = [[NSUserDefaults standardUserDefaults] objectForKey:JadeUserName];
    NSString *psw = [[NSUserDefaults standardUserDefaults] objectForKey:jadeUserPassword];
    if(accout.length && psw.length){
        [[GizSupport sharedGziSupprot] gizLoginWithUserName:accout password:psw Succeed:^{
            NSLog(@"登录成功");
            [GizSupport sharedGziSupprot].GizUserName = accout;
            [GizSupport sharedGziSupprot].GizUserPassword = psw;
            [GizSupport sharedGziSupprot].isLogined = YES;
            [self initData];
        } failed:^(NSString *err){
            [self senNSLogPage];
        }];
    }else{
        [self senNSLogPage];
    }
}
    
    //主动停止刷新
- (void)stopRefrsh{
    [self.talbeView.mj_header endRefreshing];
    if(self.talbeView.mj_header.isRefreshing){
        [self.talbeView.mj_header endRefreshing];
    }
}
    
    //进入对应的网关设置界面
- (void)intoGetwaySettingPage:(DeviceInfoModel *)device{
    SetGatewayPage *page = [[SetGatewayPage alloc] init];
    self.gatewayPage = page;
    page.currentDevice = device;
    [self.navigationController pushViewController:page animated:YES];
}
    
    //长按section 头部探出删除的alert  feichu
- (void)delegateDevice:(UILongPressGestureRecognizer *)longpress{
    EquipmentSectionView *longPressView = (EquipmentSectionView*) longpress.view;
    UIAlertController  *alertVc = [UIAlertController alertControllerWithTitle:@"DelegateDevice" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showWithStatus:Local(@"Loading")];
        DeviceInfoModel *model = longPressView.devcieModel;
        [[GizSupport sharedGziSupprot] gizUnbindDeviceWithDeviceDid:model Succeed:^{
        }];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}
    
    
- (void)lineButtonClick:(id)send{
    [self moveLineView:send];
    UIButton *button = send;
    [self.scrollView setContentOffset:CGPointMake(button.x * 2.0 , 0) animated:YES];
}
    
- (void)moveLineView:( id)send{
    if([send isKindOfClass:[UIButton class]]){
        UIButton *button = send;
        button.selected = YES;
        if(button != _oldLineButton){
            _oldLineButton.selected = NO;
            _oldLineButton = button;
        }
    }
}
    
#pragma mark scorllView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView){
        CGFloat X = scrollView.contentOffset.x;
        _lineView.x = X /2.0;
    }
}
    
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView){
        CGFloat X = scrollView.contentOffset.x;
        if(X > WIDTH/2.0){
            [self moveLineView:self.rightLineButton];
        }
        else{
            [self moveLineView:self.leftLineButton];
        }
    }
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView){
        CGFloat X = scrollView.contentOffset.x;
        if(X > WIDTH/2.0){
            [self moveLineView:self.rightLineButton];
        }
        else{
            [self moveLineView:self.leftLineButton];
        }
    }
}
    
    //弹出提示框
- (void)chooseLinkStyle{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:AlertTitle message:AlertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Scan the surrounding devices") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoAddTipPage];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    //    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Add sharing device") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [self intoQRcodeVC];
    //        [alertVc dismissViewControllerAnimated:YES completion:nil];
    //    }]];
    
    //    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Add the camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [alertVc dismissViewControllerAnimated:YES completion:nil];
    //        [self intoCameraAdding];
    //    }]];
//        [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Scan QR code") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self intoQRcodeVC];
//            [alertVc dismissViewControllerAnimated:YES completion:nil];
//            }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Add detector") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoAddTipPage];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];

    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"LAN online device") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoLANDeviceList];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    if([GizSupport sharedGziSupprot].isLogined){
        [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Replacement account") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginPage *usePage = [[LoginPage alloc]init];
            
            usePage.isLogin = NO;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:usePage] animated:YES completion:nil];
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    [self presentViewController:alertVc animated:YES completion:^{
        if(self.isFirst){
            //添加遮罩层
            [[JDAppGlobelTool shareinstance] creatHollowInMap:APPWindow withHollowRect:CGRectMake(0, HIGHT - alertVc.actions.count*56-25, WIDTH, 56) color:[UIColor colorWithWhite:0 alpha:0.5] handleBlock:^{
                [alertVc dismissViewControllerAnimated:YES completion:^{
                    //进入提示界面
                    [self intoAddTipPage];
                    self.isFirst = NO;
                }];
            }];
        }
    }];
}

- (void)intoLANDeviceList{
    UnbindfViewController *bindVc = [[UnbindfViewController alloc]init];
    [self.navigationController pushViewController:bindVc animated:YES];
}
    
    
    //进入引导界面
- (void)intoAddTipPage{
    [self.navigationController pushViewController:[[AddDeviceTipPage alloc] init] animated:YES];
}
    
    //获取二维码
- (void)getTwoCode{
    
    //    UIViewController *AVC = [[UIViewController alloc]init];
    //    AVC.view.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV  = [[UIImageView alloc]init];
    //    imageV.frame = CGRectMake(50, 100, WIDTH-100, WIDTH-100);
    //    QRcodeSupportVC *QRVC = [[QRcodeSupportVC alloc]init];
    //    imageV.image = [QRVC productQRCodeWithContent:@"https://itunes.apple.com/cn/app/homealarm/id1150324135?mt=8" waterImage:[UIImage imageNamed:@"Icon"]];
    //    [AVC.view addSubview:imageV];
    //    [self.navigationController pushViewController:AVC animated:YES];
}
    
    //进入配置摄像头的界面
- (void)intoCameraAdding{
    ConectionCameraPage *page = [[ConectionCameraPage alloc]init];
    page.hidesBottomBarWhenPushed = YES;
    page.deviceModel = self.currentDevice;
    [self.navigationController pushViewController:page animated:YES];
}
    
- (void)intoQRcodeVC{
    QRcodeSupportVC *QRVC = [[QRcodeSupportVC alloc]initWithBlock:^(AVMetadataMachineReadableCodeObject *obj) {
        
        NSLog(@"%@",obj.stringValue);
        [[GizSupport sharedGziSupprot] gizBindDeviceWithQRcodeString:obj.stringValue Succeed:^{
            
            
        } failed:^(NSString *err){
            
        }];
    }];
    [self.navigationController pushViewController:QRVC animated:YES];
}
    
// 跳转视图 共外部调用
- (void)navPushToVc:(UIViewController* )vc{
    [self.navigationController pushViewController:vc animated:YES];
}
    
// 点击菜单按钮抽屉效果显示菜单
- (void)showMenu{
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:RootNavSwipNot object:nil];
}
    
// 超时设置 3秒没有回应久设置超时
- (void)SvpDismiss{
    [SVProgressHUD dismiss];
}
    
- (void)senNSLogPage{
    //    LoginPage *page = [[LoginPage alloc]init];
    ////    page.isLogin = YES;  // 这里的登录是不能被返回的
    //    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:page] animated:YES completion:nil];
    LoginPage *usePage = [[LoginPage alloc]init];
    usePage.isLogin = YES;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:usePage] animated:YES completion:nil];
    
}
    
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView  == self.talbeView){
        return self.onlineArr.count + self.onlineDerectorArr.count;
    }
    else{
        return self.offLineArr.count + self.offLineDerectorArr.count;
    }
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.talbeView){
        if(indexPath.section < self.onlineDerectorArr.count){
            return  SectionViewHei ;
        }else{
            return  SectionViewHei + BottomeButtonhei;
        }
    }else{
        return  SectionViewHei ;
    }
    
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
    
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    EquipmentSectionView *cell ;
    NSInteger currentSection = indexPath.section;
    if(self.talbeView == tableView){
        NSInteger derectorCount = self.onlineDerectorArr.count;

        NSLog(@"探测器主机个数： %ld",derectorCount);
        if (self.onlineSectionView.count > currentSection){
            cell = self.onlineSectionView[currentSection];
            if(currentSection < self.onlineDerectorArr.count){
                [cell refrshDataWithModel: self.onlineDerectorArr[currentSection]];
            }else{
                [cell refrshDataWithModel: self.onlineArr[currentSection - derectorCount]];
            }
        }else{
            if(currentSection < self.onlineDerectorArr.count){
                cell = [self creatGetwayViewForDevice:self.onlineDerectorArr[currentSection] inTableView:self.talbeView];
            }else{
                cell = [self creatGetwayViewForDevice:self.onlineArr[currentSection - derectorCount] inTableView:self.talbeView];
            }
            cell.lastPage = self;
            cell.tag = currentSection;
            [self.onlineSectionView addObject:cell];
        }
        
        if(currentSection < self.onlineDerectorArr.count){
            [cell refrshDataWithModel: _onlineDerectorArr[currentSection]];
        }else{
            [cell refrshDataWithModel: _onlineArr[currentSection - derectorCount]];
        }
        
    }else{
        NSInteger derectorCount = self.offLineDerectorArr.count;
        if (self.offlineSectionView.count > currentSection){
            cell = self.offlineSectionView[currentSection];
            
        }else{
            if(currentSection < self.offLineDerectorArr.count){
                cell = [self creatGetwayViewForDevice:self.offLineDerectorArr[currentSection] inTableView:self.rightTableView];
            }else{
                cell = [self creatGetwayViewForDevice:self.offLineArr[currentSection - derectorCount] inTableView:self.rightTableView];
            }
            cell.lastPage = self;
            cell.tag = currentSection;
            [self.offlineSectionView addObject:cell];
        }
        if(currentSection < self.offLineDerectorArr.count){
            [cell refrshDataWithModel: _offLineDerectorArr[currentSection]];
        }else{
            [cell refrshDataWithModel: _offLineArr[currentSection - derectorCount]];
        }
    }
    
    if(!cell){
        NSLog(@"空Cell");
    }
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.talbeView){
        if(self.onlineDerectorArr.count > indexPath.section){
            DerectorDetailPage *page = [[DerectorDetailPage alloc] initWithDevcie:self.onlineDerectorArr[indexPath.section]];
            [self.navigationController pushViewController:page  animated:YES];
        }else{
            SubDeviceShowPage *subpage = [[SubDeviceShowPage alloc]init];
            subpage.model = self.onlineArr[indexPath.section];
            [self.navigationController pushViewController:subpage animated:YES];
        }
    }
}
    
    
#pragma mark - Events
// 刷新有在两种情况， 刷新tableView（设备数量有变化）  刷新 cell （仅仅是设备的信息发生改变）
- (void)refresh{
    if (self.onlineSectionView.count == self.onlineArr.count && self.offlineSectionView.count == self.offLineArr.count){ // 仅仅刷新数据就够了。
        for (EquipmentSectionView *sectionView in self.onlineSectionView) {
            [sectionView refrshDataWithModel:self.onlineArr[sectionView.tag]];
        }
        for (EquipmentSectionView *sectionView in self.offlineSectionView) {
            [sectionView refrshDataWithModel:self.offLineArr[sectionView.tag]];
        }
    }else{
        
        
        [self refrshTableView];
    }
}

// 直接刷新 tableView
- (void)refrshTableView{
    //当没有设备的时候 隐藏按钮
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.talbeView reloadData];
        [self.rightTableView reloadData];
        if(self.talbeView.mj_header.isRefreshing){
            [self.talbeView.mj_header endRefreshing];
        }
        [self stopRefrsh];
    });
}
    
- (void)deleteleView:(UIButton *)ViewDeleteButton{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:Local(DeleteTip) preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"delete") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([ViewDeleteButton.superview isKindOfClass:[EquipmentSectionView class]]){
            [(EquipmentSectionView *)ViewDeleteButton.superview deleteCenterDevice];
        }else{
            [self deleteCamer:ViewDeleteButton];
        }
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}
    
-(void)deleteCamer:(UIButton *)ViewDeleteButton{
    //    CamerDeviceShowButton *show =  [ViewDeleteButton isKindOfClass:[CamerDeviceShowButton class]]?(CamerDeviceShowButton*)ViewDeleteButton:(CamerDeviceShowButton *)ViewDeleteButton.superview;
    //    if(show.camer.camerNetIsonline){
    //        [self.onlineCamerArr removeObject:show];
    //    }else{
    //        [self.offlinCamerArr removeObject:show];
    //    }
    //    [show.camer deleteCamer];
    //    [self.talbeView reloadData];
    //    [self.rightTableView reloadData];
}
    
#pragma mark - 懒加载
    
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT)];
        _scrollView.contentSize = CGSizeMake(WIDTH*2.0, HIGHT);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}
    
    
- (UITableView *)rightTableView{
    if(!_rightTableView){
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, ScorllHeardViewHei, WIDTH, HIGHT - 64 - ScorllHeardViewHei) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
        footerView.backgroundColor = [UIColor redColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, BottomeButtonhei)];
        _rightTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        _rightTableView.backgroundColor = [UIColor clearColor];
        [_rightTableView addSubview:self.noOfflineDevcieView];
    }
    return _rightTableView;
}
    
    
- (UITableView *)talbeView{
    if(!_talbeView){
        _talbeView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScorllHeardViewHei, WIDTH, HIGHT - 64 - ScorllHeardViewHei) style:UITableViewStylePlain];
        _talbeView.delegate = self;
        _talbeView.dataSource = self;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
        footerView.backgroundColor = [UIColor redColor];
        _talbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _talbeView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, BottomeButtonhei)];
        _talbeView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        _talbeView.backgroundColor = [UIColor clearColor];
        [_talbeView addSubview:self.noOnlineDevcieView];
    }
    return _talbeView;
}
    
- (NSMutableArray *)dataArr{
    _dataArr = [[NSMutableArray alloc]init];
    for (DeviceInfoModel * obj  in self.sectionDeviceArr) {
        
        if(obj.gizDeviceDataPointArr.count){
            [_dataArr addObject:obj.gizDeviceDataPointArr];
        }
    }
    return _dataArr;
}
    
- (UIView *)noOnlineDevcieView{
    
    if(!_noOnlineDevcieView){
        _noOnlineDevcieView = [self creatNoDevcieView:Local(@"No online devices")];
        
    }
    return _noOnlineDevcieView;
}
    
-(UIView *)noOfflineDevcieView{
    if(!_noOfflineDevcieView){
        _noOfflineDevcieView = [self creatNoDevcieView:Local(@"No offline devices")];
        
    }
    return _noOfflineDevcieView;
}

- (NSMutableArray<EquipmentSectionView *>*)onlineSectionView{
    if(!_onlineSectionView){
        _onlineSectionView = [[NSMutableArray<EquipmentSectionView *> alloc] init];
    }
    
    return _onlineSectionView;
}

- (NSMutableArray<EquipmentSectionView *>*)offlineSectionView{
    if(!_offlineSectionView){
        _offlineSectionView = [[NSMutableArray<EquipmentSectionView *> alloc] init];
    }
    
    return _offlineSectionView;
}

    //是否显示 没有设备的标示
- (void)showNoOnlinDevcie{
    DLog(@"在线主机%lu",(unsigned long)_onlineArr.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noOnlineDevcieView.hidden = _onlineArr.count + _onlineDerectorArr.count;
    });
    if(!GizSupport.sharedGziSupprot.isLogined){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noOnlineDevcieView.hidden = NO;
        });
    }
}
    
- (void)showNoOfflinDevcie{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noOfflineDevcieView.hidden = _offLineArr.count + _offLineDerectorArr.count;
    });
    
    if(!GizSupport.sharedGziSupprot.isLogined){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noOfflineDevcieView.hidden = NO;
        });
        
    }
}
    
    
- (NSMutableArray *)sectionDeviceArr{
    //显示网关设备
    _sectionDeviceArr = [GizSupport sharedGziSupprot].deviceList;
    if(![GizSupport sharedGziSupprot].isLogined){
        return [[NSMutableArray alloc] init];
    }
    
    return _sectionDeviceArr;
}
    
- (NSMutableArray *)onlineArr{
    _onlineArr = [[NSMutableArray alloc]init];
    for (DeviceInfoModel *device in self.sectionDeviceArr) {
        //没有绑定的的就不显示了
        if(device.gizDevice.isBind){
            if(device.gizDevice.netStatus == GizDeviceOnline || device.gizDevice.netStatus == GizDeviceControlled){
                if(![device.gizDevice.productKey isEqualToString: XPGAppDetectorProductKey]){
                    //在线  可控的时候
                    [_onlineArr addObject:device];
                    //只要显示在列表的都绑定
                    if(!device.gizDevice.isSubscribed){
                        [device.gizDevice setSubscribe:device.gizDevice.productKey subscribed:YES];
                    }
                }
            }
        }
    }
    [self showNoOnlinDevcie];
    
    _onlineArr = [_onlineArr sortedArrayUsingComparator:^NSComparisonResult(DeviceInfoModel *  _Nonnull obj1, DeviceInfoModel *  _Nonnull obj2) {
        if(obj1.gizDevice.did > obj2.gizDevice.did)
        {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return  _onlineArr;
}
    
- (DeviceInfoModel *)currentDevice{
    
    _currentDevice = self.onlineArr.firstObject;
    return _currentDevice;
}
    
- (NSMutableArray *)offLineArr{
    _offLineArr = [[NSMutableArray alloc]init];
    for (DeviceInfoModel *device in self.sectionDeviceArr) {
        if(device.gizDevice.netStatus == GizDeviceOffline){
            //不在线  或者已经注销了的时候
            if(![device.gizDevice.productKey isEqualToString: XPGAppDetectorProductKey]){
                [_offLineArr addObject:device];
            }
        }
    }//
    [self showNoOfflinDevcie];
    
    return  _offLineArr;
}


- (NSMutableArray *)onlineDerectorArr{
    _onlineDerectorArr = [[NSMutableArray alloc]init];
    for (DeviceInfoModel *device in self.sectionDeviceArr) {
        //没有绑定的的就不显示了
        if(device.gizDevice.isBind){
            if(device.gizDevice.netStatus == GizDeviceOnline || device.gizDevice.netStatus == GizDeviceControlled){
                if([device.gizDevice.productKey isEqualToString: XPGAppDetectorProductKey]){
                    //在线  可控的时候
                    [_onlineDerectorArr addObject:device];
                    //只要显示在列表的都绑定
                    if(!device.gizDevice.isSubscribed){
                        [device.gizDevice setSubscribe:device.gizDevice.productKey subscribed:YES];
                    }
                }
            }
        }
    }
    [self showNoOnlinDevcie];
    
    return  _onlineDerectorArr;
}

- (NSMutableArray *)offLineDerectorArr{
    _offLineDerectorArr = [[NSMutableArray alloc]init];
    for (DeviceInfoModel *device in self.sectionDeviceArr) {
        if(device.gizDevice.netStatus == GizDeviceOffline){
            //不在线  或者已经注销了的时候
            if([device.gizDevice.productKey isEqualToString: XPGAppDetectorProductKey]){
                [_offLineDerectorArr addObject:device];
            }
        }
    }
    [self showNoOfflinDevcie];
    return  _offLineDerectorArr;
}



- (DeviceInfoModel *)oldModel{
    
    if(!_oldModel){
        _oldModel = self.onlineArr.firstObject;
    }
    
    //    int k = 0;
    //    for (EquipmentSectionView *view in _onlineArr) {
    //        if([_oldSecView.devcieModel.gizDevice.did isEqualToString:view.devcieModel.gizDevice.did]){
    //            _oldSecView.devcieModel = view.devcieModel;
    //            k++;
    //        }
    //    }
    //    if(k == 0){
    //        _oldSecView  = _onlineArr.firstObject;
    //    }
    //    [_oldSecView showSectionCell];
    
    return _oldModel;
}
    
    
#pragma mark - 摄像头的数据处理
- (void)getCamerData{
    
    
}
    
- (NSMutableArray *)onlineCamerArr{
    if(!_onlineCamerArr){
        _onlineCamerArr = [[NSMutableArray alloc]init];
    }
    return _onlineCamerArr;
}
    
- (NSMutableArray *)offlinCamerArr{
    if(!_offlinCamerArr){
        _offlinCamerArr = [[NSMutableArray alloc]init];
    }
    return _offlinCamerArr;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存溢出");
}
    
- (void)dealloc{
    
    [[NSNotificationCenter  defaultCenter]removeObserver:self];
    
}
    @end

