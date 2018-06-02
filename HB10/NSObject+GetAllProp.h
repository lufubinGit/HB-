//
//  NSObject+GetAllProp.h
//  jadeApp2
//
//  Created by JD on 2016/10/25.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//
//包含对属性的操作

#import <Foundation/Foundation.h>

@interface NSObject (GetAllProp)

- (NSMutableArray <NSString *>*)getAllProp:(Class)cls;

@end
