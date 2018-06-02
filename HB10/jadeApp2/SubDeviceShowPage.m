//
//  SubDeviceShowPage.m
//  JADE
//
//  Created by JD on 2017/8/4.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SubDeviceShowPage.h"
#import "DeviceInfoModel.h"
#import "SHowSubDeviceCell.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"
#import "BaseSubDevicePage.h"
#import "VideoPlayPage.h"
#import "ChooseSubDeviceType.h"
#import "AddCameraOrOtherPage.h"

#define BottomeButtonhei 60

@interface SubDeviceShowPage ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray<NSMutableDictionary *> *dataArr;  //这是一个二纬数组
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) BaseSubDevicePage *subDevicePag;

@end

@implementation SubDeviceShowPage


- (UITableView *)rightTableView{
    if(!_rightTableView){
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT - 64) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
        footerView.backgroundColor = [UIColor redColor];
        [_rightTableView registerNib:[UINib nibWithNibName:@"StateTableViewCell" bundle:nil] forCellReuseIdentifier:@"StateTableViewCell"];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, BottomeButtonhei)];
        _rightTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        _rightTableView.backgroundColor = [UIColor clearColor];
    }
    return _rightTableView;
}

- (NSMutableArray*)dataArr{
    
    // do something
    if(!_dataArr){
//        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        NSArray<JDGizSubDevice *> *subArrOne = [[NSArray alloc]initWithArray:self.model.subDevices];
        NSMutableArray<JDGizSubDevice *> *subArrTwo = [[NSMutableArray alloc]initWithArray:subArrOne];
        _dataArr = [[NSMutableArray alloc] init];
        NSString *typeName;
        NSMutableArray *alreadyArr = [NSMutableArray array];
        for (NSInteger i = subArrOne.count-1 ; i >= 0; i--) {
            JDGizSubDevice *subD = subArrOne[i];
            NSMutableArray *mutArr = [[NSMutableArray alloc]init];
            typeName = subD.subDeviceTypeName;
            if([alreadyArr containsObject:typeName]){
                continue;
            }
            for (NSInteger i = subArrTwo.count-1 ; i >= 0; i--) {
                JDGizSubDevice *subDD = subArrTwo[i];
                if([subDD.subDeviceTypeName isEqualToString:typeName]){
                    if(![mutArr containsObject:subDD]){
                        [mutArr addObject:subDD];
                        [subArrTwo removeObject:subDD];
                    }
                    if(![alreadyArr containsObject:typeName]){
                        [alreadyArr addObject:typeName];
                    }
                }
            }
            
            if(mutArr.count){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:mutArr forKey:typeName];
                [_dataArr addObject:dic];
            }
        }
//        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//        NSLog(@"time cost: %0.3f", end - start);
    }

    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotic];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArr = nil;
    [self.rightTableView reloadData];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) addNotic {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:GizSubDeviceRefrsh object:nil];
}

- (void)initData {
    [SVProgressHUD showWithStatus:Local(@"Loading")];
    [self.model getSubDeviceInfo: ^{
    }];
}


- (void)initUI {
    [self.view addSubview:self.rightTableView];
    self.title = self.model.gizDeviceName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubDevice)];
}

- (void)addSubDevice {
    DLog("开始添加自设备咯");
    if(self.model.type == GateawayType433868){
        //进入自设备选择的界面
        ChooseSubDeviceType *page = [[ChooseSubDeviceType alloc]init];
        page.currentDevie = self.model;
        [self.navigationController pushViewController:page animated:YES];
    }else{
        //自定加设备  不需要选择子设备类型
        AddCameraOrOtherPage *page = [[AddCameraOrOtherPage alloc]init];
        page.currentDevie = self.model;
        [self.navigationController pushViewController:page animated:YES];
    }
}

- (void) refreshTableView{
    _dataArr = nil;
    [self.rightTableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - tableViewdelegate
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHowSubDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHowSubDeviceCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"SHowSubDeviceCell" owner:self options:nil].firstObject;
    }
    NSString *key =  self.dataArr[indexPath.section].allKeys.firstObject;
    NSArray *arr = self.dataArr[indexPath.section][key];

    cell.subDevice = arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key =  self.dataArr[section].allKeys.firstObject;
    NSArray *arr = self.dataArr[section][key];
    return arr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return self.dataArr[section].allKeys.firstObject;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rightTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key =  self.dataArr[indexPath.section].allKeys.firstObject;
    NSArray *arr = self.dataArr[indexPath.section][key];
    JDGizSubDevice *subDevice = arr[indexPath.row];
    if(!subDevice.cameraID){
        BaseSubDevicePage *page = [[BaseSubDevicePage alloc]initWithDevice:subDevice centerDevice:self.model];
        SHowSubDeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        page.name = cell.subDeviceName.text;
        page.icon = cell.iconImage.image;
        page.currentDevice = self.model;
        
        self.subDevicePag = page;
        [self.navigationController pushViewController:page animated:YES];
    }else{ //进入视频播放的页面。
        DLog(@"进入播放页面");
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayPage *page = [[VideoPlayPage alloc] init];
            page.dModel = self.model;
            page.camera = subDevice;
            page.deviceViewPage = self;
            [self presentViewController:page animated:YES completion:nil];
        });
    }

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0;
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter]removeObserver:self];
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
