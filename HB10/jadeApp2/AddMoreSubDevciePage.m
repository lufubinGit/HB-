//
//  AddMoreSubDevciePage.m
//  jadeApp2
//
//  Created by JD on 2016/11/28.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AddMoreSubDevciePage.h"
#import "SearchSubDevcieAni.h"
#import "Masonry.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"
#import "UIImage+BlendingColor.h"

@interface AddMoreSubDevciePage ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AddMoreSubDevciePage
{
    SearchSubDevcieAni *_animationView;
    UILabel *_countLabel;
    UILabel *_loadLabel;
    NSTimer *_timer;
    int _count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addNotci];
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 撤销定时器  并且 将可入网子设备的数据点关闭
    [self.currentDevie closeSubDeviceSwitch];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //两种不同的添加设备的方式
    if(self.type){
        //使用透传数据进行传输
        [self.currentDevie addTypeSubDeviceWith:self.type adress:nil];
    }else{
        [self.currentDevie openSubDeviceSwitch];
    }
}

- (void)addNotci{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopEnroll) name:FoundSubDevice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshTableView:) name:FoundSubDevice object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopEnroll) name:GizGetDeviceData object:nil];

}




- (void)refrshTableView:(NSNotification *)notic {
    NSDictionary *dic = notic.userInfo;
    JDGizSubDevice *subDevice = dic[@"subDevice"];
    int k = 0;
    for (JDGizSubDevice *devcie in self.dataArr) {
        if([devcie.IEEE isEqualToData:subDevice.IEEE]){
            k++;
        }
    }
    if(k == 0){
        [self.dataArr addObject:subDevice];
    }
    if(self.dataArr.count){  //有了新设备会刷新字设备信息
        [self.currentDevie getSubDeviceInfo: ^{}];
    }
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)initUI{
    [self addAnitmationForPro];
    [self.view addSubview:self.tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_animationView.mas_bottom);
        make.centerX.equalTo(_animationView.mas_centerX);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(HIGHT - _animationView.height));
    }];
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.frame = CGRectMake(5, 20, 80, 44);
    leftNavButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 56);
    leftNavButton.titleEdgeInsets = UIEdgeInsetsMake(10, -15, 10, 0);
    leftNavButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftNavButton setImage:[UIImage imageNamed:@"Commend_back"] forState:UIControlStateNormal];
    [leftNavButton setImage:[[UIImage imageNamed:@"Commend_back"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
    [leftNavButton setTitle:Local(@"back") forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
}

- (void)stopEnroll{
    
    DLog(@"已经找打哦一个设备了");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
        [self navBack];
    });
}

- (void)navBack{
    [self.currentDevie closeSubDeviceSwitch];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//添加动画View
- (void)addAnitmationForPro{
    _animationView = [[SearchSubDevcieAni alloc]init];
    _animationView.frame = CGRectMake(0,0,WIDTH, HIGHT*0.4);
    _animationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_animationView];
    [self startAnimationWithTravel:60.0];
    
    //在动画的图谱上 添加label
    _countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = APPMAINCOLOR;
    _countLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:_countLabel];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_animationView.mas_centerX);
        make.centerY.equalTo(_animationView.mas_centerY).with.offset(-15);
        make.width.equalTo(_animationView.mas_width).with.multipliedBy(0.8);
        make.height.equalTo(@35);

    }];
    _loadLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    _loadLabel.textColor = [UIColor grayColor];
    _loadLabel.font = [UIFont systemFontOfSize:15];
    _loadLabel.text = Local(@"LOADING");
    
    [self.view addSubview:_loadLabel];
    [_loadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_animationView.mas_centerX);
        make.centerY.equalTo(_animationView.mas_centerY).with.offset(20);
        make.width.equalTo(_animationView.mas_width).with.multipliedBy(0.8);
        make.height.equalTo(@25);
    }];
}

//开启动画
- (void)startAnimationWithTravel:(CGFloat )time{

    if([[UIDevice currentDevice].systemVersion integerValue] >= 10){
        //倒计时60S
        __block int i = 0;
        [NSTimer scheduledTimerWithTimeInterval:1.0/100.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _timer = timer;
            if(i == time*100){
                [timer invalidate];
            }
            CGFloat X = ++i/time/100.0;
            NSMutableAttributedString *atuStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f %%",i/time]];
            [atuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(atuStr.length -1, 1)];
            
            _countLabel.attributedText = atuStr;
            [_animationView drawAnimationWithPro:X];
        }];
    }
    else{
        _count = 1;
        [NSTimer scheduledTimerWithTimeInterval:1.0/100.0 target:self selector:@selector(animationAT:) userInfo:nil repeats:YES];
    
    }
}

- (void)animationAT:(NSTimer *)timer{
    
    CGFloat time = 60.0;
    _timer = timer;
    if(_count == time*100){
        [timer invalidate];
    }
    CGFloat X = ++_count/time/100.0;
    NSMutableAttributedString *atuStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f %%",_count/time]];
    [atuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(atuStr.length -1, 1)];
    
    _countLabel.attributedText = atuStr;
    [_animationView drawAnimationWithPro:X];

    
}

#pragma mark - tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    label.backgroundColor = APPBACKGROUNDCOLOR;
    label.text = [NSString stringWithFormat:@"  %@:%lu",Local(@"Device found"),(unsigned long)self.dataArr.count];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    JDGizSubDevice *subDevice = self.dataArr[indexPath.row];
    cell.imageView.image = subDevice.subDeviceIcon;
    cell.textLabel.text = subDevice.subDeviceName;
    cell.imageView.frame = CGRectMake(10, 10, 60, 60);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -  懒加载
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
      
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}


- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
