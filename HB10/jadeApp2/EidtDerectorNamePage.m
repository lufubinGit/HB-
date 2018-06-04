//
//  EidtDerectorNamePage.m
//  JADE
//
//  Created by BennyLoo on 2018/6/4.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "EidtDerectorNamePage.h"
#import "JDAppGlobelTool.h"

@implementation EidtDerectorNamePage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[EidtDerectorNamePage alloc]initWithNibName:@"GateWayNameEidtPage" bundle:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ModyfSuc) name:ModfySubdeviceSuc object:nil];
        
    }
    return self;
}

- (void)initUI{
    [super initUI];
    self.title = Local(@"Set derector Name");
    self.nameText.placeholder = Local(@"Set derector Name");
    [self.saveButton setTitle:Local(@"Save") forState:UIControlStateNormal];
    self.brief.text = Local(@"Rename the detector and set the name that is not needed to distinguish the different detectors. " );
    
}

- (void)ModyfSuc{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
