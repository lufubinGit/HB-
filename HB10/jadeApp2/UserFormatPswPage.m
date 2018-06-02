//
//  UserFormatPswPage.m
//  jadeApp2
//
//  Created by JD on 16/10/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserFormatPswPage.h"
#import "UserModifyPswPage.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import "JDAppGlobelTool.h"


#define GetTsetCode Local(@"get test code")
#define Brief Local(@"Please enter the registration and email or mobile phone number, the system will send you the verification code, fill in the mailbox or through the mobile phone to receive the verification code, complete the password reset")
#define NextButtonText Local(@"Next")
#define TestCode Local(@"input testCode")
#define PhoneNum Local(@"Plaease input your phoneNum")
#define GetTestCodeSuc Local(@"accomplish")
#define PleaseInputTestCode Local(@"Please enter the code")
#define PleaseInputPhoneNum Local(@"please enter the phoneNum")
#define PleaseInputEmail Local(@"please enter the E-mail")
#define Email Local(@"Plaease input your email")

@interface UserFormatPswPage ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phonrNumTextF;
@property (weak, nonatomic) IBOutlet UITextField *testCodeF;
@property (weak, nonatomic) IBOutlet UITextView *brief;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendCodeHei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHei;

@end

@implementation UserFormatPswPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dismissKeyBEnable = YES;
    [self initUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{

// 文字描述
    self.navigationItem.title = GetTsetCode;
    [self.getCodeButton setTitle:GetTsetCode forState:UIControlStateNormal];
    self.brief.text = Brief;
    [self.nextButton setTitle:NextButtonText forState:UIControlStateNormal];
    self.testCodeF.placeholder = TestCode;
    self.phonrNumTextF.placeholder = PhoneNum;
    if(!_isPhone){
        self.phonrNumTextF.placeholder = Email;
        self.phonrNumTextF.keyboardType = UIKeyboardTypeDefault;
    }
// 设置控件的外形
    self.sendCodeHei.constant = WIDTH/10.0;
    [self.getCodeButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPBLUECOlOR];
    [self.nextButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:APPBLUECOlOR];
    self.getCodeButton.hidden = !_isPhone;
    self.testCodeF.hidden = !_isPhone;
}


- (IBAction)getTestCode:(id)sender {
    
    if(self.phonrNumTextF.text.length){
        
        [[GizSupport sharedGziSupprot] gizGetTestCodeWithPhone:self.phonrNumTextF.text Succeed:^{
            [SVProgressHUD showSuccessWithStatus:GetTestCodeSuc];
            [self.phonrNumTextF resignFirstResponder];
            [self.testCodeF becomeFirstResponder];
            
        } failed:^(NSString *err){
            [SVProgressHUD showErrorWithStatus:Local(err)];
        }];
    }
    else{
        [SVProgressHUD showInfoWithStatus:PleaseInputPhoneNum];
    }
}


- (IBAction)next:(id)sender {
    UserModifyPswPage *page = [[UserModifyPswPage alloc] init];
    page.testCode = self.testCodeF.text;
    page.userName = self.phonrNumTextF.text;
    if(_isPhone){
        if(self.testCodeF.text.length){
            [self.navigationController pushViewController:page animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:PleaseInputTestCode];
        }
    }else{
        if(self.phonrNumTextF.text.length){
            [self.navigationController pushViewController:page animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:PleaseInputEmail];
        }
    }
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
