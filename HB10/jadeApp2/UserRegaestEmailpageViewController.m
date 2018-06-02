//
//  UserRegaestEmailpageViewController.m
//  jadeApp2
//
//  Created by JD on 2016/12/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserRegaestEmailpageViewController.h"
#import "UIImage+BlendingColor.h"
#import "GizSupport.h"
#import "JDAppGlobelTool.h"

@interface UserRegaestEmailpageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reguestButton;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *onePsw;
@property (weak, nonatomic) IBOutlet UITextField *twoPsw;
@property (weak, nonatomic) IBOutlet UIImageView *Bgimage;
@property (weak, nonatomic) IBOutlet UIImageView *EmailImage;
@property (weak, nonatomic) IBOutlet UIImageView *onePswImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoPswImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;

@property (weak, nonatomic) IBOutlet UIImageView *symbol;

@end

@implementation UserRegaestEmailpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUI{
    self.Bgimage.image = RepalceImage(@"login_bg");
    self.symbol.image = RepalceImage(@"NULL");
    self.dismissKeyBEnable = YES;  //开启键盘点击消失
    //添加点击事件 当点击屏幕时候 有键盘的话就消失  这里父类了方法 这里的方法不能删除
    UITapGestureRecognizer *dismissKeybord = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeyB)];
    [self.Bgimage addGestureRecognizer:dismissKeybord];
    self.Email.placeholder = Local(@"Your E-mail");
    self.onePsw.placeholder =  Local(@"Please enter the account password");
    self.twoPsw.placeholder =  Local(@"Check the password");
 
    [self.reguestButton setTitle: Local(@"Register") forState:UIControlStateNormal];
    
    //小图标改色
    self.EmailImage.image = [[UIImage imageNamed:@"log-register- Email"] imageWithColor:[UIColor whiteColor]];
    self.onePswImage.image = [[UIImage imageNamed:@"log-register- password"] imageWithColor:[UIColor whiteColor]];
    self.twoPswImage.image = [[UIImage imageNamed:@"log-register- checkpassword"] imageWithColor:[UIColor whiteColor]];
      //控件外形更改
    [self.reguestButton setLayerWidth:0
                                color:[UIColor whiteColor]
                         cornerRadius:PublicCornerRadius
                              BGColor:APPBLUECOlOR];
    self.top.constant = HIGHT/15.0;
    self.backTop.constant = HIGHT/25.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)regiest:(id)sender {
    
    [self dismisKeyB];
    if(![self.Email.text containsString:@"@"]){
        [SVProgressHUD  showInfoWithStatus:Local(@"E-mail format is incorrect")];
        return;
    }
    if(_onePsw.text.length == 0){
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter a password")];
        return;
    }

    if(![_onePsw.text isEqualToString:_twoPsw.text]){
        [SVProgressHUD showInfoWithStatus:Local(@"The two passwords are not the same")];
        return;
    }
    
   [SVProgressHUD showWithStatus:Local(@"Loading")];
    [[GizSupport sharedGziSupprot] gizRegisteWithUserName:self.Email.text password:_onePsw.text Succeed:^{
         [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failed:^(NSString *err) {
        NSLog(@"注册失败");
        [SVProgressHUD showErrorWithStatus:Local(err)];
    }];
}


@end
