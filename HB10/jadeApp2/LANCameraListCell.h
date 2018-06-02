//
//  LANCameraListCell.h
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraModel;
@class DeviceInfoModel;
typedef void(^BindBlock)();

@interface LANCameraListCell : UITableViewCell

- (void)setCellModel:(CameraModel *)model dModel:(DeviceInfoModel*)dModel;
@property (nonatomic,copy)BindBlock bind;

@end
