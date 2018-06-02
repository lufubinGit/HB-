//
//  JDDeviceHistoryRecord.h
//  jadeApp2
//
//  Created by JD on 2016/11/30.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"

@class JDGizSubDevice;

@interface JDDeviceHistoryRecord : NSObject <NSCoding>

/** 记录产生的时间 */
@property (nonatomic,copy) NSString *recordDate;

/** 记录的名字 */
@property (nonatomic,copy) NSString *devceiName;

/** 记录设备 */
@property (nonatomic,copy) JDGizSubDevice *devcie;

/** 记录内容 */
@property (nonatomic,strong) NSArray<NSString *> *content;

/** 相应的子设备IEEE*/  //可以通过IEEE在中控设备中 找到子设备的信息,并保留在属性 device 中。
@property (nonatomic,strong) NSData *IEEE;

/** endpoint */
@property (nonatomic,strong) NSData *endpoint;

/** profileid */
@property (nonatomic,strong) NSData *ProfileID;

/** DeviceID */
@property (nonatomic,strong) NSData *DeviceID;

/** subDeviceZonetypeData */
@property (nonatomic,strong) NSData *subDeviceZonetypeData;

//设备的类型 类型名字 实际名字 图片
@property  (nonatomic,assign) ZoneType subDeviceType;
@property  (nonatomic,strong) NSString* subDeviceTypeName;
@property  (nonatomic,strong) NSString* subdevicename;
@property  (nonatomic,strong) UIImage* subDeviceIcon;


/** 状态码 */
@property (nonatomic,strong) NSData *stateCode;

/** 掩码 */ //标识状态发生变化的位，例如掩码为0x01表示本次事件是状态的bit0变化
@property (nonatomic,strong) NSData *maskCode;

/** 事件属性 */
//事件属性其他说明：bit0为1本次事件是报警，bit1为1表示需要推送，bit2为1表示探测器有报警延时，延时结束才报警的，所以此时防区状态可能为0。
@property (nonatomic,strong) NSData *event;

//使用data初始化
- (instancetype)initWithData:(NSData *)data;


@end
