
//
//  UserInfoModel.m
//  jadeApp2
//
//  Created by JD on 2016/10/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserInfoModel.h"
#import <objc/runtime.h>
#import "JDAppGlobelTool.h"


@implementation UserInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {//初始化的时候需要确保每个属性都不可以是空的
        _userName = @"--";
        _userAvtar = [UIImage imageNamed:@"user_deafultAvtar"];
        _userEmail = @"--";
        _userPhoneNum = @"--";
        _userPassword = @"888888";
        _userAccout = @"JDUserAccout";
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    //防止KVC失败导致程序崩溃
}

- (NSString*)description{

    unsigned int count;
    objc_property_t *proLists = class_copyPropertyList([UserInfoModel class], &count);
    NSMutableString *descriptionStr = [[NSMutableString alloc]initWithString:@"00"];
    for(int i = 0;i < count; i++){
        objc_property_t prop = proLists[i];
        const char *propName = property_getName(prop);
        NSString *nameString = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
        [descriptionStr appendString:[NSString stringWithFormat:@"%@  ---  %@\n",nameString,[self valueForKey:nameString]]];
    }
    
    return descriptionStr;
}

@end
