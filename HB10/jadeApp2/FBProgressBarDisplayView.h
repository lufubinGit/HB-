//
//  ProgressBarDisplayView.h
//  jadeApp2
//
//  Created by JD on 16/10/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FBProgressBarDisplayView : UIView

@property (nonatomic,strong) UIColor *FBProgressLineColor;
@property (nonatomic,strong) UIColor *FBProgressLineBackgroundColor;
@property (nonatomic,strong) UIColor *FBProgressBarBackgroundColor;
@property (nonatomic,strong) UILabel *FBProgressCountLabel;
@property (nonatomic,strong) UIImage *FBProgressBackgroundImage;

- (void)drawProgress:(CGFloat )progress;

- (void)addimage;

@end
