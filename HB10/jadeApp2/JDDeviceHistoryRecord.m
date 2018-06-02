//
//  JDDeviceHistoryRecord.m
//  jadeApp2
//
//  Created by JD on 2016/11/30.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "JDDeviceHistoryRecord.h"
#import "NSObject+GetAllProp.h"
#import "JDAppGlobelTool.h"

@implementation JDDeviceHistoryRecord

//需要实现NSCoding中的协议的两个方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        NSArray *arr = [self getAllProp:[self class]];
        for (NSString *prop in arr) {
            [self setValue:[aDecoder decodeObjectForKey:prop] forKey:prop];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSArray *arr = [self getAllProp:[self class]];
    for (NSString *prop in arr) {
        [aCoder encodeObject:[self valueForKey:prop] forKey:prop];
    }
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self getHistoryRecordWithData:data];
    }
    return self;
}

- (NSString *)subDeviceTypeName{

    return  Local(_subDeviceTypeName);
}

//历史信息解析
- (void)getHistoryRecordWithData:(NSData *)recordData{
    
    NSData *timeData = [recordData subdataWithRange:NSMakeRange(0 , 4)];
    Byte *timeByte = (Byte *)timeData.bytes;
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    for(int i = 0; i < timeData.length;i++){
        //获取时间 字符串
        NSString *str = [NSString stringWithFormat:@"%0x",timeByte[i]];
        if(str.length == 1){
            str = [NSString stringWithFormat:@"0%@",str];
        }
        [mutStr appendFormat:@"%@",str];
    }
    //大小端转化
    NSMutableString *timeStr = [[NSMutableString alloc]init];
    for(int i = (int)mutStr.length-2;i >=0 ;i= i-2){
        [timeStr appendString:[mutStr substringWithRange:NSMakeRange(i, 2)]];
    }
    NSLog(@"%@-- %@",mutStr,timeStr);
    UInt64 mac1 =  strtoul([timeStr UTF8String], 0, 16);
    if(([NSDate date].timeIntervalSince1970 - mac1) < 2592000&&([NSDate date].timeIntervalSince1970 - mac1) > 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:mac1];
        self.recordDate = [formatter stringFromDate:date];
    }else{
        self.recordDate = @"";  //没有错误
    }
    self.IEEE = [recordData subdataWithRange:NSMakeRange(4, 8)];
    self.endpoint = [recordData subdataWithRange:NSMakeRange(12, 1)];
    self.ProfileID = [recordData subdataWithRange:NSMakeRange(13, 2)];
    self.DeviceID = [recordData subdataWithRange:NSMakeRange(15, 2)];
    
    //这里进行解析， 将设备的类型名字和类型以及设备名字都设置
    self.stateCode = [recordData subdataWithRange:NSMakeRange(19, 1)];
    self.maskCode =  [recordData subdataWithRange:NSMakeRange(20, 1)];
    self.event = [recordData subdataWithRange:NSMakeRange(21, 1)];
    
    self.subDeviceZonetypeData = [recordData subdataWithRange:NSMakeRange(17, 2)];
    self.content = [[JDAppGlobelTool shareinstance] getContentWithEventData:[recordData subdataWithRange:NSMakeRange(19, 3)] type:self.subDeviceType];

}


- (void)setSubDeviceZonetypeData:(NSData *)subDeviceZonetypeData{
    
    _subDeviceZonetypeData = subDeviceZonetypeData;
    
    Byte *typeChar = (Byte *)subDeviceZonetypeData.bytes;
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    for(int i = 0;i < subDeviceZonetypeData.length;i++ ){
        NSString *btyStr = [NSString stringWithFormat:@"%0x",typeChar[i]];
        if(btyStr.length == 1){
            btyStr = [NSString stringWithFormat:@"0%@",btyStr];
        }
        [mutStr appendString:btyStr];
    }
    NSLog(@"设备类型对应的文字： %@",mutStr);
    if([mutStr isEqualToString:@"0000"]){
        
    }else if([mutStr isEqualToString:@"0d00"]){
        self.subDeviceType = MotionSensorType;
        self.subDeviceTypeName = @"Human body sensing";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_hongwai");
        
    }else if([mutStr isEqualToString:@"0080"]){
        self.subDeviceType = APPType;
        self.subDeviceTypeName = @"APP Client";

        self.subDeviceIcon = RepalceImage(@"Device_getaway_APP");

    }else if([mutStr isEqualToString:@"0100"]){
        self.subDeviceType = MotionSensorType;
        self.subDeviceTypeName = @"Magnetometer";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_menci");

    }else if([mutStr isEqualToString:@"1500"]){
        self.subDeviceType = MagnetometerType;
        self.subDeviceTypeName = @"Magnetometer";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_menci");

    }else if([mutStr isEqualToString:@"2800"]){
        self.subDeviceType = FireSensorType;
        self.subDeviceTypeName = @"Fire alarm sensor";
        self.subDeviceIcon = RepalceImage(@"Devcie_gateway_yangan");

    }else if([mutStr isEqualToString:@"2a00"]){
        self.subDeviceType = WaterSensorType;
        self.subDeviceTypeName = @"Marine Sensor";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_water");

    }else if([mutStr isEqualToString:@"2b00"]){
        self.subDeviceType = GasSensorType;
        self.subDeviceTypeName = @"Gas sensing";
        self.subDeviceIcon = RepalceImage(@"Devcie_gateway_qigan");

    }else if([mutStr isEqualToString:@"2c00"]){
        self.subDeviceType = SoSType;
        self.subDeviceTypeName = @"SoS";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_SoS");

        
    }else if([mutStr isEqualToString:@"2d00"]){
        self.subDeviceType = VibrationType;
        self.subDeviceTypeName = @"Vibration sensing";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_unknow");

        
    }else if([mutStr isEqualToString:@"0f01"]){
        self.subDeviceType = RemoterContorlType;
        self.subDeviceTypeName = @"Remote control";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_remot");

        
    }else if([mutStr isEqualToString:@"2502"]){
        self.subDeviceType = AlarmType;
        self.subDeviceTypeName = @"Siren";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_Siren");
        
        
    }else if([mutStr isEqualToString:@"aa8a"]){
        self.subDeviceType = DoorRingType;
        self.subDeviceTypeName = @"Doorbell";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_Doorbell");
        
    }else if([mutStr isEqualToString:@"bb8b"]){
        self.subDeviceType = PGMType;
        self.subDeviceTypeName = @"PGM";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_PGM");
        
    }else if([mutStr isEqualToString:@"1501"]){
        self.subDeviceType = RemoterContorlType;
        self.subDeviceTypeName = @"Remote control";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_remot");

        
    }else if([mutStr isEqualToString:@"1d02"]){
        
    }else if([mutStr isEqualToString:@"2502"]){
        
    }else if([mutStr isEqualToString:@"ffff"]){
        
    }else{
        self.subDeviceType = UndownType;
        self.subDeviceTypeName = @"UndownDevice";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_unknow");

        //其余的是为定义的保留类型。
    }
    //设备的默认的名字是其类型名字
    self.devceiName = self.subDeviceTypeName;
}

@end
