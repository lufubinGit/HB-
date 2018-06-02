//
//  SwitchTableViewCell.h
//  jadeApp2
//
//  Created by JD on 2016/10/23.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataPointModel;

typedef void(^SwitchBlock)(BOOL);

@interface SwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *Aswitch;
@property(nonatomic,strong) DataPointModel *model;
@property (nonatomic,copy) SwitchBlock callBlock;
- (void)setCell:(NSDictionary *)dic;

@end
