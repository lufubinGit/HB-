//
//
//  jadeApp2
//
//  Created by JD on 2016/11/17.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UnbindfViewController.h"
#import "Masonry.h"
#import "DeviceInfoModel.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import "UnbindTableViewCell.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"


#define buttonHei  60

#define Bindbutton @"Bind"
#define BindAllButton  @"BindAll"
#define ViewTitle @"Unbound device"



@interface UnbindfViewController ()<UITableViewDelegate,UITableViewDataSource,GizWifiSDKDelegate,GizWifiDeviceDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UnbindfViewController{
    NSMutableArray *_buttonArr;
    NSMutableArray *_allDevice;
    GizWifiDevice *_buffDevice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Local(ViewTitle);
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    
    [self getDeviceArr];
    [self.view  addSubview:self.tableView];
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
    NSString *str = nil;
    if(_allDevice.count){
       str = Local(@"If the device needs to be bound, power off the device and restart the device after the device is started for five minutes.");
    }else{
       str = Local(@"There are currently no unbound devices.");
    }
    [self creartTableHeadViewWith:str];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creartTableHeadViewWith:(NSString *)title{

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:titleLabel];
    self.tableView.tableHeaderView = headView;
}

//获取tableVIew展示的数据信息
- (void)getDeviceArr{

    _allDevice = [[NSMutableArray alloc]init];
    for (DeviceInfoModel *device in [GizSupport sharedGziSupprot].deviceList) {
        
        NSLog(@" %@ --- %d --- %d",device.gizDeviceName ,device.gizDevice.isSubscribed,device.gizDevice.isBind);
        
        //在线没有绑定的设备
        if(!device.gizDevice.isBind && device.gizDevice.netStatus == GizDeviceOnline ){
            [_allDevice addObject:device];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (UITableView *)tableView{

    if(!_tableView){
    
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = APPBACKGROUNDCOLOR;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return  _tableView;
}


#pragma mark - delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
//    if(_allDevice.count == 0){
//        return 1;
//    }
    return _allDevice.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UnbindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnbindTableViewCell"];
    if(!cell){
    
        cell = [[NSBundle mainBundle] loadNibNamed:@"UnbindTableViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeviceInfoModel *model = _allDevice[indexPath.section];
    cell.model = model;
    model.gizDevice.delegate = self;
    
    cell.callback =  ^{
        [model.gizDevice setSubscribe:model.gizDevice.productKey subscribed:YES];
    };
    
    
    return cell;
}



#pragma mark - deviceDelegate
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed{
    [SVProgressHUD showWithStatus:Local(@"Loading")];
    [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
        if(result.code == GIZ_SDK_SUCCESS){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self back];
            });
            
        }
    } failed:^(NSString *err) {
    }];
    device.delegate = [GizSupport sharedGziSupprot];
}


- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary *)dataMap withSN:(NSNumber *)sn{
    if(result.code == GIZ_SDK_SUCCESS){
    
        [[GizSupport sharedGziSupprot] device:device didReceiveData:result data:dataMap withSN:sn];
        NSLog(@"入网成功");
    }
}




@end
