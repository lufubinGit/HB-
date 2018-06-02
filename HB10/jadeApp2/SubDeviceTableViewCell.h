//
//  SubDeviceTableViewCell.h
//  jadeApp2
//
//  Created by JD on 2016/12/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubDeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (nonatomic,assign) BOOL isArm;  //判定当前是不是非正常状态
@end
