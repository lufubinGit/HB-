//
//  USerCenterPage.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserCenterPage.h"
#import "UserLoginPage.h"
#import "BpushSupport.h"
#import "UserCenterTableViewCell.h"
#import "UserCenterModel.h"
#import "UserFormatPswPage.h"
#import "GetOldPswPage.h"
#import "GizSupport.h"
#import "CloudSaveTool.h"
#import "UserInfoModel.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import "UIImage+BlendingColor.h"
#import "UIView_extra.h"
#import "JDAppGlobelTool.h"

#define ReplacementAccount Local(@"Replacement account")
#define FormatPassword Local(@"Format password")
#define ModifyPassword Local(@"Modify password")
#define ExitLogout Local(@"Exit login")
#define UserAccout Local(@"Acount")
#define UserPhone Local(@"User PhoneNum")
#define LogoutTips Local(@"Are you sure exit the current account?")
#define RenewAvtarLabel Local(@"  Click to replace the picture  ")

#define AvtarPath   [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserAvtar.png",[GizSupport sharedGziSupprot].GizUserName]]
#define OriBgimageHei WIDTH*2.0/3.0

@interface UserCenterPage ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userAvtar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,strong) NSMutableArray *nameArr;
@property (nonatomic,strong) NSMutableArray *briefArr;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (weak, nonatomic) IBOutlet UIImageView *BGimageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avtarTotop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgimageHei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@end



@implementation UserCenterPage
{
    UIVisualEffectView *_EffView;
    UIView *_BGview;

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = Local(@"User");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self initUI]; //ui

   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self addNavBar];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_BGview removeFromSuperview];
}

- (void)otherNewUserLog{
    if([[NSFileManager defaultManager] fileExistsAtPath:AvtarPath]){
        NSLog(@"%d",[[NSFileManager defaultManager] removeItemAtPath:AvtarPath error:nil]);
    }
    [self getAvtar];
}

#pragma mark - initUI Data

- (void)addNavBar{
    _BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    _BGview.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_BGview];
    
    //左边的按钮
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.frame = CGRectMake(5, 20, 75, 44);

    leftNavButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 55);
    leftNavButton.titleEdgeInsets = UIEdgeInsetsMake(12, -12, 12, 0);
    leftNavButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftNavButton setImage:[UIImage imageNamed:@"Commend_back"] forState:UIControlStateNormal];
    [leftNavButton setImage:[[UIImage imageNamed:@"Commend_back"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
    [leftNavButton setTitle:Local(@"Device") forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftNavButton.titleLabel.adjustsFontSizeToFitWidth = YES;

    //右边的按钮  如果是以ing登陆的状态 那么就会被隐藏了
    UIButton *rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavButton.frame = CGRectMake(_BGview.width - 64, 20, 44, 44);
    rightNavButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightNavButton setTitle:Local(@"Sign in") forState:UIControlStateNormal];
    [rightNavButton addTarget:self action:@selector(toLoginPage) forControlEvents:UIControlEventTouchUpInside];
    rightNavButton.hidden = [GizSupport sharedGziSupprot].isLogined;
    [_BGview addSubview:leftNavButton];
    [_BGview addSubview:rightNavButton];
    leftNavButton.alpha = 0;
    rightNavButton.alpha = 0;
    rightNavButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [UIView animateWithDuration:0.3 animations:^{
        leftNavButton.alpha = 1;
        rightNavButton.alpha = 1;
    }];

}

- (void)back{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI{
    
    self.avtarTotop.constant = 40/667.0*HIGHT;
    self.userAvtar.layer.cornerRadius = WIDTH/6.0;  //xib中  半径是1/3
    self.userAvtar.layer.masksToBounds = YES;
    self.userAvtar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvtar.layer.borderWidth = 5.0;
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    self.userAvtar.userInteractionEnabled = YES;

    //在背景上添加毛玻璃效果
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _EffView = [[UIVisualEffectView alloc]initWithEffect:eff];
    _EffView.frame = self.BGimageV.bounds;
    [self.BGimageV addSubview:_EffView];
    [self.BGimageV sendSubviewToBack:_EffView];
    [self getAvtar];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvtar)];
    [self.userAvtar addGestureRecognizer:tap];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tiplabel.text = RenewAvtarLabel;
    [self.tiplabel setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.tiplabel sizeToFit];
    self.tiplabel.width += 10;
    
    //设置点击进入登录页面的按钮
    [self setButtonToLoginPage];
    [self addNotice];
    
    self.bgimageHei.constant = OriBgimageHei-44;
    self.tableViewTop.constant = OriBgimageHei;
    self.BGimageV.frame = CGRectMake(0, 0, WIDTH, OriBgimageHei-44);
    _EffView.height = OriBgimageHei-44;
    self.userAvtar.centerY = (OriBgimageHei-40)/2.0;
    self.tiplabel.y =  self.userAvtar.y + self.userAvtar.height + 5;
    [self scrollViewDidScroll:self.tableView];
    
}
//添加通知
- (void)addNotice{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshTable) name:GizLoginSuc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshTable) name:GizLogOutSuc object:nil];

    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvtar) name:OtherNewUserLogin object:nil];
}

- (void)refrshTable{
    [self.tableView reloadData];
    [self getAvtar];
}

//头像处理
- (void)getAvtar{

    //  查看本地的是不是已经保存了图片
    if([[NSFileManager defaultManager] fileExistsAtPath:AvtarPath]){
        NSData *data = [NSData dataWithContentsOfFile:AvtarPath];
        NSLog(@"%@",AvtarPath);
        self.userAvtar.image = [UIImage imageWithData:data];
        self.BGimageV.image = [UIImage imageWithData:data];
    }
    
    //依然还是要同步的
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CloudSaveTool shareInstance] cloudGetUserInfoWithUseraccout:[GizSupport sharedGziSupprot].GizUserName Succeed:^(UserInfoModel *userModel) {
            //主线程中更改图片
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userAvtar.image = userModel.userAvtar;
                self.BGimageV.image = userModel.userAvtar;
                
            });
        } failed:^(NSError *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userAvtar.image = [UIImage imageNamed:@"userAvtar"];
                self.BGimageV.image = [UIImage imageNamed:@"Center_BGimage"];
                
            });
            
        }];
        
        
    });

}

- (void)dismissCap:(UITapGestureRecognizer *)tap{

    [tap.view removeFromSuperview];
}

//点击开始更改用户头像
- (void)changeAvtar{
    
    if(![GizSupport sharedGziSupprot].GizUserName){
        [SVProgressHUD showInfoWithStatus:Local(@"You need to log in before you can do this")];
        return;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Get a picture of the source") preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Preview Avatar") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //预览图片
        //CGFloat scale = 0.1;
        __block UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];  //黑色遮罩
        //添加毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectview.frame = CGRectMake(0, 0, WIDTH, HIGHT);
     
        [self.navigationController.view addSubview:bgView];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, (HIGHT-WIDTH)/2.0, WIDTH/10.0 , WIDTH/10.0)];
        imageV.image = self.userAvtar.image;
        imageV.center = CGPointMake(WIDTH/2.0, HIGHT/2);
        [bgView addSubview:imageV];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];  //黑色遮罩
            
            imageV.frame = CGRectMake(0, (HIGHT-WIDTH)/2.0, WIDTH , WIDTH);

        } completion:^(BOOL finished) {
            
        }];

        imageV.userInteractionEnabled = NO;
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCap:)];
        [bgView addGestureRecognizer:tap];
        
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Select from album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册权限
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
            //无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else{
            
            //进入相册
            // 跳转到相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [alertVc dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Camera shot") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted ||   //此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus == AVAuthorizationStatusDenied)         //用户已经明确否认了这一照片数据的应用程序访问
        {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        else{
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [alertVc dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePickerController animated:YES completion:nil];

        }
    }]];
    

    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        [alertVc dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}


- (void)setButtonToLoginPage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 55, 44);
    [button setTitle:Local(@"Sign in") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toLoginPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)toLoginPage{
    LoginPage *usePage = [[LoginPage alloc]init];
    usePage.isLogin = NO;

    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:usePage] animated:YES completion:nil];
}

#pragma mark - scorllView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat Y = scrollView.contentOffset.y;
    if(self.tableView == scrollView && Y <= 0){
        
        self.BGimageV.height = OriBgimageHei - Y;
        _EffView.height = OriBgimageHei - Y;
        self.userAvtar.centerY = (OriBgimageHei - Y)/2.0;
        self.tiplabel.y =  self.userAvtar.y + self.userAvtar.height + 5;
    }
}

#pragma mark - tableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSMutableArray *)self.dataArr[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.dataArr.count-1){
        return 0;
    }
    return 10.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterTableViewCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"UserCenterTableViewCell" owner:self options:nil].firstObject;
    }
    cell.model = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![GizSupport sharedGziSupprot].isLogined){
        [self toLoginPage];
    }
    else{
        UserCenterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell.name.text isEqualToString:FormatPassword ]){
            NSLog(@"进入密码重置的地方");
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Select the Reset Type") preferredStyle:UIAlertControllerStyleActionSheet];
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Reset the password by registered email") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UserFormatPswPage *page = [[UserFormatPswPage alloc]init];
                page.isPhone=  NO;
                [self.navigationController pushViewController:page animated:YES];
                [alertVC dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }]];
//            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Reset the password by registered phone number") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UserFormatPswPage *page = [[UserFormatPswPage alloc]init];
//                page.isPhone=  YES;
//                [self.navigationController pushViewController:page animated:YES];
//                [alertVC dismissViewControllerAnimated:YES completion:^{
//                }];
//            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else if([cell.name.text isEqualToString:ModifyPassword]){
            GetOldPswPage *page = [[GetOldPswPage alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if([cell.name.text isEqualToString:ReplacementAccount]){
            NSLog(@"切换账户");
            LoginPage *usePage = [[LoginPage alloc]init];
            usePage.isLogin = NO;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:usePage] animated:YES completion:nil];
        }else if([cell.name.text isEqualToString:ExitLogout]){
            NSLog(@"退出登录");
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:LogoutTips preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                [alertVc dismissViewControllerAnimated:YES completion:^{
                   
                }];
                [GizSupport sharedGziSupprot].isLogined = NO;
                [self toLoginPage];

                [alertVc dismissViewControllerAnimated:YES completion:nil];
                [self.tableView reloadData];
                
            }]];
            [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{}
    }
}

#pragma mark - 相机界面的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消了相机的动作  不做任何的处理
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   [SVProgressHUD showWithStatus:Local(@"Loading")];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [image imageScaleToSize:CGSizeMake(500.0, 500.0)];  //为了防止图片太大  第一：不好上传  第二：cloud 接受不了
    UserInfoModel *infoModel = [[UserInfoModel alloc]init];
    infoModel.userAvtar = image;
    infoModel.userName = [GizSupport sharedGziSupprot].GizUserName;
    infoModel.userAccout = [GizSupport sharedGziSupprot].GizUserName;
    infoModel.userPassword = [GizSupport sharedGziSupprot].GizUserPassword;

    //修改云端的信息
    [[CloudSaveTool shareInstance] cloudModifyUserInfo:infoModel succeed:^{
        [SVProgressHUD dismiss];
        self.userAvtar.image = image;
        self.BGimageV.image = image;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            //在本地保存一份
            NSData *imageData = UIImagePNGRepresentation(image);
            if([imageData writeToFile:AvtarPath atomically:YES]){
                NSLog(@"头像保存到本地成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserImage object:nil];
            }
        }];
    } failed:^(NSError * err) {
        NSLog(@"%@",err);
        [SVProgressHUD showInfoWithStatus:Local(@"failed")];
        [SVProgressHUD showInfoWithStatus:Local(@"Please login iCloud first")];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr{
        //说明  如果项目含有字符 则将箭头隐藏，空格也算在字符。  如果是空的字符，则隐藏箭头
        _dataArr = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [_dataArr addObject:[NSMutableArray array]];
        }
        for (int i = 0;i < self.nameArr.count;i++) {
            UserCenterModel *model = [[UserCenterModel alloc]init];
            model.itemName = self.nameArr[i];
            model.itemBerif = self.briefArr[i];
            model.itemImage = self.imageArr[i];
            if(i<2){
                [_dataArr[0] addObject:model];
            }else if (i>=2&&i<4){
                [_dataArr[1] addObject:model];
            }else if(i>=4){
                [_dataArr[2] addObject:model];
            }
        }
    return _dataArr;
}

- (NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr =[NSMutableArray arrayWithArray:@[@"user_Accout",@"user_phone",@"user_changepsw",@"user_reviewPsw",@"user_switchuser",@"user_Logout"]];
    }
    return _imageArr;
}


- (NSMutableArray *)briefArr{
   
    NSString *str = @"--";
    if([GizSupport sharedGziSupprot].GizUserName){
        str = [GizSupport sharedGziSupprot].GizUserName;
    }
    _briefArr = [NSMutableArray arrayWithArray:@[str,str,@"",@"",@"  ",@"  "]];
    
    return _briefArr;
}

- (NSMutableArray *)nameArr{
    if(!_nameArr){
        _nameArr = [NSMutableArray arrayWithArray:@[UserAccout,UserPhone,ModifyPassword,FormatPassword,ReplacementAccount,ExitLogout]];
    }
    return _nameArr;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendLocalNoti:(id)sender {
    [BpushSupport BpushLocalNoti];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView];
}

@end
