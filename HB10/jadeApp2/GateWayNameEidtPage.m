//
//  GateWayNameEidtPage.m
//  jadeApp2
//
//  Created by JD on 2016/11/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "GateWayNameEidtPage.h"
#import "UIView+Frame.h"
#import "GizSupport.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"

#define nameTextPlace Local(@"  Set Gateway Name")
#define BriefLabelText Local(@"Rename the gateway, and set up unused device names to identify the different devices.")
#define SaveButtonTitle Local(@"Save")
#define NavTitle Local(@"Set Gateway Name")

@interface GateWayNameEidtPage ()


@end

@implementation GateWayNameEidtPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dismissKeyBEnable = YES;
    [self initUI];
    
}

#pragma mark - UI
- (void)initUI{
    self.title = NavTitle;
    self.nameText.placeholder = nameTextPlace;
    self.brief.text = BriefLabelText;
    self.brief.font = [UIFont systemFontOfSize:15];
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(0, 0, 44, 44);
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitle:Local(SaveButtonTitle) forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    
    
    if(self.nameText.text.length > 0){
        [SVProgressHUD showWithStatus:Local(@"Loading")];
        [[GizSupport sharedGziSupprot] gizModifyDeviceNameWithDevice:self.centerDevice name:self.nameText.text Succeed:^{
            
            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
            [self.navigationController popViewControllerAnimated:YES];
            
        //这里可能还需要刷新下前面的界面才行
//            self.

        } failed:^(NSString *err){
            [SVProgressHUD showErrorWithStatus:Local(@"Failed")];

        }];
        
    }
    else{
    
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter a new name for the device")];
        [self.nameText becomeFirstResponder];
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
