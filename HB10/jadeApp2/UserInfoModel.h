//
//  UserInfoModel.h
//  jadeApp2
//
//  Created by JD on 2016/10/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UserInfoModel : NSObject

/** 账户名称 */
@property (nonatomic,strong)NSString *userAccout;

/** 用户名字 */
@property (nonatomic,strong) NSString *userName;

/** 用户头像 */
@property (nonatomic,strong) UIImage *userAvtar;

/** 用户手机号码 */
@property (nonatomic,strong) NSString *userPhoneNum;

/** 用户邮箱号 */
@property (nonatomic,strong) NSString *userEmail;

/** 用户密码 */
@property (nonatomic,strong) NSString *userPassword;

@end
