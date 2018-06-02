//
//  NSDictionary+DicToData.m
//  jadeApp2
//
//  Created by JD on 2016/10/25.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+DicToData.h"

@implementation NSDictionary (DicToData)
//字典转data
-(NSData *)dicToData
{
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"talkData"];
    [archiver finishEncoding];
    return data;
}



@end
