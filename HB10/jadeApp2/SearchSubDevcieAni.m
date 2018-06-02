   //
//  SearchSubDevcieAni.m
//  jadeApp2
//
//  Created by JD on 2016/11/28.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SearchSubDevcieAni.h"
#import "JDAppGlobelTool.h"

@implementation SearchSubDevcieAni
{
    CGFloat _progress;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _progress = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = self.width > self.height ? self.height*0.8:self.width*0.8;
    
    //首先画一个 底部圆圈 灰色 6.0 填充
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:0.5].CGColor);
    CGContextSetLineWidth(context, 6.0);
    CGContextAddArc(context, self.centerX, self.centerY, width/2.0, 0, 2*M_PI , 1);
    CGContextDrawPath(context,kCGPathStroke);

    //根据进度绘制覆盖部分 主色调 4.0 描绘
    CGContextSetStrokeColorWithColor(context, APPMAINCOLOR.CGColor);
    CGContextSetLineWidth(context, 4.0);
    CGContextAddArc(context, self.centerX, self.centerY, width/2.0, 2*M_PI*_progress, 2*M_PI , 1);
    CGContextDrawPath(context,kCGPathStroke);
}

//触发函数
- (void)drawAnimationWithPro:(CGFloat )pro{
    if(pro == 0){
        pro = 0.01;
    }
    else if(pro >= 1){
    
        pro = 0;
    }
    _progress = pro;
    [self setNeedsDisplay];  //该函数触发drawRect
}



@end
