//
//  UserCenterTableViewCell.m
//  jadeApp2
//
//  Created by JD on 16/9/21.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "UserCenterTableViewCell.h"
#import "UserCenterModel.h"

@implementation UserCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserCenterModel *)model{
    self.name.text = model.itemName;
    self.brief.text = model.itemBerif;
    self.arraw.hidden = model.itemBerif.length;
    self.iconV.image = [UIImage imageNamed:model.itemImage];
    
}

@end
