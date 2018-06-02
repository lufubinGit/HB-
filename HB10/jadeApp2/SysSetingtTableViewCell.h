//
//  SysSetingtTableViewCell.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBlock)(BOOL);
@interface SysSetingtTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UISwitch *itemSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *itemimage;
@property (copy,nonatomic) callBlock call;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

- (void)setCell:(NSString*)str;

@end
