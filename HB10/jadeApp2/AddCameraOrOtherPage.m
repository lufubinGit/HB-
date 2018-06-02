//
//  AddCameraOrOtherPage.m
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AddCameraOrOtherPage.h"
#import "ChooseSubViewTypeCell.h"
#import "AddMoreSubDevciePage.h"
#import "JDAppGlobelTool.h"
#import "ConectionCameraPage.h"

@interface AddCameraOrOtherPage ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddCameraOrOtherPage


- (UITableView*)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT-64) style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:@"ChooseSubViewTypeCell" bundle:nil] forCellReuseIdentifier:@"ChooseSubViewTypeCell"];
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
    
}

- (void)initUI{
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    self.title = Local(@"Select the slave device type");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseSubViewTypeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChooseSubViewTypeCell"];
    
    if(indexPath.section == 1){
        [cell setInfo:UndownType];
    }else{
        [cell setInfo:CameraType];  //添加摄像头设备
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 0){
        //摄像头
        ConectionCameraPage *page = [[ConectionCameraPage alloc]init];
        page.deviceModel = self.currentDevie;
        [self.navigationController pushViewController:page animated:YES];

    }else{
        //如果是其他的则不会设置类型
        DeviceInfoModel *modelDevice = self.currentDevie;
        AddMoreSubDevciePage *page = [[AddMoreSubDevciePage alloc]init];
        page.currentDevie = modelDevice;
        [self.navigationController pushViewController:page animated:YES];
    }
}



@end
