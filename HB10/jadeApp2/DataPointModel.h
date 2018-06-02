//
//  DataPointModel.h
//  jadeApp2
//
//  Created by JD on 16/9/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//机智云对应了四种类型 分别是  bool 数值 枚举 扩展

@interface DataPointModel : NSObject

@property (nonatomic,strong) NSString*  dataPointName;

@property (nonatomic,strong) id dataPointValue;

@end
