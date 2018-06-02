//
//  NSDictionary+NSdicToJsonData.h
//  快拍
//
//  Created by 卢赋斌 on 16/5/7.
//  Copyright © 2016年 Peanut Run Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSdicToJsonData)

-(NSString *)JsonModel:(NSDictionary *)dictModel;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
