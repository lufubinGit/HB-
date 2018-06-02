//
//  NSString+NSLocalPrintf.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "NSString+NSLocalPrintf.h"

@implementation NSString (NSLocalPrintf)

#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])
+ (NSString *)DPLocalizedString:(NSString *)translation_key {
    
    NSString * s = nil;
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    //NSString * s = NSLocalizedStringFromTable(@"trainTitle",@"文件名",@"");
    if ([type containsString:@"en"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([type containsString:@"ru"]){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([type containsString:@"zh-Hans"]){
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    else
    {
        s = NSLocalizedString(translation_key, nil);
    }
    return s;
}

- (NSString *)stringDeleteCStringWithstring:(NSString *)CString{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if(![CString containsString:subStr]){
            [str appendString:subStr];
        }
    }
    return str;
}

@end
