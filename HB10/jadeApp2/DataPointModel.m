//
//  DataPointModel.m
//  jadeApp2
//
//  Created by JD on 16/9/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DataPointModel.h"

@implementation DataPointModel

-(NSString *)description{

    return [NSString stringWithFormat:@"%@--%@",self.dataPointName,self.dataPointValue];
}

@end
