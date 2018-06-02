//
//  SubdeviceSetingCell.h
//  jadeApp2
//
//  Created by JD on 2016/12/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cellBlock)(BOOL);

@interface SubdeviceSetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (nonatomic,copy) cellBlock cBLock;

@end
