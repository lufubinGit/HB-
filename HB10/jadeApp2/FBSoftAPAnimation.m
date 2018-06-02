//
//  FBSoftAPAnimation.m
//  jadeApp2
//
//  Created by JD on 2016/10/27.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "FBSoftAPAnimation.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"

@implementation FBSoftAPAnimation
{
    CGFloat _lineLenth;   //单边线长
    CGFloat _cricleDiameter;  //中间圆的半径
    CGFloat _MidY;        //垂直中心位置
    CGFloat _MidX;        //水平中心位置
    CGFloat _process;     //动画进度
    int _count;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. 
 */

/*
 
 两个场景  线运动 和 中间圈运动
 */

- (void)drawRect:(CGRect)rect {
    
    _cricleDiameter = self.width/6.0;
    _lineLenth = (self.width - _cricleDiameter)/2.0;
    CGFloat lineW = 3.0;
    _MidY = (self.height - lineW)/2.0;
    _MidX = self.width/2.0;
    
//    先画一层底
    //左边线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 192/256.0, 192/256.0, 192/256.0, 1.0);  // 画笔颜色 灰色
    
    CGContextSetLineWidth(context, lineW);  //画笔的宽度
    //设置起始点
    CGContextMoveToPoint(context, 0, _MidY);
    //到终点
    CGContextAddLineToPoint(context, _lineLenth, _MidY);
    CGContextDrawPath(context, kCGPathStroke);  //填充
    
    //中间圆
    CGContextAddArc(context, _MidX, _MidY, _cricleDiameter/2.0, 0, M_PI*2.0, 1);
    CGContextDrawPath(context, kCGPathStroke); //描绘

    //右边线
    //设置起始点
    CGContextMoveToPoint(context, self.width - _lineLenth, _MidY);
    //到终点
    CGContextAddLineToPoint(context, self.width, _MidY);
    CGContextDrawPath(context, kCGPathStroke);  //填充

    //WIFI 示意图 弧线
    
    CGFloat pi_8= M_PI_4/2.0;
    CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/4.0, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
    CGContextDrawPath(context, kCGPathStroke); //描绘
    
    CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/2.4, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
    CGContextDrawPath(context, kCGPathStroke); //描绘
    
    CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/1.7,-M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
    CGContextDrawPath(context, kCGPathStroke); //描绘
    
    CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/1.3, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
    CGContextDrawPath(context, kCGPathStroke); //描绘
    
//   动画
    CGContextSetRGBStrokeColor(context, 1-_process*0.8, _process*0.8, 0.2, 1.0);  // 颜色跟随渐变
    CGContextSetLineWidth(context, 5);  //画笔的宽度
    //WI-FI变化
    if( _process >=0){
        CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/4.0, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
    }
    if(_process >=0.25 ){
        CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/2.4, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
    }
    if(_process >=0.5 ){
        CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/1.7,-M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
    }
    if(_process >=0.75){
        CGContextAddArc(context, _MidX, _MidY + _cricleDiameter/2.0, _cricleDiameter/1.3, -M_PI_2 + pi_8, -M_PI_2 - pi_8, 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
    }
    
    CGContextSetLineWidth(context, lineW);  //画笔的宽度
    if(_process < _lineLenth/self.width){
        CGContextMoveToPoint(context, 0, _MidY);
        CGContextAddLineToPoint(context, _process * self.width, _MidY);
        CGContextDrawPath(context, kCGPathStroke);  //填充
        
    }else if (_process >= _lineLenth/self.width && _process < (_lineLenth/self.width + _cricleDiameter/self.width)){
        //左边线
        CGContextMoveToPoint(context, 0, _MidY);
        CGContextAddLineToPoint(context, _lineLenth, _MidY);
        CGContextDrawPath(context, kCGPathStroke);  //填充
        
        //中间圆
        CGFloat buffPro = (_process - _lineLenth/self.width)/(_cricleDiameter/self.width);
        CGContextAddArc(context, _MidX, _MidY, _cricleDiameter/2.0, M_PI*(1+buffPro)  , M_PI*(1-buffPro), 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
        
    }else if (_process >= (_lineLenth/self.width + _cricleDiameter/self.width)){
    
        //左边线
        CGContextMoveToPoint(context, 0, _MidY);
        CGContextAddLineToPoint(context, _lineLenth, _MidY);
        CGContextDrawPath(context, kCGPathStroke);  //填充
        
        //中间圆
        CGContextAddArc(context, _MidX, _MidY, _cricleDiameter/2.0, 0, M_PI*2.0, 1);
        CGContextDrawPath(context, kCGPathStroke); //描绘
        
        //右边线
        CGContextMoveToPoint(context,_lineLenth + _cricleDiameter , _MidY);
        CGContextAddLineToPoint(context, self.width*_process , _MidY);
        CGContextDrawPath(context, kCGPathStroke);  //填充

    }
    else{
    
        
    }
}

- (void)drawWithProcess{

    __block int i = 1;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if([[UIDevice currentDevice].systemVersion integerValue] >= 10.0 ){
            [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
                i++;
                
                _process = i/100.0  ;
                if(i >= 100){
                    [timer invalidate];
                }
                [self setNeedsDisplay];
            }];
        }else{
            _count = 1;
            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animation_9:) userInfo:nil repeats:YES];
        }

    });
}

- (void)animation_9:(NSTimer *)timer{

    _count++;
    _process = _count/100.0  ;
    if(_count >= 100){
        [timer invalidate];
       
    }
    [self setNeedsDisplay];
}

- (void)dealloc
{
    CGContextRelease(UIGraphicsGetCurrentContext());
}

@end
