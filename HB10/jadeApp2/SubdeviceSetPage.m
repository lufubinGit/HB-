//
//  SubdeviceSetPage.m
//  jadeApp2
//
//  Created by JD on 2016/12/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SubdeviceSetPage.h"
#import "Masonry.h"
#import "SubdeviceSetingCell.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"

#define OpenCheack Local(@"Offline detection")
#define Armaway Local(@"Armaway effective")
#define Armstay Local(@"Armstay effective")
#define Disarmaway Local(@"Disarmaway effective")
#define ArmingDly Local(@"Arming delay")
#define AlarmDly Local(@"Alarm delay")
#define Cellhei 60
#define Num(A) [[NSNumber alloc]initWithBool:A]

@interface SubdeviceSetPage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *stateArr;
@property (nonatomic,strong) JDGizSubDevice *subdevice;
@property (nonatomic,strong) DeviceInfoModel *centerDevice;
@property (nonatomic,strong) NSMutableString *setStr;

@end

@implementation SubdeviceSetPage

- (instancetype)initWithSubdevice:(JDGizSubDevice *)subdevice andCenterDevice:(DeviceInfoModel*)centerDevice{
    self = [super init];
    if (self) {
        self.subdevice = subdevice;
        self.centerDevice = centerDevice;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI{
    
    [self creatHeadView];
    [self.view addSubview:self.tableView];
    
    //添加保存设置按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:Local(@"Save") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.3] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(saveSet) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


- (void)creatHeadView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    headView.backgroundColor = [UIColor clearColor];
    self.title = Local(@"Alarm settings");
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 20)];
    titleLabel.text = Local(@"Alarm settings");
    if(self.subdevice.subDeviceType == RemoterContorlType || self.subdevice.subDeviceType == FireSensorType){
        titleLabel.text = Local(@"The remote control unit can not change the settings");
    }
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = APPGRAYBLACKCOLOR;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    self.tableView.tableHeaderView = headView;
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cellhei;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubdeviceSetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubdeviceSetingCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"SubdeviceSetingCell" owner:self options:nil].firstObject;
    }
    if(self.subdevice.subDeviceType == RemoterContorlType){//遥控设备的cell是不能被点击
        cell.userInteractionEnabled = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellName.text = self.dataArr[indexPath.row];
    cell.cellSwitch.on = [self.stateArr[indexPath.row] boolValue];
    cell.cBLock = ^(BOOL switchOn){
        NSLog(@"%@",self.setStr);

        switch (indexPath.row) {
            case 0:{
                [self.setStr replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            case 1:{
                [self.setStr replaceCharactersInRange:NSMakeRange(7, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            case 2:{
                [self.setStr replaceCharactersInRange:NSMakeRange(6, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            case 3:{
                [self.setStr replaceCharactersInRange:NSMakeRange(5, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            case 4:{
                [self.setStr replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            case 5:{
                [self.setStr replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d",switchOn]];
            }
                break;
            default:
                break;
        }
        NSLog(@"%@",self.setStr);
    };
    return cell;
}

- (void)saveSet{
    [SVProgressHUD showWithStatus:Local(@"Loading")];
    [self.centerDevice modfySubDeviceInfoWithSubDevice:self.subdevice event:self.setStr withType:ModEventModSetType];
}

- (void)refrshData{

    [SVProgressHUD dismiss];
}


#pragma mark - 懒加载

- (NSMutableArray *)dataArr{

    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
        NSArray *arr = @[OpenCheack];
        if(self.subdevice.subDeviceType == MagnetometerType||self.subdevice.subDeviceType == MotionSensorType||self.subdevice.subDeviceType == WaterSensorType){
            arr = @[OpenCheack,Armaway,Armstay,Disarmaway,ArmingDly,AlarmDly];
        }
        [_dataArr addObjectsFromArray:arr];
    }
    return _dataArr;
}

- (NSMutableArray *)stateArr{
    _stateArr = [[NSMutableArray alloc]init];
    
    NSArray *arr = @[Num(self.subdevice.enableCheackOffline),Num(self.subdevice.awayArmEffective),Num(self.subdevice.stayArmEffective),Num(self.subdevice.disArmEffective),Num(self.subdevice.almDlyEnable),Num(self.subdevice.armDlyEnable)];
    [_stateArr addObjectsFromArray:arr];
    NSLog(@"%@ ---%@",arr,self.subdevice.settingStr);
    return _stateArr;
}

- (UITableView *)tableView{

    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    return _tableView;
}

- (NSMutableString *)setStr{

    if(!_setStr){
        _setStr = [[NSMutableString alloc]initWithString:self.subdevice.settingStr];
        
    }
    return _setStr;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
