//
//  SubdevicEidtNamePage.m
//  jadeApp2
//
//  Created by JD on 2016/12/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SubdevicEidtNamePage.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"
@interface SubdevicEidtNamePage ()

@end

@implementation SubdevicEidtNamePage



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[SubdevicEidtNamePage alloc]initWithNibName:@"GateWayNameEidtPage" bundle:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ModyfSuc) name:ModfySubdeviceSuc object:nil];

    }
    return self;
}

- (void)initUI{
    [super initUI];
    self.title = Local(@"Set the device name");
    self.nameText.placeholder = Local(@"Set the device name");
    [self.saveButton setTitle:Local(@"Save") forState:UIControlStateNormal];
    self.brief.text = Local(@"");
    
}

- (void)ModyfSuc{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {

    if(self.nameText.text.length > 0){
        [SVProgressHUD showWithStatus:Local(@"Loading")];
        [self.centerDevice modfySubDeviceInfoWithSubDevice:self.subDevcie event:self.nameText.text withType:ModEventModNameType];
    }
    else{
        
        [SVProgressHUD showInfoWithStatus:Local(@"Please enter a new name for the device")];
        [self.nameText becomeFirstResponder];
    }
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
