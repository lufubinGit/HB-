//
//  SuspensionView.h
//  jadeApp2
//
//  Created by JD on 2016/12/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuspensionAction;
typedef NS_ENUM(NSInteger, SuspensionViewType) {
    SuspensionViewleftTopType = 1<<0
    
};


@interface SuspensionView : UIView

@property (nonatomic,strong) NSMutableArray <SuspensionAction *> *actions;

- (void)addSuspensionWithAction:(SuspensionAction *)action;

- (void)showWithType:(SuspensionViewType )type;

- (void)dismissSelf;

@end
