//
//  UIImage+BlendingColor.h
//  Rourou
//
//  Created by ios－快跑 on 16/1/26.
//  Copyright © 2016年 Shenzhen Peanut Run Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlendingColor)

+ (UIImage*) createImageWithColor:(UIColor*) color;   //获取指定颜色的图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color withFrame:(CGRect)frame;
- (UIImage *)imageWithColor:(UIColor *)color;  //改变图片的颜色
- (UIImage*)imageScaleToSize:(CGSize)size; //改变图片至指定大小
+ (UIImage *) createImageWithColor:(UIColor *)colorOne toColor:(UIColor *)twoColor withFrame:(CGRect )frame;

@end
