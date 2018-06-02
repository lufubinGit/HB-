//
//  SetGatewayNumCell.h
//  jadeApp2
//
//  Created by JD on 2016/11/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumHeader.h"

typedef void(^NumCellBlock)(NSInteger );    // cell上对应的行为

@interface SetGatewayNumCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic,copy) NumCellBlock cellB;
@property(nonatomic,copy) NumCellBlock cellB2;

@property (nonatomic,assign) GateWayCellType Type;
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) NSInteger num;
@property (weak, nonatomic) IBOutlet UILabel *numRange;

@end
