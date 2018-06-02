//
//  SysSetingPage.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SysSetingPage.h"
#import "SysSetingtTableViewCell.h"
#import "UIImage+BlendingColor.h"
#import <MessageUI/MessageUI.h>
#import "FeedBackViewController.h"
#import "EquipmentPage.h"
#import "JDAppGlobelTool.h"
#import "GizSupport.h"

#define OpenNoti Local(@"Receive notifications switch")
#define ServerSetting  Local(@"Regional server settings")
#define Language  Local(@"Language")
#define ClearChace Local(@"Clear cache")
#define ShareApp Local(@"Share app")
#define EvaluationAPP Local(@"Evaluation APP")
#define FeedBack Local(@"FeedBack")
#define PageTitle Local(@"setting")



#define CloseNoticTipsAbove10 Local(@"You can set whether or not to accept the notice, If you close the notification, you will not be able to accept the push messages to the device alarm.")
//你可以在系统设置中“通知”选项中找到“JadeAPP”，进入后设置是否允许APP接受推送。如果不接受推送，您将无法获取到设备的报警的信息。


#define CloseNoticTipsBelow10 Local(@"You can find the \Iot-Alarm\" in the system settings \"notification\" option, and then enter the settings to allow the APP to accept the push. If you do not accept push, you will not be able to get information to the device alarm.")
//你可以在系统设置中“通知”选项中找到“JadeAPP”，进入后设置是否允许APP接受推送。如果不接受推送，您将无法获取到设备的报警的信息。

@interface SysSetingPage ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSArray *imageArr;

@property (nonatomic,strong) FeedBackViewController *feedVc;


@end

@implementation SysSetingPage
{
    UIView *_BGView;
    NSInteger _index;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = Local(PageTitle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView Delgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ((NSMutableArray *)self.dataArr[0]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysSetingtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysSetingtTableViewCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"SysSetingtTableViewCell" owner:self options:nil].firstObject;
    }
    [cell setCell:self.dataArr[0][indexPath.section]];
    if(indexPath.section == 0){
        cell.call = ^(BOOL ison){
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        };
    }
  
    NSArray *colors = @[RGBColor(240, 30, 30, 1),RGBColor(220, 120, 30, 1),RGBColor(30, 30, 240, 1),RGBColor(30, 240, 30, 1)];
    cell.imageView.image = [[UIImage imageNamed:self.imageArr[indexPath.section]] imageWithColor:colors[indexPath.section]];
      return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SysSetingtTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.itemName.text isEqualToString:OpenNoti] ){
        if([[UIDevice currentDevice].systemVersion integerValue] > 9){
            
            //当前系统版本如果是 10.0 及以上
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(CloseNoticTipsAbove10) preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Go set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [self.tableView reloadData];

            }]];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(CloseNoticTipsBelow10) preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Go set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTES"]];
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [self.tableView reloadData];
            }]];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }
     
    }else if([cell.itemName.text isEqualToString:ClearChace] ){
        
    }else if([cell.itemName.text isEqualToString:ShareApp] ){
        __weak typeof(self) weakSelf = self;
////      显示分享面板
//        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
////      [weakSelf ];
//            [weakSelf shareDataWithPlatform:platformType];
//
//        }];
    }else if([cell.itemName.text isEqualToString:FeedBack] ){
        
        FeedBackViewController *feedVc = [[FeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedVc animated:YES];
        self.feedVc = feedVc;
    }else if ([cell.itemName.text isEqualToString:Language]){
    
        //语言选择弹窗
        [self lauageChooseAlert];
    }
}

- (void)lauageChooseAlert{

    _BGView = [[UIView alloc]initWithFrame:self.view.bounds];
    _BGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _BGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissLauageAlert:)];
    [_BGView addGestureRecognizer:tap];
    
    CGFloat width =  WIDTH/2.0;
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    alertView.centerX = self.view.centerX;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.centerY = self.view.centerY*0.6;
    alertView.userInteractionEnabled = YES;
    alertView.layer.cornerRadius = 10.0;
    alertView.layer.masksToBounds = YES;
    alertView.tag = 99;
    CGFloat cellHei = 60;
    NSArray *languageArr = @[@"中文",@"English",@"Русский язык"];
    
    //获取当前显示的语言
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    
    for (int i = 0; i < languageArr.count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,(i+1)*cellHei-1, width-20, 1)];
        line.backgroundColor = APPLINECOLOR;
        [alertView addSubview:line];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        button.frame = CGRectMake(0, i*cellHei, width, cellHei-1);
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:APPBLUECOlOR forState:UIControlStateSelected];
        [button setTitleColor:APPGRAYBLACKCOLOR forState:UIControlStateNormal];
        [button setTitle:languageArr[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(chooseLanguage:) forControlEvents:UIControlEventTouchUpInside];
        if([currentLanguage hasPrefix:@"zh-Hans"]){
            if(i == 0){
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }else if([currentLanguage hasPrefix:@"en"]){
            if(i == 1){
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }else if([currentLanguage hasPrefix:@"ru"]){
            if(i == 2){
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
        [alertView addSubview:button];
    }

    [_BGView addSubview:alertView];
    [self.view addSubview:_BGView];
    
    //展示出来
    alertView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);//将要显示的view按照正常比例显示出来
    alertView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        alertView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
        alertView.alpha = 1.0;
    } completion:^(BOOL finished) {

    }];
}



- (void)setPushLanWithDevcie:(NSTimer*)ti{
    
    DLog(@"%ld",(long)_index);
    
    NSString* flag = @"0";
    if (_index <= 0){
        [ti invalidate];
        ti = nil;
    }
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    if([currentLanguage hasPrefix:@"zh-Hans"]){
        flag = @"0";
    }else if([currentLanguage hasPrefix:@"en"]){
        flag = @"1";
    }

    
    NSArray *deviceArr = [GizSupport sharedGziSupprot].deviceList;
    [deviceArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj2>obj1;
    }];
    
    
    NSDictionary *request = @{@"system_language":flag};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:41 device:deviceArr[_index] withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@" 请求成功 %@",datamap);
    }];
    _index--;
}

- (void)chooseLanguage:(UIButton *)button{
    
    _index =  [GizSupport sharedGziSupprot].deviceList.count-1;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setPushLanWithDevcie:) userInfo:nil repeats:YES];
    
    
    if(button.tag == 1000){ // 选择中文
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
    }else if(button.tag == 1001){ // 选择英文
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
    }else if(button.tag == 1002){ // 选择俄文
        [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:appLanguage];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:GizDeviceRefrsh object:nil];
    [self dismissLauageAlert:_BGView.gestureRecognizers.firstObject];
    [self localRefrsh];
    EquipmentPage *page = self.navigationController.viewControllers.firstObject;
    [page localLanguage];
}

- (void)dismissLauageAlert:(UITapGestureRecognizer *)tap{
    
    for (UIView *view in [tap.view subviews]) {
        if(view.tag == 99)
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
        view.alpha = 1.0;
        tap.view.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
            view.alpha = 0.0;
            tap.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [tap.view removeAllSubviews];
            [tap.view removeFromSuperview];
            [self.navigationController popoverPresentationController];
        }];
    }
}

- (void)localRefrsh{
    [self.tableView reloadData];
    self.navigationItem.title = Local(PageTitle);
    self.navigationItem.rightBarButtonItem.title = Local(@"Device");
}

#pragma mark - EmailDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultCancelled){
        [SVProgressHUD showErrorWithStatus:Local(@"Cancle")];
    }else if (result == MFMailComposeResultSaved){
        [SVProgressHUD showErrorWithStatus:Local(@"Save succeed")];
    }else if (result == MFMailComposeResultSent){
        [SVProgressHUD showErrorWithStatus:Local(@"accomplish")];
    }else{
        [SVProgressHUD showErrorWithStatus:Local(@"Failed")];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//- (void)shareDataWithPlatform:(UMSocialPlatformType )type{
//
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建图片内容对象
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@Iot-Alarm" descr:Local(@"Invite you to use") thumImage:[UIImage imageNamed:@"121212121"]];
//    //设置分享标题
//    
//    //设置分享链接
//    shareObject.webpageUrl = @"https://www.baidu.com";
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
//
//    switch (type) {
//            //新浪微博
//        case UMSocialPlatformType_Sina:
//        {
//            //创建分享消息对象
//            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//            
//            //创建图片内容对象
//            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//            //如果有缩略图，则设置缩略图
//            shareObject.thumbImage = [UIImage imageNamed:@"icon"];
//            [shareObject setShareImage:@"http://dev.umeng.com/images/tab2_1.png"];
//            
//            //分享消息对象设置分享内容对象
//            messageObject.shareObject = shareObject;
//            
//            //调用分享接口
//            [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//                if (error) {
//                    NSLog(@"************Share fail with error %@*********",error);
//                }else{
//                    NSLog(@"response data is %@",data);
//                }
//            }];
//        }
//            break;
//            //微信好友
//        case UMSocialPlatformType_WechatSession:
//        {
//            
//        }
//            break;
//            //微信朋友圈
//        case UMSocialPlatformType_WechatTimeLine:
//        {
//            
//        }
//            break;
//            //我的收藏
//        case UMSocialPlatformType_WechatFavorite:
//        {
//            
//        }
//            break;
//            //QQ 好友
//        case UMSocialPlatformType_QQ:
//        {
//            
//        }
//            break;
//            //QQ 空间
//        case UMSocialPlatformType_Qzone:
//        {
//            
//        }
//            break;
//            //非思不可
//        case UMSocialPlatformType_Facebook:
//        {
//            
//        }
//            break;
//             //推特
//        case UMSocialPlatformType_Twitter:
//        {
//            
//        }
//            break;
//            //whatsAPP
//        case UMSocialPlatformType_Whatsapp:
//        {
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
    
//}


#pragma mark - 懒加载
- (UITableView *)tableView{

    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    NSArray *arr1 = @[OpenNoti,Language];
    _dataArr = (NSMutableArray *)@[arr1];
    return _dataArr;
}

- (NSArray *)imageArr{
    if(!_imageArr){
        NSArray *arr1 = @[@"seting_Noti",
                          @"Language",
                          @"feedback",
                          @"seting_server",
                          @"seting_share"
                          ];
        _imageArr = arr1;
    }
    return _imageArr;
}
@end
