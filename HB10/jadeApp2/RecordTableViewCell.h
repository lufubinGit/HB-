//
//  RecordTableViewCell.h
//  jadeApp2
//
//  Created by JD on 16/9/19.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDDeviceHistoryRecord;

@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventTwo;
@property (weak, nonatomic) IBOutlet UILabel *event;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic,strong) JDDeviceHistoryRecord *record;
@end
