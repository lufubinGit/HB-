//
//  NSDictionary+NSdicToJsonData.m
//  快拍
//
//  Created by 卢赋斌 on 16/5/7.
//  Copyright © 2016年 Peanut Run Technology Co., Ltd. All rights reserved.
//

#import "NSObject+NSdicToJsonData.h"
@implementation NSObject (NSdicToJsonData)

/* 方法的功能是将OC中的字典转化成JSon格式的数据,以便上传到服务器  */
- (NSString *)JsonModel:(NSDictionary *)dictModel
{
    if ([NSJSONSerialization isValidJSONObject:dictModel])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictModel options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}


/* 解析从服务起来的JSon  */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
