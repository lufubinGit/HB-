//
//  UserCenterTableViewCell.h
//  jadeApp2
//
//  Created by JD on 16/9/21.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserCenterModel;
@interface UserCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *brief;
@property (weak, nonatomic) IBOutlet UIImageView *arraw;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic,strong) UserCenterModel *model;

@end
