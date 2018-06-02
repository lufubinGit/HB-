//
//  ProgressBarDisplayView.m
//  jadeApp2
//
//  Created by JD on 16/10/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

/*
   用于显示当前的进度。  
   进度数据可通过外部输入 ，同时可由系统进行一个匀速的进度。
   外界可设属性：
 
   1.  显示器的大小。
   2.  显示器进度条的颜色。
   3.  实时输入数据改变当前进度。
   4.  显示器的背景颜色
 
 */


#import "FBProgressBarDisplayView.h"

#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"


#define MAXWScale  0.75/2.0

#define Duration 0.5

@implementation FBProgressBarDisplayView
{
    CGFloat _circleW;
    CGFloat _circleH;
    CGFloat _progress;
    UILabel *_countLabel;
}


- (instancetype)init
{
    CGRect defaultFrame = CGRectMake(0, 0, 0, 0);
    self = [super initWithFrame:defaultFrame];
    if (self) {
        _progress = 0;
    }
    return self;
}
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}



/*
    设置显示器的样式
 */


- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    CGFloat fixRadius = [self fixRadius];
    //画一条灰色的底色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context,fixRadius*0.1);
    CGContextAddArc(context, self.centerX, self.height/2.0, fixRadius, 0, M_PI*2*_progress/100.0, 0);  //360度  *  百分比
//    CABasicAnimation *ani = 
    CGContextStrokePath(context);
}

- (void)startAnimation:(CGFloat )pro{
    _countLabel.text = [NSString stringWithFormat:@"%.1f%%",pro];
    [self setNeedsLayout];
}

- (void)drawProgress:(CGFloat )progress
{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat:progress],@"pro", nil];
//    _countLabel.text = [NSString stringWithFormat:@"%.2f%%",_progress];
    [self setNeedsDisplay];
     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pro:) userInfo:dic repeats:NO];
//    [self pro:nil];
}

- (void)pro:(NSTimer *)timer{
    
    CGFloat pro = [timer.userInfo[@"pro"] floatValue];
//    if(_progress == 100){
//    
//        [timer invalidate];
//        
//    }
//    if(_progress + (pro - _progress)/20.0 < pro){
    _progress += (pro - _progress)/20.0;
        
    [self startAnimation:pro];
 
    
}


- (void)addimage{
    CGFloat fixRadius = [self fixRadius];

    //添加底部的视图
    UIImageView *imageV = [[UIImageView alloc]initWithImage:self.FBProgressBackgroundImage];
    imageV.frame = CGRectMake(0, 0, fixRadius*2.0*0.9, fixRadius*2.0*0.9);
    imageV.center = CGPointMake(self.width/2.0, self.height/2.0);
    [imageV setLayerWidth:0 color:nil cornerRadius:fixRadius*0.9 BGColor:nil];
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, fixRadius*2*0.9, fixRadius*2*0.9)];
    _countLabel.center = imageV.center;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.text = @"0.00%";
    _countLabel.font = [UIFont systemFontOfSize:25];
    _countLabel.textColor = [UIColor blueColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:imageV];
    [self addSubview:_countLabel];

}


- (CGFloat)fixRadius{

   CGFloat maxRadius = self.width < self.height?self.width:self.height;
    return maxRadius * MAXWScale;
}


- (UIColor*)FBProgressLineColor{
    if(!_FBProgressLineColor){
        _FBProgressLineColor = [UIColor blueColor];
    }
    return _FBProgressLineColor;
}

- (UIColor*)FBProgressLineBackgroundColor{
    if(!_FBProgressLineBackgroundColor){
        _FBProgressLineBackgroundColor = [UIColor grayColor];
    }
    return _FBProgressLineBackgroundColor;
}
- (UIColor*)FBProgressBarBackgroundColor{
    if(!_FBProgressBarBackgroundColor){
        _FBProgressBarBackgroundColor = [UIColor blueColor];
    }
    return _FBProgressBarBackgroundColor;
}
- (UILabel*)FBProgressCountLabel{
    if(!_FBProgressCountLabel){
        _FBProgressCountLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, _circleW/2.0,_circleH/2.0)];
        _FBProgressCountLabel.center = self.center;
    }
    return _FBProgressCountLabel;
}
- (UIImage*)FBProgressBackgroundImage{
    if(!_FBProgressBackgroundImage){
        _FBProgressBackgroundImage = [UIImage createImageWithColor:[UIColor grayColor]];
    }

    
    return _FBProgressBackgroundImage;
}

@end
