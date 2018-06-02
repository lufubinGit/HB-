//
//  SuspensionView.m
//  jadeApp2
//
//  Created by JD on 2016/12/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SuspensionView.h"
#import "SuspensionAction.h"
#import "UIImage+BlendingColor.h"
#import "AppDelegate.h"
#import "SuspensionAction.h"

#define ActionHight 50
#define ActionWidth 200
#define ArrowHight  10
#define STWidth 15
#define LeftCrack 10
@implementation SuspensionView
{
    UIImageView *_STImageView;
    UIView *_BGview;
}

- (void)addSuspensionWithAction:(SuspensionAction *)action{
    
    if(![self.actions containsObject:action]){
        [self.actions addObject:action];
    }
}

- (CGPoint)getStartPoint:(SuspensionViewType )type{
    
    CGPoint point = CGPointMake(0, 0);
    switch (type) {
        case SuspensionViewleftTopType:
        {
            _STImageView.frame = CGRectMake(WIDTH - LeftCrack - WIDTH*70.0/750.0 , 64, STWidth, STWidth);
            point.x = WIDTH - ActionWidth - LeftCrack ;
            point.y = 64 + ArrowHight;
        }
            break;
            
        default:
            break;
    }
    return point;
}

- (void)showWithType:(SuspensionViewType )type{
    
    _STImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, STWidth, STWidth)];
    _STImageView.image = [[[UIImage imageNamed:@"public_up Triangle"] imageWithColor:[UIColor whiteColor]] imageWithColor:[UIColor whiteColor]];
    self.userInteractionEnabled = YES;
    
    CGPoint startPoint  =  [self getStartPoint:type];
    self.frame = CGRectMake(WIDTH - LeftCrack , startPoint.y, 0, 0);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = PublicCornerRadius;
    self.backgroundColor = [UIColor whiteColor];
    for(int i = 0;i < self.actions.count;i++){
        SuspensionAction *action = self.actions[i];
        action.frame = CGRectMake(0, i*ActionHight, ActionWidth, ActionHight);
        [self addSubview:action];
    }
    
    //添加横线
    if(self.actions.count > 1){
        for(int i = 1; i < self.actions.count ; i++){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ActionHight*i - 1, ActionWidth, 1)];
            lineView.backgroundColor = APPLINECOLOR;
            [self addSubview:lineView];
        }
    }
    
    AppDelegate *appde =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    _BGview = [[UIView alloc]initWithFrame:appde.window.bounds];
    _BGview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _BGview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelf)];
    [_BGview addGestureRecognizer:tap];
    
    _BGview.alpha = 0;
    self.alpha = 0;
    _STImageView.alpha = 0;
    [appde.window addSubview:_BGview];
    [appde.window addSubview:self];
    [appde.window addSubview:_STImageView];
    [UIView animateWithDuration:0.5 animations:^{
        _BGview.alpha = 1;
        self.alpha = 1;
        _STImageView.alpha = 1;
        self.frame = CGRectMake(startPoint.x , startPoint.y, ActionWidth, ActionHight * self.actions.count);
    } completion:^(BOOL finished) {
        
    }];
  
}

- (NSMutableArray<SuspensionAction *> *)actions{

    if(!_actions){
        _actions = [[NSMutableArray alloc]init];
    }
    return _actions;
}

- (void)dismissSelf{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        _STImageView.alpha = 0;
        _BGview.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_BGview removeFromSuperview];
        [_STImageView removeFromSuperview];
    }];
    
}

@end
