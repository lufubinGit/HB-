//
//  UserModifyPswPage.m
//  jadeApp2
//
//  Created by JD on 16/10/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserModifyPswPage.h"
#import "GizSupport.h"
#import "JDAppGlobelTool.h"

#define InputNewPsw Local(@"input new")
#define NewPswOne Local(@"input newPassword")
#define NewPswTwo Local(@"check newPassword")
#define OkbuttonText Local(@"Next")
#define CheckPswError Local(@"Two passwords are not consistent")
#define PasswordLenthError Local(@"Please enter a password above six characters")

@interface UserModifyPswPage ()
@property (weak, nonatomic) IBOutlet UITextField *nePswOne;
@property (weak, nonatomic) IBOutlet UITextField *nePswTwo;
@property (weak, nonatomic) IBOutlet UIButton *Okbutton;

@end

@implementation UserModifyPswPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dismissKeyBEnable = YES;
    self.view.userInteractionEnabled = YES;
    [self initUI];
}

- (void)initUI{
  
    self.navigationItem.title = InputNewPsw;
    self.nePswOne.placeholder = NewPswOne;
    self.nePswTwo.placeholder = NewPswTwo;
    [self.Okbutton setTitle:OkbuttonText forState:UIControlStateNormal];;
    
    [self.Okbutton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPBLUECOlOR];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OK:(id)sender {
    
    if(self.nePswOne.text.length < 6){
        [SVProgressHUD showInfoWithStatus:PasswordLenthError];
        return;
    }
    if(![self.nePswOne.text isEqualToString:self.nePswTwo.text] ){
    
        [SVProgressHUD showInfoWithStatus:CheckPswError];
        return ;
    }
    
    if(self.testCode.length){
        //重置密码 手机
        [[GizSupport sharedGziSupprot] gizReplacePswWithTestCode:self.testCode userName:self.userName newPassword:self.nePswTwo.text type:GizUserPhone Succeed:^{
            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failed:^(NSString *err) {
            [SVProgressHUD showErrorWithStatus:Local(err)];
        }];
    }
    else if(self.oldPassword.length){
        //修改密码
        [[GizSupport sharedGziSupprot] gizChangePasswordWithOldPassWord:self.oldPassword  newPassword:self.nePswTwo.text Succeed:^{
            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } failed:^(NSString *err){
            [SVProgressHUD showErrorWithStatus:Local(err)];
        }];
    }else{
        //邮箱 重置密码
        [[GizSupport sharedGziSupprot] gizReplacePswWithTestCode:nil userName:self.userName newPassword:self.nePswTwo.text type:GizUserEmail Succeed:^{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Has sent a message to your mailbox, please login the mailbox to complete the reset password verification operation.") preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
            
        } failed:^(NSString *err) {
            [SVProgressHUD showErrorWithStatus:Local(err)];
        }];
    
        
    }
    
    NSLog(@" 修改完成");
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
