//
//  CameraModel.h
//  JADE
//
//  Created by JD on 2017/6/2.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GWP2P/GWP2P.h>

@class DeviceInfoModel;

@interface CameraModel : NSObject

@property (nonatomic,strong) NSString *cameraName;  //摄像机的名字

@property (nonatomic,strong) NSString *cameraID;   //摄像机的ID

@property (nonatomic,strong) DeviceInfoModel *dModel; //当前绑定的设备


@end
