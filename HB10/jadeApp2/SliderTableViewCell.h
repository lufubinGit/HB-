//
//  SliderTableViewCell.h
//  jadeApp2
//
//  Created by JD on 2016/10/23.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataPointModel;
typedef void(^SliderBlock)(int);
@interface SliderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISlider *Aslider;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (nonatomic,strong) DataPointModel *model;
@property (nonatomic,copy) SliderBlock callBlock;
- (void)setCell:(NSDictionary *)dic;
@end
