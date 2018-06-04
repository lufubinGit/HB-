//
//  BaseSubDevicePage.m
//  jadeApp2
//
//  Created by JD on 2016/12/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseSubDevicePage.h"
#import "DeviceInfoModel.h"
#import "SuspensionView.h"
#import "SuspensionAction.h"
#import "UIImage+BlendingColor.h"
#import "Masonry.h"
#import "SubDeviceTableViewCell.h"
#import "SubdevicEidtNamePage.h"
#import "SubdeviceSetPage.h"
#import "JADE-Swift.h"
#import "JDAppGlobelTool.h"

#define cellHei 60
#define SectionHei 40
#define  Battery Local(@"Battery status")
#define  Online Local(@"online status")
#define  Trigger Local(@"Trigger status")
#define  Tamper Local(@"Tamper status")
#define  CenterDevice Local(@"SubDevice owner")
#define DeviceType Local(@"Subdevice type")
#define PGMID Local(@"PGM ID")
#define SrienID Local(@"Siren ID")


@interface BaseSubDevicePage ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)JDGizSubDevice *subDevice;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) SubdeviceSetPage* setPage;

@end

@implementation BaseSubDevicePage
{
    SuspensionView *_SPView;
}
- (instancetype)initWithDevice:(JDGizSubDevice *)device centerDevice:(DeviceInfoModel *)centerDevice
{
    self = [super init];
    if (self) {
        self.subDevice = device;
        self.currentDevice = centerDevice;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSuc) name:DeleteSubdeviceSuc object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshData:) name:GizSubDeviceRefrsh object:nil];

    }
    return self;
}

- (void)refrshData:(NSNotification*)not{
    
    DeviceInfoModel *amodel = not.userInfo[@"model"];
    if([self.currentDevice.gizDevice.did isEqualToString:amodel.gizDevice.did]){
        self.title = self.subDevice.subDeviceName;
        _nameLable.text = self.subDevice.subDeviceName;
        [self.setPage refrshData];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];  //页面
    [self cancleFlashes];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [_SPView removeFromSuperview];
}

//如果正处于红闪状态 则会取消该状态
- (void)cancleFlashes{
    if(self.subDevice.isARMing){
        [self.currentDevice modfySubDeviceInfoWithSubDevice:self.subDevice event:@"0" withType:ModEventCancleFlashesType];
    }
}

-(JDGizSubDevice *)subDevice{
    for (JDGizSubDevice *subD in self.currentDevice.subDevices) {
        if([_subDevice.IEEE isEqualToData:subD.IEEE]){
        
            _subDevice = subD;
        }
    }
    return _subDevice;
}


#pragma mark - initUI
- (void)initUI{

    self.title = Local(self.subDevice.subDeviceName);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[[UIImage imageNamed:@"public_more"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setImage:[[[UIImage imageNamed:@"public_more"] imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    //添加修改设备名字
    [self addModfyName];
    //添加tableView
  
    [self.view addSubview:self.tableView];
    [self addregiestButton];
}

//将tableView的底部添加注册按钮
- (void)addregiestButton{

    UIButton *regiestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regiestButton.frame = CGRectMake(0, self.tableView.bottom, WIDTH, cellHei);
    regiestButton.backgroundColor = APPBLUECOlOR;
    [regiestButton setTitle:Local(@"Registers") forState:UIControlStateNormal];
    [regiestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regiestButton addTarget:self action:@selector(regiest) forControlEvents:UIControlEventTouchUpInside];
    if(self.subDevice.subDeviceType == PGMType||self.subDevice.subDeviceType == AlarmType){
        if([self.currentDevice.gizDevice.productKey isEqualToString:@"6931177c6802488787e4af52581730b3"]){
            regiestButton.hidden = NO;
        }else{
            regiestButton.hidden = YES;
        }

    }else{
        regiestButton.hidden = YES;
    }
    [regiestButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    self.tableView.tableFooterView = regiestButton;
}

- (void)regiest{
    [self.currentDevice regiestAlarmAndPGM:self.subDevice];
    [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
}

- (UIView*)addTableSectionView{
    
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, SectionHei)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH, 20)];
    label.backgroundColor= [UIColor clearColor];
    label.textColor = APPGRAYBLACKCOLOR;
    label.font = [UIFont systemFontOfSize:13];
    label.text = Local(@"Device Information");
    [view addSubview:label];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)addModfyName{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    headView.backgroundColor = [UIColor clearColor];
    headView.userInteractionEnabled = YES;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 20)];
    titleLabel.text = Local(@"Modify the name of the subDevice");
   
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = APPGRAYBLACKCOLOR;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    
    _BgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _BgButton.frame = CGRectMake(0, 40, WIDTH, 50);
    _BgButton.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_BgButton];
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [_BgButton addSubview:_iconImage];
    _iconImage.image = _icon;
    _iconImage.backgroundColor = [UIColor clearColor];
    [_iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_BgButton.mas_centerY);
        make.width.equalTo(_BgButton.mas_height).multipliedBy(2.0/3.0);
        make.height.equalTo(_BgButton.mas_height).multipliedBy(2.0/3.0);
        make.left.equalTo(_BgButton.mas_left).with.offset(10);
    }];
    
   _nameLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [_BgButton addSubview:_nameLable];
    _nameLable.backgroundColor = [UIColor clearColor];
    _nameLable.text = _name;
    _nameLable.textColor = APPGRAYBLACKCOLOR;
    _nameLable.textAlignment = NSTextAlignmentLeft;
    [_nameLable mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_iconImage.mas_centerY);
        make.width.equalTo(_BgButton.mas_width).multipliedBy(0.6);
        make.height.equalTo(_iconImage.mas_height).multipliedBy(2.0/3.0);
        make.left.equalTo(_iconImage.mas_right).with.offset(10);
    }];
    
    UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    arrawImage.image = [UIImage imageNamed:@"Arraw"];
    [_BgButton addSubview:arrawImage];
    [arrawImage mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_iconImage.mas_centerY);
        make.width.equalTo(_BgButton.mas_height).multipliedBy(0.3);
        make.height.equalTo(_BgButton.mas_height).multipliedBy(0.3);
        make.right.equalTo(_BgButton.mas_right).with.offset(-20);
    }];

    [_BgButton setBackgroundImage:[UIImage createImageWithColor:APPLINECOLOR] forState:UIControlStateHighlighted];
    [_BgButton addTarget:self action:@selector(clickModyNameButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = headView;
}

//- (void)getSubdeviceInfo{
//
//    
//}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return cellHei;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return SectionHei;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self addTableSectionView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SubDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"SubDeviceTableViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = self.dataArr[indexPath.row];
    
    if([cell.name.text isEqualToString:Battery]){
        cell.state.text = self.subDevice.BatteryStr;
        cell.isArm = self.subDevice.batteryLow;
        
    }else if([cell.name.text isEqualToString:Online]){
        cell.state.text = self.subDevice.onlinestr;
        cell.isArm = !self.subDevice.isOnline;
        
    }else if([cell.name.text isEqualToString:Trigger]){
        cell.state.text = self.subDevice.triggerStr;
        cell.isArm = self.subDevice.trigger;

    }else if([cell.name.text isEqualToString:Tamper]){
        cell.state.text = self.subDevice.disassembleEnableStr;
        cell.isArm = self.subDevice.disassembleEnable;

    }else if([cell.name.text isEqualToString:DeviceType]){
        cell.state.text = self.subDevice.subDeviceTypeName;

    }else if([cell.name.text isEqualToString:CenterDevice]){
        cell.state.text = self.currentDevice.gizDeviceName;
    }
    else if([cell.name.text isEqualToString:PGMID]){
        cell.state.text = self.subDevice.PGMId;
    }else if([cell.name.text isEqualToString:SrienID]){
        cell.state.text = self.subDevice.SirenId;
    }
    return cell;
}

#pragma mark - event
- (void)clickModyNameButton:(UIButton *)button{
    SubdevicEidtNamePage *page = [[SubdevicEidtNamePage alloc]init];
    [self.navigationController pushViewController:page animated:YES];
    page.centerDevice = self.currentDevice;
    page.subDevcie = self.subDevice;
    NSLog(@"点击我进入了修改名字的页面");
}


- (void)deleteSuc{
    [self.currentDevice getSubDeviceInfo: ^{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
    });
}

- (void)more{
    _SPView = [[SuspensionView alloc]init];
    if(self.subDevice.subDeviceType != RemoterContorlType &&self.subDevice.subDeviceType != PGMType&&self.subDevice.subDeviceType != AlarmType&&self.subDevice.subDeviceType != DoorRingType){
        SuspensionAction *settingAction = [SuspensionAction suspensionActionWithIamge:[UIImage imageNamed:@"public_setting"]  title:Local(@"setting") handler:^(SuspensionAction *action) {
            //进入设置页面
            [self intoSetting];
        }];
        [_SPView addSuspensionWithAction:settingAction];
    }
    SuspensionAction *deleteAction = [SuspensionAction suspensionActionWithIamge:[UIImage imageNamed:@"gateway_delete"]  title:Local(@"delete device") handler:^(SuspensionAction *action) {
        [self deleteSubdevice];
    }];
    [_SPView addSuspensionWithAction:deleteAction];
    [_SPView showWithType:SuspensionViewleftTopType];
}

//进入设置界面
- (void)intoSetting{

    SubdeviceSetPage *page = [[SubdeviceSetPage alloc]initWithSubdevice:self.subDevice andCenterDevice:self.currentDevice];
    self.setPage = page;
    [self.navigationController pushViewController:page animated:YES];
}

//添加删除设备的按钮
- (void)deleteSubdevice{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:Local(@"") message:Local(@"Are you sure you want to delete the device?") preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.currentDevice deleteSubDeviceWithSubDevice:self.subDevice];
         [SVProgressHUD showWithStatus:Local(@"Loading")];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (UITableView *)tableView{

    if(!_tableView){
    
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.width = WIDTH;
        _tableView.height = HIGHT - 64;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
        switch (self.subDevice.subDeviceType) {
            case MotionSensorType:{ //人感
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            case MagnetometerType:{//门磁
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            case WaterSensorType:{//水感
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            case FireSensorType:{//烟杆
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            case GasSensorType:{//气感
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            case RemoterContorlType:{//遥控
                [_dataArr addObject:Battery];
                [_dataArr addObject:DeviceType];
                [_dataArr addObject:CenterDevice];
            }
                break;
            case PGMType:{//PGM
                    [_dataArr addObject:DeviceType];
                    [_dataArr addObject:CenterDevice];
                    [_dataArr addObject:PGMID];
                    //
                }
                break;
            case AlarmType:{//警号
                    [_dataArr addObject:DeviceType];
                    [_dataArr addObject:CenterDevice];
                    [_dataArr addObject:SrienID];
                }
                break;
            case DoorRingType:{//门铃
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
            default:{
                NSArray *arr = @[Online,Trigger,Battery,Tamper,DeviceType,CenterDevice];
                [_dataArr addObjectsFromArray:arr];
            }
                break;
        }
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
