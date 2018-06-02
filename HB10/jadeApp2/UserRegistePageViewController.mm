//
//  UserRegistePageViewController.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

//  @"账号"
//  @"密码"
//  @"确认密码"
//  @"手机号码"
//  @"请输入账号"
//  @"请输入密码"
//  @"确认密码"
//  @"输入验证码"
//  @"获取验证码"
//  @"注册"
//  @"请输入手机号码"
//  @"请输入账号"
//  @"验证码已经发送，请稍后"
//  @"请输入密码"
//  @"请输入验证码"
//  @"账号"
//注册成功




#import "UserRegistePageViewController.h"
#import "FunSupport.h"
#import "GizSupport.h"
#import "UIView+Frame.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"


@interface UserRegistePageViewController ()<GizWifiSDKDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextfiled;
@property (weak, nonatomic) IBOutlet UIImageView *BGimageView;

@property (weak, nonatomic) IBOutlet UITextField *userSecretCodeTextfiled;

@property (weak, nonatomic) IBOutlet UITextField *confirmUserSecretCode;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfiled;

@property (weak, nonatomic) IBOutlet UITextField *testCodeTextfiled;

@property (weak, nonatomic) IBOutlet UIButton *getTestCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *registeButton;

@property (weak, nonatomic) IBOutlet UIImageView *userAccoutImage;
@property (weak, nonatomic) IBOutlet UIImageView *userPswImage;
@property (weak, nonatomic) IBOutlet UIImageView *chaecPswImage;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *testCodeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;
@property (weak, nonatomic) IBOutlet UIImageView *symbol;

@end

@implementation UserRegistePageViewController
{
    NSInteger _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void)initUI{

    self.BGimageView.image = RepalceImage(@"login_bg");
    self.symbol.image = RepalceImage(@"NULL");
    self.dismissKeyBEnable = YES;  //开启键盘点击消失
    //添加点击事件 当点击屏幕时候 有键盘的话就消失  这里父类了方法 这里的方法不能删除
    UITapGestureRecognizer *dismissKeybord = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeyB)];
    [self.BGimageView addGestureRecognizer:dismissKeybord];
    self.userNameTextfiled.placeholder = Local(@"Your cell phone number");
    self.userSecretCodeTextfiled.placeholder =  Local(@"Please enter the account password");
    self.confirmUserSecretCode.placeholder =  Local(@"Check the password");
    self.testCodeTextfiled.placeholder =  Local(@"Input code");
    [self.testCodeTextfiled sizeToFit];
    [self.getTestCodeButton setTitle: Local(@"Send code") forState:UIControlStateNormal];
    [self.registeButton setTitle: Local(@"Register") forState:UIControlStateNormal];
    
    //小图标改色
    self.userAccoutImage.image = [[UIImage imageNamed:@"log-register- cellphone"] imageWithColor:[UIColor whiteColor]];
    self.userPswImage.image = [[UIImage imageNamed:@"log-register- password"] imageWithColor:[UIColor whiteColor]];
    self.chaecPswImage.image = [[UIImage imageNamed:@"log-register- checkpassword"] imageWithColor:[UIColor whiteColor]];
    self.userPhoneImage.image = [[UIImage imageNamed:@"log-register- cellphone"] imageWithColor:[UIColor whiteColor]];
    self.testCodeImage.image = [[UIImage imageNamed:@"log-register- testCode"] imageWithColor:[UIColor whiteColor]];
    
    //控件外形更改
    [self.registeButton setLayerWidth:0.0
                                color:[UIColor whiteColor]
                         cornerRadius:PublicCornerRadius
                              BGColor:APPBLUECOlOR];
    [self.getTestCodeButton setLayerWidth:0.0
                                color:[UIColor whiteColor]
                         cornerRadius:PublicCornerRadius
                              BGColor:APPBLUECOlOR];
    self.top.constant = HIGHT/15.0;
    self.backTop.constant = HIGHT/25.0;
}


#pragma mark - 触发事件

//获取验证码
- (IBAction)getTestCode:(id)sender {

    [self dismisKeyB];

    //获取验证码
    if(self.userNameTextfiled.text.length > 0){
         [SVProgressHUD showWithStatus:Local(@"Loading")];
        [[GizSupport sharedGziSupprot]gizGetTestCodeWithPhone:self.userNameTextfiled.text Succeed:^{
            [SVProgressHUD showSuccessWithStatus: Local(@"accomplish")];
            [self addTimerDecrease];
        } failed:^(NSString *err){
            
            NSLog(@"%@ ",err);
            [SVProgressHUD showErrorWithStatus:Local(err)];
        }];
    }else{
    
        [SVProgressHUD showInfoWithStatus:Local(@"phonNnumber can not be empty")];
    }
}

//手机号码注册  目前只 支持手机号注册
- (IBAction)registe:(id)sender {
    
    [self dismisKeyB];
    //纯机智云接口
    if(self.userNameTextfiled.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"phonNnumber can not be empty")];
        return;
    }
    
    if(self.userSecretCodeTextfiled.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter a password")];
        return;
    }
    if(self.testCodeTextfiled.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter verification code")];
        return;
    }
    if(![self.userSecretCodeTextfiled.text isEqualToString:self.confirmUserSecretCode.text]){
        [SVProgressHUD showInfoWithStatus:Local(@"The two passwords are not the same")];
        return;
    }
    
   [SVProgressHUD showWithStatus:Local(@"Loading")];
    [[GizSupport sharedGziSupprot] gizregisterWithPhone:self.userNameTextfiled.text testCode:self.testCodeTextfiled.text password:self.userSecretCodeTextfiled.text Succeed:^{
        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
        
    } failed:^(NSString *err){
        NSLog(@"%@",err);
        [SVProgressHUD showErrorWithStatus:Local(err)];

    }];

}

//获取验证码上的时间倒计时开启
- (void)addTimerDecrease{
    _timer = 120;
    [self.getTestCodeButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1]];
    self.getTestCodeButton.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(testCodeTimer:) userInfo:nil repeats:YES];
}

- (void)testCodeTimer:(NSTimer *)timer
{
    NSString *waitStr = Local(@"Wait");
    [self.getTestCodeButton setTitle:[NSString stringWithFormat:@"%@%ld S",waitStr,(long)--_timer] forState:UIControlStateNormal];
    if(_timer <= 0){
        [timer invalidate];
        [self.getTestCodeButton setBackgroundColor:APPBLUECOlOR];
        self.getTestCodeButton.enabled = YES;
        [self.getTestCodeButton setTitle: Local(@"Send code") forState:UIControlStateNormal];
    }
}

- (IBAction)cancleButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
