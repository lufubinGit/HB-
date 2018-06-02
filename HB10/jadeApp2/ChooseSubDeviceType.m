//
//  ChooseSubDeviceType.m
//  jadeApp2
//
//  Created by JD on 2017/3/6.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ChooseSubDeviceType.h"
#import "ChooseSubViewTypeCell.h"
#import "AddMoreSubDevciePage.h"
#import "AddPGMAndSirenPage.h"
#import "ConectionCameraPage.h"
#import "JDAppGlobelTool.h"

@interface ChooseSubDeviceType () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray<NSNumber *> *dataArr; //数据源
@end

@implementation ChooseSubDeviceType
#pragma mark - 懒加载

- (UITableView*)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    self.title = Local(@"Select the slave device type");
}

- (void)initData{
 self.dataArr = @[[NSNumber numberWithInt:MotionSensorType],[NSNumber numberWithInt:MagnetometerType],[NSNumber numberWithInt:FireSensorType],[NSNumber numberWithInt:GasSensorType],[NSNumber numberWithInt:RemoterContorlType],[NSNumber numberWithInt:DoorRingType],[NSNumber numberWithInt:WaterSensorType],[NSNumber numberWithInt:PGMType],[NSNumber numberWithInt:AlarmType],[NSNumber numberWithInt:SoSType]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseSubViewTypeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ChooseSubViewTypeCell" owner:self options:nil].firstObject;

    if(indexPath.section == 1){
        [cell setInfo:(ZoneType)[self.dataArr[indexPath.row] integerValue]];
    }else{
        [cell setInfo:CameraType];  //添加摄像头设备
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return  self.dataArr.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        ZoneType type = (ZoneType)[self.dataArr[indexPath.row] integerValue];
        if(type == PGMType || type == AlarmType){ //如果是警号和PGM将回有不同的结果
            AddPGMAndSirenPage *page = [[AddPGMAndSirenPage alloc]init];
            page.currentDevie = self.currentDevie;
            page.type =  (ZoneType)[self.dataArr[indexPath.row] integerValue];
            [self.navigationController pushViewController:page animated:YES];
        }else{
            AddMoreSubDevciePage *page = [[AddMoreSubDevciePage alloc]init];
            page.currentDevie = self.currentDevie;
            page.type =  (ZoneType)[self.dataArr[indexPath.row] integerValue];
            [self.navigationController pushViewController:page animated:YES];
        }
    }else{
        //摄像头
        ConectionCameraPage *page = [[ConectionCameraPage alloc]init];
        page.deviceModel = self.currentDevie;
        [self.navigationController pushViewController:page animated:YES];
    }
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
