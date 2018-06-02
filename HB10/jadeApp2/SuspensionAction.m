//
//  suspensionAction.m
//  jadeApp2
//
//  Created by JD on 2016/12/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SuspensionAction.h"
#import "UIImage+BlendingColor.h"
#import "SuspensionView.h"
#define actionHight 50

@implementation SuspensionAction

+ (SuspensionAction *)suspensionActionWithIamge:(UIImage *)actionImage title:(NSString *)title handler:(void (^)(SuspensionAction *action))handler {
    
    SuspensionAction *suspensionAction = [[SuspensionAction alloc]initWithFrame:CGRectMake(0, 0, 180, actionHight)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    imageV.image = [actionImage imageWithColor:[UIColor blackColor]];
    imageV.userInteractionEnabled = NO;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 150, 40)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = APPGRAYBLACKCOLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.userInteractionEnabled = NO;
    
    [suspensionAction setImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [suspensionAction setImage:[UIImage createImageWithColor:APPLINECOLOR] forState:UIControlStateHighlighted];
    [suspensionAction addTarget:suspensionAction action:@selector(handerAction:) forControlEvents:UIControlEventTouchUpInside];
    suspensionAction.action = handler;
    
    [suspensionAction addSubview:imageV];
    [suspensionAction addSubview:label];
    
    return suspensionAction; 
}

- (void)handerAction:(SuspensionAction *)suspensionAction{
    if(self.action){
        self.action(suspensionAction);
        SuspensionView *suView = (SuspensionView *)self.superview;
        [suView dismissSelf];
    }
}

@end
