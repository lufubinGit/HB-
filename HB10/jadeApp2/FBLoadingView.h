//
//  FBLoadingView.h
//  jadeApp2
//
//  Created by JD on 2016/10/19.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum : NSUInteger {
    loadingTypeCirculateType = 0,
    loadingTypeReturnCircleType,
}LoadingType;

@interface FBLoadingView : CAShapeLayer

@property (nonatomic,) LoadingType loadingType;



/**
 * @brief  自定义加载等待视图
 *
 * @param  frame   控件frame
 * 
 * @param  outerColor   外环颜色
 * 
 * @param  inerColor    内环颜色
 *
 * @return 初始化返回 FBLoadingView 对象
 
 */
- (FBLoadingView*)initWithFrame:(CGRect )frame outLineColor:(UIColor *)outerColor inerColor:(UIColor *)inerColor withDirection:(int)direction lenth:(CGFloat)lenth;

@end
