//
//  SetGatewayCell.h
//  jadeApp2
//
//  Created by JD on 2016/11/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumHeader.h"
typedef void(^cellBlock)(BOOL);    // cell上对应的行为

@interface SetGatewayCell : UITableViewCell

@property(nonatomic,copy) cellBlock cellB;

@property (weak, nonatomic) IBOutlet UILabel *describle;
@property (nonatomic,assign) GateWayCellType Type;
@property (weak, nonatomic) IBOutlet UILabel *wordlabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchItem;
@property (weak, nonatomic) IBOutlet UIImageView *arrowItem;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end
