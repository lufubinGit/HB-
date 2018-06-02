//
//  suspensionAction.h
//  jadeApp2
//
//  Created by JD on 2016/12/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SuspensionAction;
typedef void(^SPAction)(SuspensionAction *action);

@interface SuspensionAction : UIButton

@property (nonatomic,copy)SPAction action;

+ (SuspensionAction *)suspensionActionWithIamge:(UIImage *)actionImage title:(NSString *)title handler:(void (^)(SuspensionAction *action))handler;

- (void)handerAction:(SuspensionAction *)suspensionAction;


@end

