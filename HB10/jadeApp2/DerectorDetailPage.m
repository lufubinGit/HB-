//
//  DerectorDetailPage.m
//  JADE
//
//  Created by BennyLoo on 2018/6/4.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DerectorDetailPage.h"
#import "DeviceInfoModel.h"
#import "DataPointModel.h"
#import "JDAppGlobelTool.h"
#import "GateWayNameEidtPage.h"
#import "EidtDerectorNamePage.h"
#import "SubDeviceTableViewCell.h"

#define cellHei 60
#define SectionHei 40
@interface DerectorDetailPage ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<DataPointModel *>* dataArr;
@property (nonatomic,strong) UIButton *BgButton;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *arrawImage;

@property (nonatomic,strong)UITableView *tableView;
@end
@implementation DerectorDetailPage



- (instancetype)initWithDevcie:(DeviceInfoModel *)device{
    self = [super init];
    if (self) {
        self.currentDevice = device;
        [self config];
    }
    return self;
}

- (void)addModfyName{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    headView.backgroundColor = [UIColor clearColor];
    headView.userInteractionEnabled = YES;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 20)];
    titleLabel.text = Local(@"Set derector Name");
    
    
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
    _iconImage.image = [self.currentDevice deviceIcon];
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
    _nameLable.text = self.currentDevice.gizDeviceName;
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

- (void)config{
    if(self.currentDevice.type == GateawayTypeDerector){
//        titleLabel.text = Local(@"Modify the name of the device.");
    }
}
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
    
    cell.name.text = self.dataArr[indexPath.row].dataPointName;
    cell.state.text = self.dataArr[indexPath.row].dataPointValue;
//    cell.state.text = @"State";

    return cell;
}

#pragma mark - event
- (void)clickModyNameButton:(UIButton *)button{

    EidtDerectorNamePage *page = [[EidtDerectorNamePage alloc]init];
    [self.navigationController pushViewController:page animated:YES];
    page.centerDevice = self.currentDevice;
    NSLog(@"点击我进入了修改名字的页面");
}
- (void)refreshPageWithDevice:(DeviceInfoModel *)device{
    _iconImage.image = [device deviceIcon];
    _nameLable.text = device.gizDeviceName;

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
        [_dataArr addObjectsFromArray:self.currentDevice.gizDeviceDataPointArr];
    }
    return _dataArr;
}
@end
