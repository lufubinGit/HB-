//
//  DeviceInfoModel+DerectorDevice.m
//  JADE
//
//  Created by JD on 2018/4/25.
//  Copyright © 2018年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DeviceInfoModel+DerectorDevice.h"

typedef BOOL(^Filter)(DataPointModel*);
@implementation DeviceInfoModel (DerectorDevice)

- (id)contain:(Filter)filter{
    for(DataPointModel *model in self.gizDeviceDataPointArr) {
        BOOL result = filter(model);
        if (result){
            return model.dataPointValue;
        }
    }
    return nil;
}

- (id)modelValueWithKey:(NSString *)key{
    return [self contain:^BOOL(DataPointModel *dm) {
        return [dm.dataPointName isEqualToString:key] ;
    }];
}



// 触发状态
- (BOOL)trig{
    return [[self modelValueWithKey:@"trig"] boolValue];
}

- (BOOL)antiTamper{
    return [[self modelValueWithKey:@"antiTamper"] boolValue];

}

- (BOOL)lowBat{
    return [[self modelValueWithKey:@"lowBat"] boolValue];

}

- (BOOL)alarm{
    return [[self modelValueWithKey:@"alarm"] boolValue];

}

- (BOOL)arm{
    return [[self modelValueWithKey:@"arm"] boolValue];

}

- (BOOL)fault{
    return [[self modelValueWithKey:@"fault"] boolValue];

}

- (GateawayDeviceWifiSingn)rssi{
    return  self.WIFISigna;
}


- (DerectorType)derectorType{
    DerectorType devType = None;
    id num = self.gizDeviceData[@"devType"];
    if([num isKindOfClass:[NSString class]]){
        devType = [num integerValue];
    }else if([num isKindOfClass:[NSNumber class]]){
        devType = [num integerValue];
    }else{
        devType = (NSInteger)num;
    }
    return devType;
}

@end
