//
//  SetGatewayArmStateCell.h
//  jadeApp2
//
//  Created by JD on 2016/11/21.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumHeader.h" 
typedef void(^ArmstateCellBlock)(NSInteger );    // cell上对应的行为


@interface SetGatewayArmStateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentItem;

@property(nonatomic,copy) ArmstateCellBlock cellB;

@property (nonatomic,assign) GateWayCellType Type;
@end
