//
//  GetOldPswPage.m
//  jadeApp2
//
//  Created by JD on 16/10/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "GetOldPswPage.h"
#import "UserModifyPswPage.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"
#define CurrentPsw Local(@"CurrentPassword")
#define Brief Local(@"You are modifying the password, modify the password need to line the current password authentication, after the completion of the input, click on the next step.")
#define InputOldPswFText Local(@"Please input current password")
#define NextButtonText Local(@"Next")
#define OldPswError Local(@"The original password is wrong, if you forget the password, you can use the phone to reset the password.")

@interface GetOldPswPage ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextView *brief;
@property (weak, nonatomic) IBOutlet UITextField *oldPswTextF;

@end

@implementation GetOldPswPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self initUI];
}

- (void)initUI{

    self.dismissKeyBEnable = YES;
    self.navigationItem.title = CurrentPsw;
    self.brief.text = Brief;
    self.oldPswTextF.placeholder = InputOldPswFText;
    [self.nextButton setTitle:NextButtonText forState:UIControlStateNormal];
    [self.nextButton setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor: APPBLUECOlOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)next:(id)sender {
    
    if([self.oldPswTextF.text isEqualToString:[GizSupport sharedGziSupprot].GizUserPassword]){
        UserModifyPswPage *page = [[UserModifyPswPage alloc]init];
        page.oldPassword = self.oldPswTextF.text;
        [self.navigationController pushViewController:page animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:OldPswError];
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
