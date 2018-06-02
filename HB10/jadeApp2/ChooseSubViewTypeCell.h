//
//  ChooseSubViewType.h
//  jadeApp2
//
//  Created by JD on 2017/3/6.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumHeader.h"


@interface ChooseSubViewTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *script;
- (void)setInfo:(ZoneType)type;
@end
