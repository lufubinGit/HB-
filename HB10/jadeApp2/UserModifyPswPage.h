//
//  UserModifyPswPage.h
//  jadeApp2
//
//  Created by JD on 16/10/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface UserModifyPswPage : BaseViewController

@property (nonatomic,strong) NSString *testCode;  //重置密码的时候获取的验证码

@property (nonatomic,strong) NSString *oldPassword; //修改密码的时候输入的原来密码

@property (nonatomic,strong) NSString *userName;  //用户名

// 注意  以上两者不可能同时存在的  当验证码存在的时候，一定是重置密码   反之，当旧密码在的时候一定是修改密码 。  调用的方法也就不一样了

@end
