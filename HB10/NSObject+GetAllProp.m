//
//  NSObject+GetAllProp.m
//  jadeApp2
//
//  Created by JD on 2016/10/25.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "NSObject+GetAllProp.h"
#import "objc/runtime.h"

@implementation NSObject (GetAllProp)

- (NSMutableArray<NSString *> *)getAllProp:(Class)cls{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    free(properties);
    return mArray;
}


@end
