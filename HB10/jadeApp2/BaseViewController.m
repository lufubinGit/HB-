//
//  BaseViewController.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/8.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "JDAppGlobelTool.h"

@implementation BaseViewController
{
    CGFloat _compensateHei;
    NSString *_baseTitle;
}
- (void)viewDidLoad{
    self.title = @"";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = APPAMAINNAVCOLOR;
//    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
//    导航栏的返回的文字的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    导航栏的标题文字的颜色
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
//    背景颜色
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    开启点击页面将目前的键盘隐藏
    if(self.dismissKeyBEnable){
        self.view.userInteractionEnabled = YES;
        UITapGestureRecognizer *dismissKeybord = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeyB)];
        [self.view addGestureRecognizer:dismissKeybord];
    }
    if (_baseTitle) {
        self.title = _baseTitle;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _baseTitle = self.title;
    self.title = @"";
    
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

- (void)dismisKeyB{
    [self regiestView:self.view];
}
- (void)regiestView:(UIView*)view{
    for (UIView  *obj in view.subviews) {
        if([obj isKindOfClass:[UITextField class]] || [obj isKindOfClass:[UITextView class]]){
            UITextField *textF = (UITextField *)obj;
            [textF resignFirstResponder];
        }
    }
    if(view.subviews.count  > 0){
        for (int i = 0; i < view.subviews.count; i++) {
            [self regiestView:view.subviews[i]];
        }
    }
}






- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
