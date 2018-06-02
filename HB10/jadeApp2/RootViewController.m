//
//  RootViewController.m
//  jadeApp2
//
//  Created by JD on 16/10/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "EquipmentPage.h"
#import "BaseNavVc.h"
#import "JDAppGlobelTool.h"
#import "RootViewControllerTableViewCell.h"
#import "UIImage+BlendingColor.h"
#import "USerCenterPage.h"
#import "UMFeedback.h"
#import "SysSetingPage.h"
#import "AboutPage.h"
#import "JDWebViewController.h"
#import "JDNetWorkTool.h"
#import "WeatherModel.h"
#import "JDNetWorkTool.h"
#import "GizSupport.h"
#import "CloudSaveTool.h"
#import "UserInfoModel.h"
#import "JDAppGlobelTool.h"




#define UserCenter Local(@"UserCenter")
#define Setting Local(@"setting")
#define About Local(@"About")
#define ProductIntroduce Local(@"Product introduce")
#define FeedBack Local(@"Feed Back")
#define Other Local(@"Other")

#define AvtarPath   [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserAvtar.png",[GizSupport sharedGziSupprot].GizUserName]]

#define  cellHei  60
#define  weatherViewHei 50
#define  WeatherSublabelFont 13
#define  TableViewHeardHei  HIGHT/3.5

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong,nullable) UINavigationController *nav;
@property(nonatomic,strong,nullable) EquipmentPage *equipage;
@property(nonatomic,strong,nullable) NSMutableArray *dataArr;
@property(nonatomic,strong,nullable) UIView *weatherView;
@property(nonatomic,strong) UIImageView *imageV;

@property(nonatomic,strong,nullable) NSArray *imageArr;

@end

@implementation RootViewController
{
    UILabel *_label;
    UserInfoModel *_Umodel;
}
- (RootViewController *)initwithEquipage:(EquipmentPage *)vc
{
    RootViewController *rootVc = [[RootViewController alloc]init];
    rootVc.equipage = vc;
    return rootVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshHeardView) name:GizLoginSuc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshHeardView) name:ChangeUserImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshHeardView) name:GizLogOutSuc object:nil];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self refrshHeardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initUI
- (void)initUI{
    self.nav = self.equipage.navigationController;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftbackiamge"]];
    imageV.frame = self.view.bounds;
    [self.view addSubview:imageV];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];

    [self setATableHeardView];
}


/**
 * @brief  获取当前国内的天气
 *
 * @param
 *
 * @return
 
 */
- (void)getCurrentWeather{
   [[JDNetWorkTool shareInstance] JDGetWeatherAtCurrentCitySuc:^(id model) {
       [self setWeatherViewWithModel:model];
   } failed:^(id err) {
       
   }];
}

/**
 * @brief  设置一个天气展示信息在tableView的下方
 *
 * @param
 *
 * @return UIview
 
 */

- (void)setWeatherViewWithModel:(WeatherModel*)model{

//    _weatherView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - weatherViewHei, WIDTH, weatherViewHei)];
    if(model.city.length){
        _weatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, weatherViewHei)];
        
        _weatherView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        UILabel *cityLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 0,0, 30)];
        cityLabel.font = [UIFont systemFontOfSize:WeatherSublabelFont];
        cityLabel.text = model.city;
        [cityLabel sizeToFit];
        cityLabel.textColor = [UIColor whiteColor];
        cityLabel.y = (_weatherView.height - cityLabel.height)/2.0;
        
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.x + cityLabel.width + 15, cityLabel.y, 0, 0)];
        statusLabel.font =  [UIFont systemFontOfSize:WeatherSublabelFont];
        statusLabel.text = [NSString stringWithFormat:@"%@/%@",model.status1,model.status2];
        statusLabel.textColor = [UIColor whiteColor];
        [statusLabel sizeToFit];
        
        UILabel *temLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.x + statusLabel.width + 15, statusLabel.y, 0, 0)];
        temLabel.font =  [UIFont systemFontOfSize:WeatherSublabelFont];
        temLabel.text = [NSString stringWithFormat:@"%@-%@℃",model.temperature2,model.temperature1];
        temLabel.textColor = [UIColor whiteColor];
        
        [temLabel sizeToFit];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _weatherView.height*0.6, _weatherView.height*0.6)];
        imageV.centerY = _weatherView.centerY;
        imageV.x = temLabel.x + temLabel.width + 15;
        imageV.image = model.wetherImage;
        
        [_weatherView addSubview:cityLabel];
        [_weatherView addSubview:statusLabel];
        [_weatherView addSubview:temLabel];
        [_weatherView addSubview:imageV];
        self.tableView.tableFooterView = _weatherView;
    }
}

- (void)getAvtar{
    //头像的获取
    if([GizSupport sharedGziSupprot].GizUserName){
        //先从本地获取
        if([[NSFileManager defaultManager] fileExistsAtPath:AvtarPath]){
            _imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:AvtarPath]];
              NSLog(@"%@",AvtarPath);
        }
        //头像需要从cloud获取
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[CloudSaveTool shareInstance] cloudGetUserInfoWithUseraccout:[GizSupport sharedGziSupprot].GizUserName Succeed:^(UserInfoModel *userModel) {
                NSLog(@"云端获取到账户 %@",userModel.userAccout);
                _Umodel = userModel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _imageV.image = userModel.userAvtar;
                });
            } failed:^(NSError *err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _imageV.image = [UIImage imageNamed:@"userAvtar"];
                });
            }];
        });
    }else{
        _imageV.image = [UIImage imageNamed:@"userAvtar"];
        
    }
}

- (void)setATableHeardView{
    
    // 添加 头像 和 用户的帐号   设置按钮  等等
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, TableViewHeardHei)];
    heardView.backgroundColor = [UIColor clearColor];
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, TableViewHeardHei*0.6, TableViewHeardHei*0.3,TableViewHeardHei*0.3)];
    [_imageV setLayerWidth:2 color:[UIColor whiteColor] cornerRadius:_imageV.width/2.0 BGColor:nil];

    _label = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.x + _imageV.width +10 , 0, WIDTH - _imageV.width-10, 60)];
    _label.centerY = _imageV.centerY;
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.font = [UIFont systemFontOfSize:15];
    _label.centerY = _imageV.centerY;
    
    [heardView addSubview:_imageV];
    [heardView addSubview:_label];
    
    heardView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoUserCenter)];
    _imageV.userInteractionEnabled = YES;
    [_imageV addGestureRecognizer:tap];
    
    [self refrshHeardView];
    
    self.tableView.tableHeaderView = heardView;
}

- (void)refrshHeardView{

    [self getAvtar];
    
    _label.text = [GizSupport sharedGziSupprot].GizUserName;
    if(!_label.text.length){
        _label.text = Local(@"No user");
    }
 
}


- (void)intoUserCenter{

    [[NSNotificationCenter defaultCenter] postNotificationName:RootNavMenuHiden object:nil];
    [self.equipage navPushToVc:[[UserCenterPage alloc]init]];
}

#pragma mark - tableView的代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

 

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RootViewControllerTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"RootViewControllerTableViewCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"RootViewControllerTableViewCell" owner:self options:nil].firstObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.rootMenuName.text = self.dataArr[indexPath.row];
    cell.rootMenuName.font = [UIFont systemFontOfSize:20];
    cell.rootMenuName.textColor = [UIColor whiteColor];
    UIImage *image1 = [UIImage imageNamed:self.imageArr[indexPath.row]];
    UIImage *image2 = [UIImage imageNamed:@"right"];
    cell.rootMenuIcon.image = [image1 imageWithColor:[UIColor whiteColor]];
    cell.arraw.image = [image2 imageWithColor:[UIColor whiteColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return cellHei;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:RootNavMenuHiden object:nil];
    RootViewControllerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellName = cell.rootMenuName.text;
    if([cellName isEqualToString:UserCenter]){
    [self.equipage navPushToVc:[[UserCenterPage alloc]init]];
    }else if ([cellName isEqualToString:Setting]){
        SysSetingPage *page = [[SysSetingPage alloc]init];
        [self.equipage navPushToVc:page];
        
    }else if ([cellName isEqualToString:ProductIntroduce]){
        NSLog(@"进入产品介绍页面");
//        ProductIntroducePage *page = [[ProductIntroducePage alloc]init];
        [self.equipage navPushToVc:[[JDWebViewController alloc]initWithURLString:CompanyUrl]];

    }else if ([cellName isEqualToString:FeedBack]){
        [self.equipage setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        NSLog(@"反馈");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
   
    [self.equipage presentViewController: [UMFeedback feedbackModalViewController] animated:YES completion:nil];
        
    }else if ([cellName isEqualToString:About]){
        [self.equipage navPushToVc:[[AboutPage alloc]init]];
    }else if ([cellName isEqualToString:Other]){
        NSLog(@"有%@页面遗漏哦",cellName);
    }else{
        NSLog(@"有%@页面遗漏哦",cellName);
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, self.view.height - weatherViewHei-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]);
    
    NSLog(@"%@",[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(@"UserCenter") value:@"" table:nil]);
    
    _dataArr = (NSMutableArray *)@[UserCenter,Setting,About];
    return _dataArr;
}

- (NSArray *)imageArr{

    if(!_imageArr){
        _imageArr = @[@"userCenter",
                      @"setting",
                      @"ProductProduce",
                      @"feedback",
                      @"about",
                      @"function",
                      @"right"
                      ];
    }
    return _imageArr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
