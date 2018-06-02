//
//  NSString+LocalStr.m
//  Home
//
//  Created by 卢赋斌 on 16/9/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "NSString+LocalStr.h"

@implementation NSString (LocalStr)

#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])
+ (NSString *)DPLocalizedString:(NSString *)translation_key {

    NSString * s = nil;
    //NSString * s = NSLocalizedStringFromTable(@"trainTitle",@"文件名",@"");
    if (![CURR_LANG containsString:@"en"] && ![CURR_LANG containsString:@"zh-Hans"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    else
    {

        s = NSLocalizedString(translation_key, nil);
    }
    NSLog(@"%@,%@",s,CURR_LANG);
    return s;
}

@end
