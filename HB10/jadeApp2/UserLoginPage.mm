//
//  UserLoginPAge.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserLoginPage.h"
#import "UserRegistePageViewController.h"
#import "UserRegaestEmailpageViewController.h"
#import "FunSupport.h"
#import "GizSupport.h"
#import "UIView+Frame.h"
#import "CloudSaveTool.h"
#import "UserInfoModel.h"
#import "UIImage+BlendingColor.h"
#import "JDDBSupport.h"
#import "UserFormatPswPage.h"
#import "LeftSlideViewController.h"
#import "BNTextFiled.h"
#import "Masonry.h"
#import "JDAppGlobelTool.h"


#define UserName Local(@"userName"）
#define PassWord Local(@"userName"）
#define Remenber Local(@"isRemenbered"）
#define AutoLogin Local(@"isAutoLogin"）

@interface UserLoginPage () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *formatterButton;

@property (weak, nonatomic) IBOutlet UIImageView *BgimageVinew;

@property (weak, nonatomic) IBOutlet UIView *userNameView;

@property (weak, nonatomic) IBOutlet UIView *userPswView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextfiled;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *registeButton;

@property (weak, nonatomic) IBOutlet UIButton *foggotPassWordButton;

@property (weak, nonatomic) IBOutlet UIButton *obviouPassButton;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (weak, nonatomic) IBOutlet UIImageView *skipImage;
@property (weak, nonatomic) IBOutlet UIButton *skipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *symbol;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,strong) BNTextFiled *username;


@end

@implementation UserLoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.dismissKeyBEnable = YES;  //开启键盘点击消失
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI Data


- (void)initUI{
    
    self.view.backgroundColor = APPBACKGROUNDCOLOR;
    self.BgimageVinew.image = RepalceImage(@"login_bg");
    self.symbol.image = RepalceImage(@"NULL");

    //本地化语言
    [self.registeButton setTitle:Local(@"Register") forState:UIControlStateNormal];

    [self.foggotPassWordButton setTitle:Local(@"forget") forState:UIControlStateNormal];
    [self.loginButton setTitle:Local(@"Sign in") forState:UIControlStateNormal];
    self.passWordTextfiled.placeholder = Local(@"Your password");
    [self.skipLabel setTitle:Local(@"Skip Login") forState:UIControlStateNormal];
    self.passWordTextfiled.text = [[NSUserDefaults standardUserDefaults]objectForKey:jadeUserPassword];
    self.passWordTextfiled.secureTextEntry = YES;
    //控件外形设置
    // 控件 的长高比：6:1   长：屏幕宽 ＝  3:4    所以宽：屏幕宽 ＝ 1:8  半径 1/16
    [self.loginButton setLayerWidth:0 color:nil cornerRadius:WIDTH/16.0 BGColor:APPMAINCOLOR];
    [self.userNameView setLayerWidth:0 color:nil cornerRadius:WIDTH/16.0 BGColor:[UIColor whiteColor]];
    self.userNameView.layer.masksToBounds = NO;
    [self.userPswView setLayerWidth:0 color:nil cornerRadius:WIDTH/16.0 BGColor:[UIColor whiteColor]];
    self.top.constant = HIGHT/15.0;
    //跳转图标改成白色
    UIImage *image = [UIImage imageNamed:@"UNsigin"];
    self.skipImage.image = [image imageWithColor:[UIColor whiteColor]];
    
    //跳过登陆隐藏起来
    self.skipLabel.hidden = YES;
    self.skipImage.hidden = YES;
    
    
    //密码是否明文状态切换
    [self.obviouPassButton setImage:[UIImage imageNamed:@"eyes_close"] forState:UIControlStateSelected];
    [self.obviouPassButton setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateNormal];
    
    //添加点击事件 当点击屏幕时候 有键盘的话就消失
    UITapGestureRecognizer *dismissKeybord = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeyB)];
    [self.BgimageVinew addGestureRecognizer:dismissKeybord];

    //添加特殊的输入框 自带存储效果
    self.userNameTextFiled.hidden = YES;
    [self.view bringSubviewToFront:self.userNameView];
    self.username = [[BNTextFiled alloc]initRecordTextWithIdentify:@"loginUserName" frame:CGRectMake(10, 10, self.userNameView.width-20, self.userNameView.height-20) insuper:self.BgimageVinew];
    [self.userNameView addSubview: self.username];
    [self.userNameView bringSubviewToFront: self.formatterButton];
    [ self.username mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userNameView.mas_centerX);
        make.edges.equalTo(self.userNameView).width.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        
    }];
    self.username.text = [[NSUserDefaults standardUserDefaults]objectForKey:JadeUserName];
     self.username.placeholder = Local(@"Your Accout");
     self.username.textColor = APPGRAYBLACKCOLOR;
    if(self.username.inputRecordListArr.count){
        self.username.text =  self.username.inputRecordListArr.lastObject[@"accout"];
        self.passWordTextfiled.text =  self.username.inputRecordListArr.lastObject[@"psw"];
    }
    self.username.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.username.spellCheckingType = UITextSpellCheckingTypeNo;
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
     self.username.font = [UIFont systemFontOfSize:14];
    //当账号输入框有密码的时候显示 删除全部内容的按钮
     self.username.delegate = self;
    __weak UserLoginPage *weakSelf = self;
    self.username.recordCall = ^(NSDictionary * dic){
    
        weakSelf.username.text = dic[@"accout"];
        weakSelf.passWordTextfiled.text = dic[@"psw"];
    };
    
    [self.closeButton addTarget:self action:@selector(unLoginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setHidden:self.isLogin];
}

- (IBAction)fomattAccoutFormatt:(id)sender {
     self.username.text = @"";
     self.passWordTextfiled.text = @"";
}

#pragma textfiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.text.length){
        self.formatterButton.hidden = NO;
    }else{
        self.formatterButton.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length){
        self.formatterButton.hidden = NO;
    }else{
        self.formatterButton.hidden = YES;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.text.length){
        self.formatterButton.hidden = NO;
    }else{
        self.formatterButton.hidden = YES;
    }
}

#pragma mark - 触发事件

//
- (void)dismisKeyB{
    
    [self.username resignFirstResponder];
    [self.passWordTextfiled resignFirstResponder];
}


//点击事件
- (IBAction)login:(id)sender {

    [self dismisKeyB];
    if(self.username.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"Account can not be empty")];
        return;
    }
    if(self.passWordTextfiled.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"Password can not be empty")];
        return;
    }

    NSString *accout = self.username.text;
    NSString *psw = self.passWordTextfiled.text;
    [SVProgressHUD showWithStatus:Local(@"Loading")];
    [[GizSupport sharedGziSupprot] gizLoginWithUserName:accout password:psw Succeed:^{
        [GizSupport sharedGziSupprot].GizUserName = accout;
        [GizSupport sharedGziSupprot].GizUserPassword = psw;
        [GizSupport sharedGziSupprot].isLogined = YES;
        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
        [self dismissViewControllerAnimated:YES completion:^{
             [self.username saveInputContent:[GizSupport sharedGziSupprot].GizUserName psw:[GizSupport sharedGziSupprot].GizUserPassword];
        }];
    } failed:^(NSString *err){
      [SVProgressHUD showErrorWithStatus:Local(err)];
    }];
}

- (IBAction)registe:(id)sender {
    
    UserRegaestEmailpageViewController *page = [[UserRegaestEmailpageViewController alloc]init];
    [self presentViewController:page animated:YES completion:nil];

    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Select the registration type") preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Register by email") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UserRegaestEmailpageViewController *page = [[UserRegaestEmailpageViewController alloc]init];
//        [self presentViewController:page animated:YES completion:nil];
//        [alertVC dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Register by phone number") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UserRegistePageViewController *page = [[UserRegistePageViewController alloc]init];
//        [self presentViewController:page animated:YES completion:nil];
//
//        [alertVC dismissViewControllerAnimated:YES completion:nil];
//    }]];
//   
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)foggotPassWord:(id)sender {
    NSLog(@"进入密码找回的地方");
    
    UserFormatPswPage *page = [[UserFormatPswPage alloc]init];
    page.isPhone=  NO;
    
    AppDelegate *APPde = (AppDelegate*) [UIApplication sharedApplication].delegate;
    LeftSlideViewController *leftVC = (LeftSlideViewController *)APPde.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)leftVC.mainVC;
    [nav pushViewController:page animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
  
    
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Select the Recall the password type") preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Recall by registered email") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UserFormatPswPage *page = [[UserFormatPswPage alloc]init];
//        page.isPhone=  NO;
//        
//        AppDelegate *APPde = (AppDelegate*) [UIApplication sharedApplication].delegate;
//        LeftSlideViewController *leftVC = (LeftSlideViewController *)APPde.window.rootViewController;
//        UINavigationController *nav = (UINavigationController *)leftVC.mainVC;
//        [nav pushViewController:page animated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//        [alertVC dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//
//    }]];
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Recall by registered phone number") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UserFormatPswPage *page = [[UserFormatPswPage alloc]init];
//        page.isPhone=  YES;
//        
//        AppDelegate *APPde = (AppDelegate*) [UIApplication sharedApplication].delegate;
//        LeftSlideViewController *leftVC = (LeftSlideViewController *)APPde.window.rootViewController;
//        UINavigationController *nav = (UINavigationController *)leftVC.mainVC;
//        [nav pushViewController:page animated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [alertVC dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }]];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [self presentViewController:alertVC animated:YES completion:nil];
    
}
     

- (IBAction)obviouPassWord:(id)sender {
    self.passWordTextfiled.secureTextEntry = !self.passWordTextfiled.secureTextEntry;
    UIButton *but = sender;
    but.selected = self.passWordTextfiled.secureTextEntry;
}
- (IBAction)unLoginEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//其他事件



@end
