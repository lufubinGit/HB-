//
//  NSData+DataToDic.m
//  jadeApp2
//
//  Created by JD on 2016/10/25.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "NSData+DataToDic.h"

@implementation NSData (DataToDic)

//data 转字典
- (NSDictionary *)dataToDic
{
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:self];
    NSDictionary * myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    //    NSLog(@"%@", myDictionary);
    
    return myDictionary;
}



@end
