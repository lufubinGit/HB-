//
//  ModifyEvent.h
//  jadeApp2
//
//  Created by JD on 2016/12/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumHeader.h"
@class JDGizSubDevice;

@interface ModifyEvent : NSObject

@property (nonatomic,strong) NSDictionary *request;

//这里的Event 是字符串  或者是 布尔值
- (instancetype)initWithEvent:(id)event eventType:(ModEventType)type forsubDevice:(JDGizSubDevice *)subDevice;

@end
