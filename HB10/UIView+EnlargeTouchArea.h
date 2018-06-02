//
//  UIView+EnlargeTouchArea.h
//  KuaiPai
//
//  Created by 卢赋斌 on 16/6/2.
//  Copyright © 2016年 Peanut Run Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

/**
 
   扩大控件点击范围
 
 */

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
