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
    return [self modelValueWithKey:@"trig"];
}

- (BOOL)antiTamper{
    return [self modelValueWithKey:@"antiTamper"];

}

- (BOOL)lowBat{
    return [self modelValueWithKey:@"lowBat"];

}

- (BOOL)alarm{
    return [self modelValueWithKey:@"alarm"];

}

- (DerectorType)devType{
    return [self modelValueWithKey:@"devType"];
}

- (BOOL)arm{
    return [self modelValueWithKey:@"arm"];

}

- (BOOL)fault{
    return [self modelValueWithKey:@"fault"];

}

- (GateawayDeviceWifiSingn)rssi{
    return  self.WIFISigna;

}

- (BOOL)isDerectorDevice{
    return  [self.gizDevice.productKey isEqualToString:@"6931177c6802488787e4af52581730b3"];
}


@end
