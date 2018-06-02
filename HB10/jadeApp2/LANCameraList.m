//
//  LANCameraList.m
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "LANCameraList.h"
#import "LANCameraListCell.h"
#import "JDAppGlobelTool.h"
#import "CameraModel.h"
//#import "HSLConfigWiFi.h"
//#import "HSLSearchDevice.h"
#import "elian.h"
#import "DeviceInfoModel.h"
#import <GWP2P/GWP2P.h>
#import "SubDeviceShowPage.h"
#import "UIImage+BlendingColor.h"
#import "StartConfirmPage.h"

#define cellHei 60.0

@interface LANCameraList ()<UITableViewDelegate,UITableViewDataSource>

//展示的tableView
@property (nonatomic,strong) UITableView *tableView;

//数据源
@property (nonatomic,strong) NSMutableArray <CameraModel*> *dataArr;
@end
@implementation LANCameraList
{
    //    HSLSearchDevice *WSDevice;
    UIActivityIndicatorView *_acTive;
    GWP2PDeviceLinker *_GWLinker;
    NSTimer *_ti;
    UILabel* _tipLabel;
    BOOL _isBined;
}
#pragma tabelView Set/Get
- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"LANCameraListCell" bundle:nil] forCellReuseIdentifier:@"LANCameraListCell"];
    }
    return  _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据创建
- (NSMutableArray<CameraModel *> *)dataArr{
    _dataArr = [[NSMutableArray alloc] init];
    NSArray<GWP2PLanDevice *> *arr = [GWP2PDeviceLinker shareInstance].lanDevices;
    for (int i = 0; i <  arr.count; i++) {
        GWP2PLanDevice *lanDevie = arr[i];
        CameraModel *aModel = [[CameraModel alloc]init];
        aModel.cameraID = lanDevie.deviceId;
        aModel.cameraName = @"IPC";
        [_dataArr addObject:aModel];
        [SVProgressHUD dismiss];
    }
    return  _dataArr;
}

- (void)initData{
    _isBined = NO;
    [[GWP2PDeviceLinker shareInstance] refreshLanDevices];//立即刷新一次局域网的信息  在1秒之后 获取局域网中的设备

    [SVProgressHUD showWithStatus:Local(@"Loading")];
    [JDAppGlobelTool.shareinstance delayTimer:4.0 doBlock:^{
        [SVProgressHUD dismiss];
    }];
    _ti = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

#pragma mark - 界面创建
- (void)initUI{
    self.title = Local(@"Add a LAN camera");
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, cellHei)];
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH, cellHei)];
    _tipLabel.numberOfLines = 0;
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:_tipLabel];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self refrshTitle];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[[UIImage imageNamed:@"JDBack"] BlendingColorWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backBtn setImage:[[UIImage imageNamed:@"JDBack"] BlendingColorWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
    
}

- (void)back{
    [_ti invalidate];
    _ti = nil;
    BOOL flag = NO;
    Class cls;
    if (!_isBined){
        cls = [StartConfirmPage class];
    }else{
        cls = [SubDeviceShowPage class];
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:cls]){
            flag = YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    if (!flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refrshTitle{
    if(_dataArr.count == 0){
        _tipLabel.text = Local(@"There is no connected camera in the LAN");
    }else{
        _tipLabel.text = Local(@"Select a camera that is not bound to bind.");
    }
}

- (void)refresh{
    [[GWP2PDeviceLinker shareInstance] refreshLanDevices];//立即刷新一次局域网的信息  在1秒之后 获取局域网中的设备
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refrshTitle];
        [self.tableView reloadData];
    });
}

#pragma mark -  tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHei;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    LANCameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LANCameraListCell"];
    [cell setCellModel:self.dataArr[indexPath.row] dModel:self.dModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bind = ^{
        [SVProgressHUD showWithStatus:Local(@"Loading")];
        [[GWP2PClient sharedClient] getDeviceWifiListWithDeviceID:weakSelf.dataArr[indexPath.row].cameraID devicePassword:[weakSelf.dModel getCameraPswWithId:weakSelf.dataArr[indexPath.row].cameraID] completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
            
            if (!self) {
                return ;
            }
            
            if(success){
                NSArray *cameraArr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(weakSelf.dModel.gizDevice.did)];
                if([cameraArr containsObject:weakSelf.dataArr[indexPath.row].cameraID]){
                    [SVProgressHUD showInfoWithStatus:Local(@"The device already exists")];  //如果已经添加了 会有提示的
                }else{
                    [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.dModel addCameraWithID:weakSelf.dataArr[indexPath.row].cameraID compelet:^{
                                _isBined = true;
                                [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
                            }];
                        });
                    } failed:^(NSString *err) {
                        
                    }];
                }
            }else{
                DLog(@"密码错误啦 让用户输入");
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Local(@"Please enter the password on the bottom of the camera") message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = Local(@"The password is 6-30 characters");
                }];
                [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(alertVC.textFields.firstObject.text.length > 0){
                         [SVProgressHUD showWithStatus:Local(@"Loading")];
                        DLog(@"%@-----%@",weakSelf.dataArr[indexPath.row].cameraID,[weakSelf.dModel getCameraPswWithId:weakSelf.dataArr[indexPath.row].cameraID]);
                        NSString *psw = alertVC.textFields.firstObject.text;
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [[GWP2PClient sharedClient] getDeviceWifiListWithDeviceID:weakSelf.dataArr[indexPath.row].cameraID devicePassword:psw completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
                            if(success){
                                [weakSelf.dModel saveCameraPswWithId:weakSelf.dataArr[indexPath.row].cameraID psw:alertVC.textFields.firstObject.text];
                                [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
                                    [weakSelf.dModel addCameraWithID:weakSelf.dataArr[indexPath.row].cameraID compelet:^{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            _isBined = true;
                                            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
                                        });
                                    }];
                                } failed:^(NSString *err) {
                                }];
                            }else{
                                [SVProgressHUD showInfoWithStatus:Local(@"wrong password")];
                            }
                        }];
                    }else{
                        [SVProgressHUD showInfoWithStatus:Local(@"Please enter a valid password")];
                    }
                }]];
                [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }]];
                [SVProgressHUD dismiss];
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //使用设备绑定对应的设备咯  但是需要检测摄像机是不是没有绑定设备
    
}
@end

