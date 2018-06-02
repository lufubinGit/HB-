//
//  SetGatewayPage.m
//  jadeApp2
//
//  Created by JD on 2016/10/23.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SetGatewayPage.h"
#import "DataPointModel.h"
#import "SwitchTableViewCell.h"
#import "SliderTableViewCell.h"
#import "GizSupport.h"
#import "EquipmentTableViewCell.h"
#import "DeviceInfoModel.h"
#import "Masonry.h"
#import "SetGatewayCell.h"
#import "SetGatewayNumCell.h"
#import "UIImage+BlendingColor.h"
#import "GateWayNameEidtPage.h"
#import "UIImage+BlendingColor.h"
#import "GizSupport.h"
#import "SetGatewayArmStateCell.h"
#import "JDAppGlobelTool.h"
#import "QRCodePage.h"
#import "PushLauSet.h"


#define GetwayName Local(@"GetwayName")
#define Siren  Local(@"Whistle")
#define Alarmnumbers  Local(@"Alarm numbers")

#define PushL  Local(@"Push language")
#define EnableSubdevice  Local(@"Sub device add switch")
#define ArmDelay  Local(@"Arming delay")
#define AlermDelay  Local(@"Alarm delay")
#define SirenTime  Local(@"Alarm time length")
#define GatewayIP  Local(@"Gateway IP")
#define WifiName  Local(@"Connection on WIFI")
#define DeleteGateway Local(@"delete")
#define DeleteTip Local(@"Are you sure you want to delete the device.")
#define ArmStateShow Local(@"State")
#define MacArss Local(@"mac")
#define Pkey    Local(@"pk")

#define SrnOn @"srnOn"
#define ArmState @"armState"
#define ArmDly @"armDly"
#define AlmDly @"almDly"
#define SetTimeSrnOn @"setTimeSrnOn"
#define AP @"AP"
#define IP @"IP"
#define Num @"device_type"


@interface SetGatewayPage ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GizWifiDeviceDelegate,GizWifiSDKDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,assign) BOOL srnOn;

@end

@implementation SetGatewayPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Local(@"gateway setting");
    [self.view addSubview:self.tableView];
    [self addWaterPrintf];
    [self subDevice];
    [self addGetHardwareInfoButton];
    [self addNoti];
    [[GizSupport sharedGziSupprot] gizGetDeviceStatesWithSN:90 device:self.currentDevice callBack:^(NSDictionary * datamap) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshUI:) name:GizDeviceRefrsh object:nil];

}

- (void)refrshUI:(NSNotification *) not{
    
    NSDictionary *dic = not.userInfo;
   DeviceInfoModel* amodel = dic[@"model"];
    if([amodel.gizDevice.did isEqualToString:self.currentDevice.gizDevice.did]){
        self.currentDevice = amodel;
        [self.tableView reloadData];
    }

}

//每次进入之后  如果设备没有订阅 会事先订阅设备
- (void)subDevice{
    if(!self.currentDevice.gizDevice.isSubscribed){
        [[GizSupport sharedGziSupprot] gizDeviceLoginWithDevice:self.currentDevice Succeed:^{
            
            NSLog(@"订阅了");
        }];
    }
}

#pragma UI
//添加水印 和 底色
- (void)addWaterPrintf{
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2.0 - 21 , 10  , 36, 10)];
    imageV.image = [RepalceImage(@"NULL") imageWithColor:[UIColor grayColor]];
    [self.view addSubview:imageV];
    [self.view sendSubviewToBack:imageV];
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
}

- (UIView *)creatTableFooterView{

    
    UIView *BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70 + 20)];
    BGview.backgroundColor = APPBACKGROUNDCOLOR;
    BGview.userInteractionEnabled = YES;
    for (int i = 1,j = i; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, (j-i)*70 , WIDTH, 60);
        btn.backgroundColor = i>0?APPAMAINNAVCOLOR:APPBLUECOlOR;

        [btn setImage:i>0?[UIImage imageNamed:@"gateway_delete"]:[[UIImage imageNamed:@"share_Device"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn addTarget:self action:i>0?@selector(deleteGateway):@selector(shareDevice) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[i>0?[UIImage imageNamed:@"gateway_delete"]:[UIImage imageNamed:@"share_Device"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
        
        [btn setTitle:i>0?Local(@"delete device"):Local(@"share device") forState:UIControlStateNormal];
        
        [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [BGview addSubview:btn];
    }
    
    return BGview;
}

//添加硬件信息的按钮
- (void)addGetHardwareInfoButton{

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImage *image = [UIImage imageNamed:@"gateway_hard"];
    [button setImage:[image imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setImage:[image imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(getHardInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma events 
//添加硬件信息的点击
- (void)getHardInfo{
    [SVProgressHUD showWithStatus:Local(@"Get hardware information...")];
    
    [[GizSupport sharedGziSupprot] gizGetDeviceHardwareInfo:self.currentDevice Succeed:^{
        
        [SVProgressHUD dismiss];
    } failed:^(NSString *err) {
        [SVProgressHUD dismiss];

    }];
}

- (void)shareDevice{
    QRCodePage *qrCodePage = [[QRCodePage alloc]init];
    qrCodePage.device = self.currentDevice;
    [self.navigationController pushViewController:qrCodePage animated:YES];
}


- (void)deleteGateway{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:DeleteTip preferredStyle:UIAlertControllerStyleAlert];

    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [SVProgressHUD showWithStatus:Local(@"Loading")];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.currentDevice.gizDevice.delegate = self;
            [GizWifiSDK sharedInstance].delegate  = self;
//            [self.currentDevice.gizDevice setSubscribe:self.currentDevice.gizDevice.productKey subscribed:NO];
            
            
            [[GizWifiSDK sharedInstance] unbindDevice:[GizSupport sharedGziSupprot].GizUid token:[GizSupport sharedGziSupprot].GizToken did:self.currentDevice.gizDevice.did];
            
        });

        [alertVC dismissViewControllerAnimated:YES completion:nil];
    
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];

    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    if(!self.currentDevice.numExist && section == 3){ // 不带电话卡的时候
        return 0.1;
    }
    
    if(!self.currentDevice.setLauEnable && section == 4){ //不能设置语言的时候
        return 0.1;
    }
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 5){
        return 90;
    }
    
    if(indexPath.section == 3){
        if(!self.currentDevice.numExist){ // 不带电话卡的时候
            return 0;
        }
    }
    
    if(indexPath.section == 4){ //推送语言
        if(!self.currentDevice.setLauEnable){ // 不能设置语言的时候
            return 0;
        }
    }
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = APPBACKGROUNDCOLOR;
    return  view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            SetGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayCell"];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayCell" owner:self options:nil].firstObject;
            }
            cell.cellName.text = self.currentDevice.gizDeviceName;
            cell.cellName.textColor = APPGRAYBLACKCOLOR;
            cell.Type = JumpType;
            cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
            return cell;
        }
            break;
        case 1:
        {
            SetGatewayArmStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayArmStateCell"];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayArmStateCell" owner:self options:nil].firstObject;
            }
            cell.cellName.text = self.dataArr[indexPath.section][indexPath.row];
            cell.cellName.textColor = APPGRAYBLACKCOLOR;
            cell.Type = SegmentType;
            cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
            cell.segmentItem.selectedSegmentIndex = [self.currentDevice.gizDeviceData[ArmState] integerValue];
            cell.cellB = ^(NSInteger num){
                
                NSString *order = ArmState;
                [self.currentDevice.gizDeviceData setValue:[NSNumber numberWithInteger:num] forKey:ArmState];
                NSDictionary *request = @{order:[NSNumber numberWithInteger:num]};
                [[GizSupport sharedGziSupprot] gizSendOrderWithSN:40 device:self.currentDevice withOrder:request callBack:^(NSDictionary *datamap) {
                    NSLog(@" 请求成功 %@",datamap);
                }];

            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            SetGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayCell"];
            
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayCell" owner:self options:nil].firstObject;
            }
            
            cell.cellName.text = self.dataArr[indexPath.section][indexPath.row];
            cell.cellName.textColor = APPGRAYBLACKCOLOR;
            cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
            [cell.switchItem setOn:[self.currentDevice.gizDeviceData[SrnOn] boolValue]];
            cell.Type = SwitchType;
            cell.cellB = ^(BOOL ison){
                NSLog(@"block开启回调了 Switch 开关：%d",ison);
                [self.currentDevice.gizDeviceData setValue:[NSNumber numberWithBool:ison] forKey:SrnOn];
                if(indexPath.row == 0){
                    NSDictionary *request = @{SrnOn:[NSNumber numberWithBool:ison]};
                    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:40 device:self.currentDevice withOrder:request callBack:^(NSDictionary *datamap) {
                        NSLog(@" 请求成功 %@",datamap);
                    }];
                }
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
//            if([.gizDeviceData[Num] integerValue] == GateawayTypeOneZigbee||[self.currentDevice.gizDeviceData[Num] integerValue] == GateawayTypeOneGSMRF){
            if(self.currentDevice.numExist){
                
                SetGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayCell"];
                if(!cell){
                    cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayCell" owner:self options:nil].firstObject;
                }
                cell.cellName.text = Alarmnumbers;
                cell.cellName.textColor = APPGRAYBLACKCOLOR;
                cell.Type = JumpType;
                cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
                return cell;
            }
            return [[UITableViewCell alloc] init];
        }
            break;
        case 4:{
            if(self.currentDevice.setLauEnable){
                SetGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayCell"];
                if(!cell){
                    cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayCell" owner:self options:nil].firstObject;
                }
                cell.cellName.text = self.dataArr[indexPath.section][indexPath.row];
                cell.cellName.textColor = APPGRAYBLACKCOLOR;
                cell.Type = JumpWordType;
                cell.describle.textColor = APPBLUECOlOR;
                cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
                cell.describle.text = self.currentDevice.lau==CH?@"简体中文":@"English";
                return cell;
            }
            return [[UITableViewCell alloc] init];
        }
            break;
        case 5:
        {
            SetGatewayNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayNumCell"];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayNumCell" owner:self options:nil].firstObject;
            }
            cell.cellName.text = self.dataArr[indexPath.section][indexPath.row];
            cell.cellName.textColor = APPGRAYBLACKCOLOR;
            cell.index = indexPath.row;
            cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
            NSArray *arr = @[@1800,@300,@300];
            cell.num = [arr[indexPath.row] integerValue];
            switch (indexPath.row) {
                case 0:
                {
                    cell.numTextFiled.text = [self.currentDevice.gizDeviceData[SetTimeSrnOn] stringValue];
                }
                    break;
                case 1:
                {
                    cell.numTextFiled.text = [self.currentDevice.gizDeviceData[ArmDly] stringValue];
                }
                    break;
                case 2:
                {
                    cell.numTextFiled.text = [self.currentDevice.gizDeviceData[AlmDly] stringValue];
                }
                    break;
                default:
                    break;
            }

            cell.Type = NumType;
            cell.cellB2 = ^(NSInteger X){
                CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
                [self.tableView setContentOffset:offset animated:YES];
                
            };
            cell.cellB = ^(NSInteger num){
                NSLog(@"block开启回调了 NUm  数值：%ld",(long)num);
                
                NSString *order = nil;
                switch (indexPath.row) {
                    case 0:
                    {
                        order = @"setTimeSrnOn";
                        [self.currentDevice.gizDeviceData setValue:[NSNumber numberWithInteger:num] forKey:SetTimeSrnOn];
                    }
                        break;
                    case 1:
                    {
                        order = @"armDly";
                        [self.currentDevice.gizDeviceData setValue:[NSNumber numberWithInteger:num] forKey:ArmDly];

                    }
                        break;
                    case 2:
                    {
                        order = @"almDly";
                        [self.currentDevice.gizDeviceData setValue:[NSNumber numberWithInteger:num] forKey:AlmDly];
                    }
                        break;
                        
                    default:
                        break;
                }
                NSDictionary *request = @{order:[NSNumber numberWithInteger:num]};
                [[GizSupport sharedGziSupprot] gizSendOrderWithSN:40 device:self.currentDevice withOrder:request callBack:^(NSDictionary *datamap) {
                    printf(" 请求成功 ");
                    [[GizSupport sharedGziSupprot] gizGetDeviceStatesWithSN:666 device:self.currentDevice callBack:^(NSDictionary *data) {
                        NSLog(@"请求之后刷新,%@",data);
                    }];
                }];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 6:
        {
            SetGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetGatewayCell"];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"SetGatewayCell" owner:self options:nil].firstObject;
            }
            cell.cellName.text = self.dataArr[indexPath.section][indexPath.row];
            cell.cellName.textColor = APPGRAYBLACKCOLOR;
            cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.Type = WordType;
            if(indexPath.row<2){
                
                NSArray *arr = @[IP,AP];
                for (DataPointModel *model in self.currentDevice.gizDeviceDataPointArr) {
                    if([model.dataPointName isEqualToString:arr[indexPath.row]]){
                        cell.wordlabel.text = model.dataPointValue;
                    }
                }
            }else if(indexPath.row == 2){
                cell.wordlabel.text = self.currentDevice.gizDevice.macAddress;
                
            }else if(indexPath.row == 3){
                cell.wordlabel.text = self.currentDevice.gizDevice.productKey;
                cell.wordlabel.font = [UIFont systemFontOfSize:15];
            }
            return cell;
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    for (UITableViewCell *cell  in [tableView visibleCells]) {
        for (UITextView *text in cell.contentView.subviews) {
            if([text isKindOfClass:[UITextField class]]){
                [text resignFirstResponder];;
            }
        }
    }
    
    if(indexPath.section == 0){
        GateWayNameEidtPage *page = [[GateWayNameEidtPage alloc]init];
        page.centerDevice = self.currentDevice;
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.section == 3){
        EidtPhoneNumPage *page = [[EidtPhoneNumPage alloc]init];
        page.currentDevice = self.currentDevice;
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.section == 4){
        
        PushLauSet *page = [[PushLauSet alloc]init];
        page.currentDevice = self.currentDevice;
        [self.navigationController pushViewController:page animated:YES];

    }
}
#pragma mark - device Delegate
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did{
    
    if(result.code == GIZ_SDK_SUCCESS){
        
        [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [GizWifiSDK sharedInstance].delegate = [GizSupport sharedGziSupprot];
            });
        } failed:^(NSString *err) {
            
        }];
    }
}

- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed{
    [SVProgressHUD dismiss];
    if(result.code == GIZ_SDK_SUCCESS){
        
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    device.delegate = [GizSupport sharedGziSupprot];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  懒加载

- (DeviceInfoModel *)currentDevice{
    for (DeviceInfoModel *model in [GizSupport sharedGziSupprot].deviceList) {
        if([_currentDevice.gizDevice.did isEqualToString:model.gizDevice.did]){
            _currentDevice = model;
        }
    }
    return _currentDevice;
}

- (BOOL)srnOn{

    for (DataPointModel *model in self.currentDevice.gizDeviceDataPointArr) {
        if([model.dataPointName isEqualToString:SrnOn]){
            _srnOn = [model.dataPointValue boolValue];
        }else if ([model.dataPointName isEqualToString:ArmState]){
            
        }
    }
    return _srnOn;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self creatTableFooterView];
        _tableView.backgroundColor = APPBACKGROUNDCOLOR;
        
    }
    return _tableView;
}


- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
        //    NSLog(@"%@",self.currentDevice.gizDeviceData);
        NSArray *arr1 = @[GetwayName];
        NSArray *arr2 = @[ArmStateShow];
        NSArray *arr3 = @[Siren];
        NSArray *arr4 = @[Alarmnumbers];
        NSArray *arr5 = @[PushL];
        
        NSArray *arr6 = @[SirenTime,ArmDelay,AlermDelay];
        NSArray *arr7 = @[GatewayIP,WifiName,MacArss,Pkey];
        [_dataArr addObject:arr1];
        [_dataArr addObject:arr2];
        [_dataArr addObject:arr3];
        [_dataArr addObject:arr4];
        [_dataArr addObject:arr5];
        [_dataArr addObject:arr6];
        [_dataArr addObject:arr7];

    }
    return _dataArr;
}

- (NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [[NSMutableArray alloc]init];
        NSArray *arr1 = @[@"gateway_name"];
        NSArray *arr2 = @[@"gateway_state"];
        NSArray *arr3 = @[@"gateway_arm"];
        NSArray *arr4 = @[@"gateway_phone"];
        NSArray *arr5 = @[@"push_lau"];

        NSArray *arr6 = @[@"gateway_armtime",@"gateway_armdey",@"gateway_alermdey"];
        NSArray *arr7 = @[@"gateway_IP",@"gateway_WiFi",@"gateway_MAC",@"gateway_PK"];
       
        [_imageArr addObject:arr1];
        [_imageArr addObject:arr2];
        [_imageArr addObject:arr3];
        [_imageArr addObject:arr4];
        [_imageArr addObject:arr5];
        [_imageArr addObject:arr6];
        [_imageArr addObject:arr7];

    }
    return _imageArr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
