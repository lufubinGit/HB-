//
//  NSString+LocalStr.h
//  Home
//
//  Created by 卢赋斌 on 16/9/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LocalStr)
#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])
+ (NSString *)DPLocalizedString:(NSString *)translation_key;

- (NSString *)stringDeleteCStringWithstring:(NSString *)CString;

@end
