//
//  HostDeviceCell.h
//  JADE
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceInfoModel;
typedef void(^DeleteBlock)(void);

@interface HostDeviceCell : UITableViewCell

- (void)setOnlineModel:(DeviceInfoModel *)devcieModel;

- (void)setOffLineModel:(DeviceInfoModel *)devcieModel;

@property (nonatomic, copy) DeleteBlock deleteModel;


@end
