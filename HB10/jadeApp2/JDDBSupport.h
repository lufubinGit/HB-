//
//  JDDBSupport.h
//  jadeApp2
//
//  Created by JD on 2016/10/28.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JDDBSupport : FMDatabase



/**
 * @brief  初始化
 *
 * @param  saveid  存储的地址唯一标示
 *
 * @return JDDBSupport
 
 */
- (id)initWithSaveID:(NSString *)saveId;

-(void)insertRecordWithArr:(NSArray *)arr;

-(void)deleteRecordArr:(NSArray *)arr;

- (NSMutableArray *)queryRecord;

@end
