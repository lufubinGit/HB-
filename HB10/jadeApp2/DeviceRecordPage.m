//
//  DeviceRecordPage.m
//  jadeApp2
//
//  Created by JD on 2016/10/19.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DeviceRecordPage.h"
#import "RecordTableViewCell.h"
#import "DeviceInfoModel.h"
#import "JDDeviceHistoryRecord.h"
#import "MJRefresh.h"
#import "JDAppGlobelTool.h"
#define Records [NSString stringWithFormat:@"%@recordHistory",self.currentDevice.gizDevice.did]

@interface DeviceRecordPage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation DeviceRecordPage
{
    int _currentPage;
    NSMutableArray *_nameArr;
    NSMutableArray *_buffArr;
    MJRefreshNormalHeader* _head;
    MJRefreshAutoNormalFooter* _foot;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
    self.title = self.currentDevice.gizDeviceName;
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshData) name:FoundHistoryRecord object:nil];
    
    _currentPage = 1;
    _head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _buffArr = nil;
        [self.currentDevice getHistoryDataWithIndexPage:_currentPage];
    }];
    _head.lastUpdatedTimeLabel.textColor = APPMAINCOLOR;
    _head.stateLabel.textColor = APPMAINCOLOR;
    _head.arrowView.image = [_head.arrowView.image imageWithColor:APPMAINCOLOR];
    [_head setTitle:Local(@"MJRefreshHeaderIdleText") forState:MJRefreshStateIdle];
    [_head setTitle:Local(@"MJRefreshHeaderPullingText") forState:MJRefreshStatePulling];
    [_head setTitle:Local(@"MJRefreshHeaderRefreshingText") forState:MJRefreshStateRefreshing];
    [_head setLastUpdatedTimeKey:Local(@"MJRefreshHeaderLastTimeText")];
   
    

    self.tableView.mj_header = _head;
    
   _foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self.currentDevice getHistoryDataWithIndexPage:_currentPage];
    }];
    
    [_foot setTitle:Local(@"MJRefreshAutoFooterIdleText") forState:MJRefreshStateIdle];
    [_foot setTitle:Local(@"MJRefreshAutoFooterRefreshingText") forState:MJRefreshStateRefreshing];

    self.tableView.mj_footer = _foot;
    _foot.stateLabel.textColor = APPMAINCOLOR;
    _foot.stateLabel.textColor = APPMAINCOLOR;
}

- (void)saveRecordData:(NSArray *)arr{
    //将获取的信息保存起来
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    //创建归档辅助类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码  并保留归档时候的Key值  为一个数组
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    for (JDDeviceHistoryRecord *record in arr) {
        NSString *idKey = [[JDAppGlobelTool shareinstance] getBinaryByhex:record.IEEE];
        idKey =  [idKey stringByAppendingString:record.recordDate];
        [mutArr addObject:idKey];
        [archiver encodeObject:record forKey:idKey];
    }
    [NSString stringWithFormat:@"%@",self.currentDevice];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:Records];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //结束编码
    [archiver finishEncoding];
    //写入到沙盒
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:Records];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"历史记录归档成功");
    }
}

- (NSArray *)getRecordCacheData{

    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:Records];
    //解档
    NSMutableArray *records = [NSMutableArray array];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){ //需要先判断文件不是存在， 不然的话会崩溃
        
        NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
        //解档辅助类
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
        //解码并解档出model
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:Records];
        
        for (NSString *ieeeStr in arr) {
            JDDeviceHistoryRecord *record = [unarchiver decodeObjectForKey:ieeeStr];
            [records addObject:record];
        }
        //关闭解档
        [unarchiver finishDecoding];
    }
    return  records;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//接受到心的数据之后 进行刷新
- (void)refrshData{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    if (self.currentDevice.deviceRecords.count){
        if(_currentPage == 1){
            _buffArr = self.currentDevice.deviceRecords;
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [_buffArr addObjectsFromArray:self.currentDevice.deviceRecords];
        }
        
        [self saveRecordData:_buffArr];
        _dataArr = nil;
        [self.tableView reloadData];
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}



#pragma mark - 懒加载
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        if(!_buffArr){
            _buffArr = [[NSMutableArray alloc]initWithArray:[self getRecordCacheData]];
            if(!_buffArr.count){
                [self.tableView.mj_header beginRefreshing];
            }
        }
        _dataArr = [[NSMutableArray alloc]init];
        _nameArr = [[NSMutableArray alloc]init];
        NSString *oldDate = @"";
        for (int i = 0; i < _buffArr.count;i++) {
            JDDeviceHistoryRecord *recordA = _buffArr[i];
            //这里 如果是当前的中控设备的子设备， 那么名字就会被复制过来，不然的话就只能使用默认的设备类型名字
            for (JDGizSubDevice *device in self.currentDevice.subDevices) {
                if([device.IEEE isEqualToData:recordA.IEEE]){
                    recordA.subDeviceType = device.subDeviceType;
                    recordA.subDeviceTypeName = device.subDeviceTypeName;
                    recordA.devceiName = device.subDeviceName;
                }
            }
            //调整成按时间的二维数组
            NSString *dateStr = [recordA.recordDate substringToIndex:10];
            if([oldDate isEqualToString:dateStr]){
                NSMutableArray *arr = _dataArr.lastObject;
                [arr addObject:recordA];
                [_dataArr replaceObjectAtIndex:_dataArr.count - 1 withObject:arr];
            }else{
                int k = 0;
                int index = -1;
                for(int i = 0; i < _nameArr.count;i++){
                    if([dateStr isEqualToString:_nameArr[i]]){
                        k++;
                        index = i;
                        break;
                    }
                }
                //去重
                if(k== 0){
                    [_nameArr addObject:dateStr];
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    [arr addObject:recordA];
                    [_dataArr addObject:arr];
                    oldDate = dateStr;
                }else{
                    NSMutableArray *arr = _dataArr[index];
                    [arr addObject:recordA];
                    [_dataArr replaceObjectAtIndex:index withObject:arr];
                }
            }
        }
    }
    
    return _dataArr;
}

- (UITableView *)tableView{

    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 70;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40.0)];
    label.text = [NSString stringWithFormat:@"  %@",_nameArr[section]];
    label.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecordTableViewCell" owner:self options:nil].firstObject;
    }
    if(indexPath.row%2){
        cell.backgroundColor = APPLINECOLOR;
    }
    JDDeviceHistoryRecord *record = self.dataArr[indexPath.section][indexPath.row];
    cell.record = record;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
