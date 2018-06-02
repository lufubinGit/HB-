//
//  UserLoginPAge.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface UserLoginPage : BaseViewController

@property (nonatomic,strong) UINavigationController *navC;
@property (nonatomic,assign) BOOL isLogin;  //如果是第一次登录将会把这个隐藏
@end
