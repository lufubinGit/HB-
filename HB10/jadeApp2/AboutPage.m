//
//  AboutPage.m
//  jadeApp2
//
//  Created by JD on 2016/10/17.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AboutPage.h"
#import "PrivacyPage.h"
#import "APPVersionViewController.h"
#import "JDAppGlobelTool.h"


#define CellHei  60
#define AboutTitlle @"About"
#define FooterInSectionHei 20

@interface AboutPage ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AboutPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{

    self.title = Local(AboutTitlle);
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableVIew delegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = Local(self.dataArr[indexPath.section]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section != 0){
        return FooterInSectionHei;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHei;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
    //隐私政策
        [self.navigationController pushViewController:[[PrivacyPage alloc]init] animated:YES];
    }else if(indexPath.section == 1){
    //版本信息
         [self.navigationController pushViewController:[[APPVersionViewController alloc]init] animated:YES];
    }
    
}



#pragma mark - 懒加载
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -8, 0, -8);
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, FooterInSectionHei)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if(!_dataArr){
    
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[Local(@"Privacy Policy"),Local(@"Version Information")];
        [_dataArr addObjectsFromArray:arr];
    }
    return _dataArr;
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
