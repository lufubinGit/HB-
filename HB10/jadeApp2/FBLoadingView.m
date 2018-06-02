//
//  FBLoadingView.m
//  jadeApp2
//
//  Created by JD on 2016/10/19.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "FBLoadingView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"
@interface FBLoadingView ()


@end

@implementation FBLoadingView
{
    CGRect _frame;
    int _dir;
    CGFloat _lenth;
    UIColor *_outColor;
    
}

- (void)addCircleStart:(CGFloat )start end:(CGFloat )end{
    //创建出CAShapeLayer
    self.frame = _frame;//设置shapeLayer的尺寸和位置
    self.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    //     self.shapeLayer.backgroundColor = [UIColor blueColor].CGColor;
    //设置线条的宽度和颜色
    self.lineWidth = 5.0f;
    self.strokeColor = _outColor.CGColor;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
    
//      UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGRectMake(0, 0, _frame.size.width, _frame.size.height) radius:_frame.size.width/2.0 startAngle:start endAngle:end clockwise:1];
    
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_frame.size.width/2.0, _frame.size.height/2.0) radius:_frame.size.width/2.0 startAngle:0 endAngle:M_PI*2.0 clockwise:1];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.path = circlePath.CGPath;
    
//    
    self.strokeStart = start;
    self.strokeEnd = end;
}

- (void)addCircle:(CGFloat )add{
    NSLog(@"%f---%f",self.strokeEnd,self.strokeStart);
    self.strokeStart += add;
    self.strokeEnd += add;
}

- (void)addCirculateTypeAnimation{
    //  设置初始位置
    if(_dir >= 0){
        _dir = 1;
        [self addCircleStart:0 end:_lenth];
    }
    else{
        _dir = -1;
        [self addCircleStart:1-_lenth end:1];
        self.transform = CATransform3DMakeRotation(M_PI + _lenth*M_PI*2, 0, 0, 1);
    }
    
    __block double rotation  = 0;
    if(_dir < 0){
        rotation = M_PI + _lenth*M_PI*2;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 repeats:YES block:^(NSTimer * _Nonnull timer) {
        rotation += M_PI/180 ;
        self.transform = CATransform3DMakeRotation(rotation, 0, 0, 1);
    }];
}


- (void)addReturnCircleTypeAnimation{
    
//  设置初始位置
    if(_dir >= 0){
        _dir = 1;
        [self addCircleStart:0 end:_lenth];
    }
    else{
        _dir = -1;
        [self addCircleStart:1-_lenth end:1];
        self.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }
    
    
//  开始添加动画效果了
    __block float i = 0.01 * _dir;
    __block int k = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%f",i);
        if(k == 1){
            [self addCircle:-i *_dir];
        }
        else{
            [self addCircle:i*_dir];
        }
        
        if(self.strokeStart >= 1-_lenth){
            k = 1;
        }else if(self.strokeStart <= 0){
            k = 0;
        }
        
    }];

}


- (FBLoadingView*)initWithFrame:(CGRect )frame outLineColor:(UIColor *)outerColor inerColor:(UIColor *)inerColor withDirection:(int)direction lenth:(CGFloat)lenth{
    
    if(!self.loadingType){
        self.loadingType = loadingTypeCirculateType;
    }
    _frame = frame;
    _dir = direction;
    _lenth = lenth;
    if(!outerColor){
        outerColor = [UIColor redColor];
        _outColor = outerColor;
    }
    if(!inerColor){
        inerColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    }
    self = [super init];
    if (self) {
        if(self.loadingType == loadingTypeCirculateType){
            [self addCirculateTypeAnimation];
        }else if(self.loadingType == loadingTypeReturnCircleType){
        
            [self addReturnCircleTypeAnimation];
        }
    }
    
    return self;
}
@end
