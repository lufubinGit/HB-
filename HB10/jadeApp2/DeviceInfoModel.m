
//
//  DeviceInfoModel.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "DeviceInfoModel.h"
#import "DataPointModel.h"
#import "iconv.h"
#import "JDDeviceHistoryRecord.h"
#import "ModifyEvent.h"
#import "NSObject+GetAllProp.h"
#import "JDAppGlobelTool.h"


@implementation DeviceInfoModel
{
    BOOL _gotFirstSubs;
}
//每当接受到通知 获取到数据
- (void)getData:(NSDictionary *)dic{
       GizWifiDevice *devcie = dic[@"device"];
    if([devcie.did isEqualToString:self.gizDevice.did]){
        self.gizDevice = devcie;
        if([dic[@"data"] allKeys].count){
            self.gizDeviceData = dic[@"data"];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self forKey:@"model"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GizDeviceRefrsh object:nil userInfo:dic];
            
        }
        //保证不是每次都会更新的  只有在更新了对应的设备的之后才会更新
        self.gizDeviceAlerts = dic[@"alerts"];
        self.gizDeviceFaults = dic[@"faults"];
        
        //透传信息
        if([[dic allKeys] containsObject:@"binary"]){
            self.gizDevcieBinary = dic[@"binary"];
        }

    }
}

#pragma mark - get set
// 封装机智云设备
- (void)setGizDevice:(GizWifiDevice *)gizDevice{

    _gizDevice = gizDevice;
    //当获取到设备的时候 需要给所有相关的属性设置好信息 包括子设备的数据信息 和 自身 中央设备的信息。
    self.gizDeviceName = gizDevice.productName;
    self.gizEnableChangeName = gizDevice.alias;
    if(self.gizEnableChangeName.length){
        self.gizDeviceName = self.gizEnableChangeName; //如果用户修改过名字的话  那么设备的名字就直接更改成他修改过的名字
    }
    self.gizIsOnline = gizDevice.netStatus;
}

- (NSString *)gizDeviceName{

    if(self.gizDevice.alias.length){
        return self.gizDevice.alias;
    }
    return _gizDeviceName;
}

//网关 的设备类型
- (GateawayType)type{
    
    if ([self.gizDevice.productKey isEqualToString:@"6931177c6802488787e4af52581730b3"]){
        return GateawayType433868;
    }else if([self.gizDevice.productKey isEqualToString:@"58aa9e10ae2d4d788507226d718cb8d1"]){
        return GateawayTypeDeafult;
    }else if([self.gizDevice.productKey isEqualToString:@"a072d3ba727a46c7a00f31f1a8e14cc0"]){
        return GateawayTypeWGZ;
    }else{
        return GateawayTypeDeafult;
    }
}

- (BOOL)setLauEnable{
    switch (self.type) {
        case GateawayType433868:
            return YES;
            break;
        case GateawayTypeWGZ:
            return YES;
            break;
        case GateawayTypeDeafult:
            return NO;
            break;
        default:
            return NO;
            break;
    }
}


- (BOOL)numExist{
   
    if ([[self.gizDeviceData allKeys] containsObject:@"device_type"]){
        NSString *device_type = self.gizDeviceData[@"device_type"];
        switch ([device_type integerValue]) {
            case 1:
                return YES;
                break;
            case 2:
                return YES;
                break;
            case 3:
                return NO;
                
                break;
            default:
                return NO;
                break;
        }
    }
    return false;
}

- (DeviceLauType)lau{


    if ([[self.gizDeviceData allKeys] containsObject:@"system_language"]){
        
        NSInteger currentLanguage = [self.gizDeviceData[@"system_language"] integerValue];

        if(currentLanguage == 0){
            
            return CH;
        }else if(currentLanguage == 1){
            
            return EN;
        }else if(currentLanguage == 2){
            return RU;
        }
    }
    return CH;
}


//设备的GSM信号
- (void)setSignalIntensity{
    
    GateawayDeviceSignalIntensity GSMSi = GateawayDeviceNoShow;
    if(![[self.gizDeviceData allKeys] containsObject:@"gsm_csq"]){
        self.SignalIntensity = GSMSi;
        return;
    }
    
    NSInteger single = [self.gizDeviceData[@"gsm_csq"] integerValue];
    self.gsm_sim_check = [self.gizDeviceData[@"gsm_sim_check"] boolValue];
    self.gsm_search_network = [self.gizDeviceData[@"gsm_search_network"] boolValue];
    if(!self.gsm_sim_check){
        self.SignalIntensity = GateawayDeviceNoSMSCard;
        return;
    }
    if(self.gsm_search_network){
        self.SignalIntensity = GateawayDeviceSearching;
        return;
    }
    if(single>2&&single < 5){
        GSMSi = GateawayDeviceIntensityOne;
    }else if(single>=5&&single < 9){
        GSMSi = GateawayDeviceIntensityTwo;
    }else if(single>=9&&single < 14){
        GSMSi = GateawayDeviceIntensityThree;
    }else if(single>=14&&single < 19){
        GSMSi = GateawayDeviceIntensityFour;
    }else if(single>=19){
        GSMSi = GateawayDeviceIntensityFive;
    }else if(single>=2&&single == 99){
        GSMSi = GateawayDeviceIntensityLowest;
    }
    self.SignalIntensity = GSMSi;
}

//设备的Wi-Fi信号
- (void)setWIFISigna{
    
    NSInteger single = [self.gizDeviceData[@"rssi"] integerValue];
    GateawayDeviceWifiSingn WIFISi = GateawayDeviceWifiZero;
    if(single <= 7){
        WIFISi = GateawayDeviceWifiFour;
    }
    if(single<=5){
        WIFISi = GateawayDeviceWifiThree;
    }
    if(single<=3){
        WIFISi = GateawayDeviceWifiTwo;
    }
    if(single==1){
        WIFISi = GateawayDeviceWifiOne;
    }
    if(single==0){
        WIFISi = GateawayDeviceWifiZero;
    }
    self.WIFISigna = WIFISi;
}

//网关的数据点信息
- (void)setGizDeviceData:(NSDictionary *)gizDeviceData{
    _gizDeviceData = gizDeviceData;
    [self setSignalIntensity];
    [self setWIFISigna];
    //透传的时候数据是空的  不做操作
    //每次都应该讲报警信息清除
    self.anewArms = nil;
    if([gizDeviceData allKeys].count > 0){
        //这里要对包含 datas 数据 的数据点进行一个解析  转换成相应的字符串
        NSDictionary *data = gizDeviceData;
        for (NSString *key in [data allKeys]) {
            if([data[key] isKindOfClass:[NSData class]]){
                
                if([key isEqualToString:@"newAlm"]){//报警数据的特别解析
                    NSLog(@"警报 %@",data[key]);
                    [self newlarmEventWithData:(NSData *)(data[key])];
                }else{
                    NSString *ASCIStrI = [[ NSString alloc] initWithData:[data objectForKey:key] encoding:NSUTF8StringEncoding];
                    [data setValue:ASCIStrI forKey:key];
                    
                }
            }
        }
        _gizDeviceData = data;
        //将设备的数据点封装成数据点的模型 并用数组将它存放起来
        self.gizDeviceDataPointArr = [NSMutableArray array];
        for (id obj in [gizDeviceData allKeys]) {
            DataPointModel *model = [[DataPointModel alloc]init];
            model.dataPointName = obj;
            model.dataPointValue = [gizDeviceData valueForKey:obj];
            if(model){
                [_gizDeviceDataPointArr addObject:model];
            }
        }
        
        for (DataPointModel *model in _gizDeviceDataPointArr) {
            if([model.dataPointName isEqualToString:@"enrolling"]){
            
                if(model.dataPointValue == 0){
                
                    //终止设备的对码 退出对码
                    [[NSNotificationCenter defaultCenter] postNotificationName:GizStopSearchSubDevcie  object:nil];
                }
            }
        }
        
    }
}

//获取到报警事件的解析 如果设备的data是零需要不做处理
-(void)newlarmEventWithData:(NSData *)data{
    char input[] = {0x00};

    NSMutableData* sdata = [NSMutableData dataWithBytes:input length:sizeof(input)];
    if(![[data subdataWithRange:NSMakeRange(0, 1)] isEqualToData:sdata]){
        self.anewArms = [[NSMutableArray alloc]init];
        NewAlarm *arm = [[NewAlarm alloc]initWithData:data];
        if(arm.armDevice.trigger){  //只有当真正出发警告的时候才会报警 
            [self.anewArms addObject:arm];
        }
        NSLog(@"警报%@",self.anewArms);

    }else{
      
    }
}

//透传信息 解析
- (void)setGizDevcieBinary:(NSData *)gizDevcieBinary{
//    NSLog(@"～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～%@",gizDevcieBinary);
    _gizDevcieBinary = gizDevcieBinary;
    NSData *binary = (NSData *)gizDevcieBinary;
    //接受指令
    //第一字节 判断指令的形式
    NSData *orderTypeData = [binary subdataWithRange:NSMakeRange(0, 1)];
    if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x04} length:sizeof((char[]){0x04})]]){
        // 04  查询子设备 03 命令的信息的回调
        NSData *dd = [binary subdataWithRange:NSMakeRange(1, 1)];
        if([dd isEqualToData:[NSData dataWithBytes:(char[]){0x01} length:sizeof((char[]){0x01})]]){
            NSData *deviceCountData = [binary subdataWithRange:NSMakeRange(2, 1)];
            int count = ((Byte *)deviceCountData.bytes)[0];
            NSLog(@" 第一次包含 %d 个设备",count);
            self.subDevices = [[NSMutableArray alloc]init];
            for(int i = 0 ;i < count;i++ ){
                NSData *subDeviceData = [binary subdataWithRange:NSMakeRange(3+52*i, 52)];
                JDGizSubDevice *subDevice = [self getSubDeviceData:subDeviceData];
                [_subDevices addObject:subDevice];
            }
            _gotFirstSubs = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(_gotFirstSubs){  // 如果两秒之后 还是没来 02 的信息  就会直接刷新01 的数据了
                    [self saveSubDeviceData];
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:self forKey:@"model"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GizSubDeviceRefrsh  object:nil userInfo:dic];
                }
            });
            return;
        }else{
            if(_gotFirstSubs){
                NSData *deviceCountData = [binary subdataWithRange:NSMakeRange(2, 1)];
                int count = ((Byte *)deviceCountData.bytes)[0];
                NSLog(@" 第二次包含 %d 个设备",count);
                for(int i = 0 ;i < count;i++ ){
                    NSData *subDeviceData = [binary subdataWithRange:NSMakeRange(3+52*i, 52)];
                    JDGizSubDevice *subDevice = [self getSubDeviceData:subDeviceData];
                    [_subDevices addObject:subDevice];
                }
                [self saveSubDeviceData];
            }
        }
        _gotFirstSubs = NO;
        
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x01} length:sizeof((char[]){0x01})]]){
        // 01  获取到子设备的入网信息
        // 这里 发起一个刷新 告诉用户找到了新设备
         NSData *subDeviceData = [binary subdataWithRange:NSMakeRange(1, binary.length -1)];
         JDGizSubDevice *subDevice = [self getSubDeviceData:subDeviceData];
         NSDictionary  *dict = @{@"subDevice":subDevice};
         [[NSNotificationCenter defaultCenter] postNotificationName:FoundSubDevice  object:nil userInfo:dict];
        NSLog(@"%@",gizDevcieBinary);
         return;
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x08} length:sizeof((char[]){0x08})]]){
        // 08 设备 历史记录的回调
        DLog(@"历史记录回调");
        NSData *countData = [binary subdataWithRange:NSMakeRange(3, 1)];
        Byte *countByte = (Byte *)countData.bytes;
        NSInteger  count = countByte[0];
        DLog(@"本次获取到 %ld 条记录",(long)count);
        self.deviceRecords = [[NSMutableArray alloc]init];
        for(int i = 0 ;i < count;i++ ){
            NSData *recordData = [binary subdataWithRange:NSMakeRange(4+22*i, 22)];
            JDDeviceHistoryRecord *record = [[JDDeviceHistoryRecord alloc]initWithData:recordData];
            if(record.recordDate .length >0){
                [self.deviceRecords addObject:record];
            }
        }
       //解析完毕  发送一个通知， 记录界面可以刷新了。
        [[NSNotificationCenter defaultCenter] postNotificationName:FoundHistoryRecord object:nil];
        return;
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x06} length:sizeof((char[]){0x06})]]){
        DLog(@" 获取到 06 的信息");
        NSData *subDeviceData = [binary subdataWithRange:NSMakeRange(1, 52)];
        JDGizSubDevice *subDevice = [self getSubDeviceData:subDeviceData];
        for (int i = 0; i < _subDevices.count  ;i++) {
            JDGizSubDevice *subD = _subDevices[i];
            if([subD.IEEE isEqualToData:subDevice.IEEE]){
                //IEEE相同 说明是同一个设备  进行替换
                [_subDevices removeObject:subD];
                [_subDevices addObject:subDevice];
            }
        }
        [self saveSubDeviceData];
        [[NSNotificationCenter defaultCenter] postNotificationName:ModfySubdeviceSuc object:nil];
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x0a} length:sizeof((char[]){0x0a})]]){
        DLog(@" 获取到 10 的信息");
        self.phoneNumArr = (NSMutableArray *)[self getPhoneNumArrWithData:binary];
        [[NSNotificationCenter defaultCenter] postNotificationName:GetDevicePhone object:nil];
         return;
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x0c} length:sizeof((char[]){0x0c})]]){
        DLog(@" 获取到 12 的信息");
        [[NSNotificationCenter defaultCenter] postNotificationName:ModifyDeviceNumSuc object:nil];
        return;
//        self.phoneNumArr = (NSMutableArray *)[self getPhoneNumArrWithData:binary];
//        [[NSNotificationCenter defaultCenter] postNotificationName:GetDevicePhone object:nil];
    }else if([orderTypeData isEqualToData:[NSData dataWithBytes:(char[]){0x0E} length:sizeof((char[]){0x0E})]]){
        DLog(@" 获取到 添加433子设备的信息");
        // 这里 发起一个刷新 告诉用户找到了新设备
        NSData *subDeviceData = [binary subdataWithRange:NSMakeRange(1, binary.length -1)];
        JDGizSubDevice *subDevice = [self getRFDevcieWithData:subDeviceData];
        NSDictionary  *dict = @{@"subDevice":subDevice};
        [[NSNotificationCenter defaultCenter] postNotificationName:FoundRFSubDevice  object:nil userInfo:dict];
        DLog(@"%@",gizDevcieBinary);
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self forKey:@"model"];
    [[NSNotificationCenter defaultCenter] postNotificationName:GizSubDeviceRefrsh  object:nil userInfo:dic];}


- (void)saveSubDeviceData{
    
    //将获取的信息保存起来
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    //创建归档辅助类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码  并保留归档时候的Key值  为一个数组
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    for (JDGizSubDevice *subDevice in _subDevices) {
        
        NSString *ieeeKey = [[JDAppGlobelTool shareinstance] getBinaryByhex:subDevice.IEEE];
        [mutArr addObject:ieeeKey];
        [archiver encodeObject:subDevice forKey:ieeeKey];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:self.gizDevice.did];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //结束编码
    [archiver finishEncoding];
    //写入到沙盒
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:self.gizDevice.did];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}

//子设备 先从缓存获取
- (NSMutableArray<JDGizSubDevice *>  *)subDevices{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:self.gizDevice.did];
    //解档
    NSMutableArray *subDeviceArr = [NSMutableArray array];
    if([[NSData alloc] initWithContentsOfFile:fileName]){
        NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
        //解档辅助类
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
        //解码并解档出model
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:self.gizDevice.did];
        
        for (NSString *ieeeStr in arr) {
            if([unarchiver containsValueForKey:ieeeStr]){  //如果不包含就不会接档
               
                @try {
                    JDGizSubDevice *subDevice = [unarchiver decodeObjectForKey:ieeeStr];
                    if(subDevice&&subDeviceArr){
                        [subDeviceArr addObject:subDevice];
                    }
                } @catch (NSException *exception) {
                    DLog("是有错误的");
                } @finally {
                    
                }
                
            }
        }
        //关闭解档
        [unarchiver finishDecoding];
    }
    else{
        
    }
  
    //额外添加 摄像头设备
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(self.gizDevice.did)];
    for (int i = 0; i < arr.count;i++) {
        NSString *ID = arr[i];
        JDGizSubDevice *camera = [[JDGizSubDevice alloc] init];
        camera.cameraID = ID;
        camera.dModelDid = self.gizDevice.did;
        camera.subDeviceTypeName = @"Camera";
        camera.subDeviceType = CameraType;
        camera.subDeviceName = camera.cameraName;
        camera.subDeviceIcon = RepalceImage(@"Devcie_Camer_onlin");
        [subDeviceArr addObject:camera];
    }
    
    return subDeviceArr;
}

//433子设备解析
- (JDGizSubDevice *)getRFDevcieWithData:(NSData *)deviceData{
    JDGizSubDevice *subDevice = [[JDGizSubDevice alloc]init];
    subDevice.IEEE = [deviceData subdataWithRange:NSMakeRange(0, 8)];
    subDevice.subDeviceZonetypeData = [deviceData subdataWithRange:NSMakeRange(8, 2)];
    
    
    // ID获取
    subDevice.SirenId = [[subDevice.IEEE description] substringWithRange:NSMakeRange(1, 4)];
    int num = 0;
    for (int i = 3; i >=  0 ; i--) {
        NSString  *aStr = [subDevice.SirenId substringWithRange:NSMakeRange(i, 1)];
        aStr = [[JDAppGlobelTool shareinstance] charToInt:aStr];
        num += pow(16,3-i)*aStr.intValue;
    }
    subDevice.SirenId = [NSString stringWithFormat:@"%d",num];
    
    subDevice.PGMId = [[subDevice.IEEE description] substringWithRange:NSMakeRange(1, 5)];

    return subDevice;
}


// 16进制 转 10进制
- (int)sixteenToTen:(int) sixTeen{
    int buff = 1;
    int a = sixTeen;
    int b = sixTeen;
    int num = 0;
    
    for (int i = 0; a > 0; i++) {
        b = a%10;
        a = a/10;
        buff = pow(16, i)*b;
        num += buff;
    }
    return num;
}

//单个设备的解析
- (JDGizSubDevice *)getSubDeviceData:(NSData *)deviceData{
    
    JDGizSubDevice *subDevice = [[JDGizSubDevice alloc]init];
    
    subDevice.IEEE = [deviceData subdataWithRange:NSMakeRange(0, 8)];
    
    subDevice.shortAdr = [deviceData subdataWithRange:NSMakeRange(8, 2)];
    
    subDevice.endpoint = [deviceData subdataWithRange:NSMakeRange(10, 1)];
    
    subDevice.ProfileID = [deviceData subdataWithRange:NSMakeRange(11, 2)];
    
    subDevice.DeviceID = [deviceData subdataWithRange:NSMakeRange(13, 2)];
    
    subDevice.subDeviceZonetypeData = [deviceData subdataWithRange:NSMakeRange(15, 2)];
    
    subDevice.productID = [deviceData subdataWithRange:NSMakeRange(0, 49)]; //设备的全部信息
    
    //设备的名字设置
    NSData *nameData = [deviceData subdataWithRange:NSMakeRange(17, 32)];
    subDevice.subDeviceName = [[NSString alloc]initWithData: nameData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",nameData.description);
//    NSLog(@"%@",subDevice.subDeviceName);
//    NSLog(@"%lu",(unsigned long)subDevice.subDeviceName.length);
    //如果没有命名  取设备的型号名字 设备型号没有名字 则显示未知名字
    subDevice.subDeviceName = (subDevice.subDeviceName.length>0&&subDevice.subDeviceName.length<=32) ?subDevice.subDeviceName:subDevice.subDeviceTypeName;
   
    if([nameData.description  isEqualToString: @"<00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000>"]){
        subDevice.subDeviceName = subDevice.subDeviceTypeName;
    }
    subDevice.subDeviceName = subDevice.subDeviceName.length>0?subDevice.subDeviceName:Local(@"Unnamed");
   
//    NSLog(@"%@",subDevice.subDeviceName);

    if(deviceData.length > 49){
    //说明带有设置信息的
    //设备的全部信息
    subDevice.productID = [deviceData subdataWithRange:NSMakeRange(0, 52)];
    //一字节当前的状态
    NSData *datas =  [deviceData subdataWithRange:NSMakeRange(49, 1)];
        
    subDevice.stateStr = [[JDAppGlobelTool shareinstance] getBinaryByhex:datas];
    
    //一字节的设置
    datas =  [deviceData subdataWithRange:NSMakeRange(50, 1)];
        
    subDevice.settingStr = [[JDAppGlobelTool shareinstance] getBinaryByhex:datas];
        
    //一字节信号强度  暂时没有定义
    datas =  [deviceData subdataWithRange:NSMakeRange(51, 1)];
    subDevice.sis = [[JDAppGlobelTool shareinstance] getBinaryByhex:datas];
        
    }
       return subDevice;
}

//设备的电话码号解析
- (NSArray *)getPhoneNumArrWithData:(NSData *)data{
    NSMutableArray *numArr = [[NSMutableArray alloc]init];
    NSData *numCount = [data subdataWithRange:NSMakeRange(2, 1)];
    int count = ((Byte *)numCount.bytes)[0];
    for (int i = 0; i < count; i++) {
        NSData *subData = [data subdataWithRange:NSMakeRange(3+i*17, 17)];
        NSData *indexData = [subData subdataWithRange:NSMakeRange(0 ,1)];
        NSData *typeData = [subData subdataWithRange:NSMakeRange(1,1)];
        NSData *numData = [subData subdataWithRange:NSMakeRange(2,15)];
        PhoneNum *num = [[PhoneNum alloc] init];
        num.index = [NSNumber numberWithUnsignedInt:((Byte *)indexData.bytes)[0]] ;
        num.type = [NSNumber numberWithUnsignedInt:((Byte *)typeData.bytes)[0]] ;
        num.PhoneNum = [[NSString alloc]initWithData:numData encoding:NSUTF8StringEncoding];
        switch (num.type.intValue) {
            case 1:
            {
                num.type1 = true;
                num.type2 = false;
            }
                break;
            case 2:
            {
                num.type1 = false;
                num.type2 = true;
            }
                break;
            case 3:
            {
                num.type1 = true;
                num.type2 = true;
            }
                break;
                
            default:
                num.type1 = false;
                num.type2 = false;
                break;
        }
        [numArr addObject:num];
    }
    return numArr;
}

#pragma mark  -  中控设备和子设备的交互
- (NSInteger)timeOut{
    if(!_timeOut){
        _timeOut = [[NSDate date] timeIntervalSince1970];
    }
    return _timeOut;
}


//App下发，查询子设备信息
- (void)getSubDeviceInfo: (nullable void(^)())compelet {
    DLog(@"  查询子设备  ");
    char input[] = {0x03, 0x01};
    NSData* data = [NSData dataWithBytes:input length:sizeof(input)];
    NSDictionary *request = @{@"binary": data};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:80 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"查询子设备回调");
        if (compelet) {
            compelet();
        }
    }];
}

//App下发，删除子设备。数据为产品ID，ID可只发IEEE地址。
- (void)deleteSubDeviceWithSubDevice:(JDGizSubDevice *)subdevice{
    
    char input[] = {0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:input length:sizeof(input)];
    [data appendData:subdevice.IEEE];
     NSLog(@"%@",data);
    NSDictionary *request = @{@"binary": data};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:DeleteSubDeviceSN device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"删除子设备回调");
    }];
}

//App下发,添加子设备,打开中控设备绑定的开关
- (void)openSubDeviceSwitch{
    
    NSDictionary *request = @{@"enrolling": [NSNumber numberWithBool:YES]};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:82 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"%@",datamap);
    }];
}

//App下发，关闭子设备入网许可
- (void)closeSubDeviceSwitch{
    
    NSDictionary *request = @{@"enrolling": [NSNumber numberWithBool:NO]};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:85 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"%@",datamap);
    }];
}

//App下发, 查询历史记录
- (void)getHistoryDataWithIndexPage:(int )page{
    
    int count = 20;
    int XLow = count*(page -1) +1 ;
    int XHigh = 0;
    if( XLow > 255){
        XHigh = XLow/256;
        XLow = XLow%256;
    }
    char s[] = {0x07,XHigh,XLow,count};
    NSData *data = [NSData dataWithBytes:s length:sizeof(s)];
    NSLog(@"%@",data);
    NSDictionary *request = @{@"binary": data};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:83 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"历史记录查询回调");
    }];
}


//App下发，修改单个设备信息 可修改的信息包括： 子设备的名字、设置字段 event为修改的具体内容
- (void)modfySubDeviceInfoWithSubDevice:(JDGizSubDevice *)device event:(id)event withType:(ModEventType)type{
    
    ModifyEvent *ModEvent = [[ModifyEvent alloc] initWithEvent:event eventType:type forsubDevice:device];
    NSLog(@"%@",ModEvent.request);
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:84 device:self withOrder:ModEvent.request callBack:^(NSDictionary *datamap) {
        NSLog(@"修改子设备信息之后 回调");
    //  NSLog(@"%@",datamap);
    }];
}

//App下发，获取设备的电话号码
- (void)getPhoneNum{
        char input[] = {0x09};
        NSData *data = [NSData dataWithBytes:input length:sizeof(input)];
        NSDictionary *request = @{@"binary": data};
        [[GizSupport sharedGziSupprot] gizSendOrderWithSN:86 device:self withOrder:request callBack:^(NSDictionary *datamap) {
            NSLog(@"电话号码查询回调");
        }];
}

//App下发，为设备添加电话号码
- (void)addDevicePhonNum:(NSString *)num{

    for (int i = 1; i <= 6; i++) {
        int k = 0;
        for (int j = 0; j < self.phoneNumArr.count; j++) {
            PhoneNum *phone = self.phoneNumArr[j];
            if(phone.index.integerValue == i ){
                k++;
            }
        }
        if(k == 0) { //说明这个位置是没有被使用的
            [self eidtPhoneInfoWithType:1 index:i num:num];
            break;
        }
    }
}

//App下发，修改设备的报警号码的信息
- (void)eidtPhoneInfoWithType:(NSInteger)type index:(NSInteger)index num:(NSString*)phoneNum {
    char input[] = {0x0b};
    char input1[] = {type};
    char input2[] = {index};
    
    NSMutableData *data = [NSMutableData dataWithBytes:input length:sizeof(input)];
    [data appendBytes:input2 length:sizeof(input2)];
    [data appendBytes:input1 length:sizeof(input1)];
    NSData *numData =[phoneNum dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:numData];

    NSDictionary *request = @{@"binary": data};
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:87 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"电话号码查询回调");
    }];
}


-(NSData*) hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString *) stringToHex:(int)X{
//    X = [self sixteenToTen:X];
    NSMutableString *content = [[NSMutableString alloc]init];
    if(X < 16){
        [content appendString:@"0"];
        [content appendFormat:@"%0x",X];
    }else{
        [content appendFormat:@"%0x",X];
    }
    return content;
}

//APP下发 ，添加433设备带入要添加的子设备型号
- (void)addTypeSubDeviceWith:(ZoneType)type adress:(NSString *)adr{
    char input[] = {0x0D};
    
    NSMutableData *data = [NSMutableData dataWithBytes:input length:sizeof(input)];
    if(type == PGMType){ //PGM
        //手动添加  后续添加
        NSString *effectStr = [adr substringFromIndex:1];
        
        NSMutableArray <NSString *> *arr = [[NSMutableArray alloc]init];
        for(int i = 0; i < [effectStr length]; i++)
        {
            NSString* temp = [effectStr substringWithRange:NSMakeRange(i, 1)];
            [arr addObject:temp];
        }
        for(int i = 0;i < arr.count;i++){
           arr[i] = [[JDAppGlobelTool shareinstance] charToInt:arr[i]];
        }
        
        int one = arr[0].intValue *16 + arr[1].intValue;
        int two = arr[2].intValue *16 + arr[3].intValue;
        int three = arr[4].intValue *16;
        NSString *astr = [NSString stringWithFormat:@"%@%@%@",[self stringToHex:one],[self stringToHex:two],[self stringToHex:three]];
        [data appendData:[self hexToBytes:astr]];
        char ieee[] = {0x00,0x00,0x00,0x00,0x00};
        [data appendBytes:ieee length:sizeof(ieee)];

    }else if(type == AlarmType){ //警号
        int effectInt = adr.intValue;
        int one = effectInt/256;
        int two = effectInt%256;
        NSString *astr = [NSString stringWithFormat:@"%@%@",[self stringToHex:one],[self stringToHex:two]];
        [data appendData:[self hexToBytes:astr]];
        char ieee[] = {0x00,0x00,0x00,0x00,0x00,0x00};
        [data appendBytes:ieee length:sizeof(ieee)];
        
    }else{
        char ieee[] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
        [data appendBytes:ieee length:sizeof(ieee)];
    }
    switch (type) {
        case MotionSensorType:{
            char input2[] = {0x0d,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case MagnetometerType:{
            char input2[] = {0x15,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case FireSensorType:{
            char input2[] = {0x28,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case GasSensorType:{
            char input2[] = {0x2b,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case RemoterContorlType:{
            char input2[] = {0x15,0x01};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case AlarmType:{
            char input2[] = {0x25,0x02};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case PGMType:{
            char input2[] = {0xbb,0x8b};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;
        case DoorRingType:{
            char input2[] = {0xaa,0x8a};
            [data appendBytes:input2 length:sizeof(input2)];
        }
        case SoSType:{
            char input2[] = {0x2c,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
        case WaterSensorType:{
            char input2[] = {0x2a,0x00};
            [data appendBytes:input2 length:sizeof(input2)];
        }
            break;

        default:
            break;
    }
    
    NSDictionary *request = @{@"binary": data};
    NSLog(@"%@",request);
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:88 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"电话号码查询回调");
    }];
}

//APP下发 注册警号和PGM  没有回复的
- (void)regiestAlarmAndPGM:(JDGizSubDevice *)subDevice{
    char input[] = {0x11};
    NSMutableData *data = [NSMutableData dataWithBytes:input length:sizeof(input)];
    [data appendData:subDevice.IEEE];
    NSDictionary *request = @{@"binary": data};
    NSLog(@"%@",request);
    [[GizSupport sharedGziSupprot] gizSendOrderWithSN:89 device:self withOrder:request callBack:^(NSDictionary *datamap) {
        NSLog(@"PGM 警号  回调");
    }];
}

//APP下发 保存/获取／删除摄像头的密码
- (void)saveCameraPswWithId:(NSString *)cameraId psw:(NSString *)psw{
    DLog(@"保存摄像头的密码");
    [[NSUserDefaults standardUserDefaults] setValue:psw forKey:[NSString stringWithFormat:@"cameraPsw%@",cameraId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCameraPswWithId:(NSString *)cameraId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"cameraPsw%@",cameraId]];
}

- (void)removeCameraPswWithId:(NSString *)cameraId{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"cameraPsw%@",cameraId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//删除保存的摄像头的名字
- (void)removeCameraName:(NSString *)ID{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"cameraName%@",ID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isCameraExistWithId: (NSString*)ID{
    NSArray *camerArr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(self.gizDevice.did)];
    return [camerArr containsObject:ID];
}



//APP下发 添加设备的摄像头ID
- (void)addCameraWithID:(NSString *)ID compelet: (void(^)())action{
    DLog(@"APP 下发，添加摄像头");
    //暂时先用本地存储的方式存起来
    NSArray *camerArr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(self.gizDevice.did)];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:camerArr];
    if(![mutArr containsObject:ID]){
        [mutArr addObject:ID];
    }
    [[NSUserDefaults standardUserDefaults] setValue:mutArr forKey:CameraDeviceDid(self.gizDevice.did)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    action();
}

//APP下删除摄像头
- (void)deleteCameraWithID:(NSString *)ID{
    //删除摄像头 之前 先删除摄像头的密码吧
    [self removeCameraPswWithId:ID];
    [self removeCameraName:ID];
    NSArray *camerArr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(self.gizDevice.did)];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:camerArr];
    if([mutArr containsObject:ID]){
        [mutArr removeObject:ID];
    }
    [[NSUserDefaults standardUserDefaults] setValue:mutArr forKey:CameraDeviceDid(self.gizDevice.did)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//子设备的信息   这里将会做数据的所有解析
- (NSArray *)getSubDeviceArrs:(NSDictionary *)dic{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    return arr;
}

//只是为了保证设备的细信息不是空的
- (NSMutableArray<DataPointModel *> *)gizDeviceDataPointArr{
    _gizDeviceDataPointArr = [NSMutableArray array];
    for (id obj in [self.gizDeviceData allKeys]) {
        DataPointModel *model = [[DataPointModel alloc]init];
        model.dataPointName = obj;
        model.dataPointValue = [self.gizDeviceData valueForKey:obj];
        if(model){
            [_gizDeviceDataPointArr addObject:model];
        }
    }
    return _gizDeviceDataPointArr;
}


@end

@implementation JDGizSubDevice
@synthesize cameraName;

- (NSString *)description
{
    for (NSString* prop in [self getAllProp:[JDGizSubDevice class] ]) {
        DLog(@"%@ --- %@",[self valueForKey:prop],prop);
    }
    return [NSString stringWithFormat:@"全系信息"];
}

- (NSString *)subDeviceTypeName{
    
    return  Local(_subDeviceTypeName);
}

//摄像头的名字
- (NSString *)cameraName{
    //    if([[NSUserDefaults standardUserDefaults] ])
    NSString * cam = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"cameraName%@",self.cameraID]];
    if(cam){
        return  cam;
    }
    return self.subDeviceTypeName;
}
- (void)setCameraNewName:(NSString *)cam{
    
    [[NSUserDefaults standardUserDefaults] setValue:cam forKey:[NSString stringWithFormat:@"cameraName%@",self.cameraID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//需要实现NSCoding中的协议的两个方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        NSArray *arr = [self getAllProp:[JDGizSubDevice class]];
        for (NSString *prop in arr) {
            if(![prop isEqualToString:@"cameraName"]){
                [self setValue:[aDecoder decodeObjectForKey:prop] forKey:prop];
            }
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSArray *arr = [self getAllProp:[JDGizSubDevice class]];
    for (NSString *prop in arr) {
        if(![prop isEqualToString:@"cameraName"]){
            [aCoder encodeObject:[self valueForKey:prop] forKey:prop];
        }
    }
}

- (void)setStateStr:(NSString *)stateStr{
    
//    NSLog(@"%@设备的状态%@",self.subDeviceName,stateStr);
    _stateStr = stateStr;
    for(int i = (int )stateStr.length -1;i >= 0;i--){
        BOOL stateAtstr = [[stateStr substringWithRange:NSMakeRange(i, 1)] boolValue];
        switch (i) {
            case 0:
                //报警状态
                self.isARMing = stateAtstr;
                break;
            case 1:
                //设备是否在线标示  1在线   0离线
                self.isOnline = !stateAtstr;
                break;
            case 2:
                //暂时没有安排数据
                break;
            case 3:
                //暂时没有安排数据
                break;
            case 4:
                //暂时没有安排数据
                break;
            case 5:
                //电池低压
                self.batteryLow = stateAtstr;
                break;
            case 6:
                //防拆
                self.disassembleEnable = stateAtstr;
                break;
            case 7:
                //触发
                self.trigger = stateAtstr;
                break;
            default:
                break;
        }
    }
    
}
//这些的前提保证是 设备的类型和 状态自己的到解析
- (NSString *)BatteryStr{
    if(self.batteryLow){
        return  Local(@"Low power");
    }else{
        return Local(@"Sufficient power");
    }
}

- (NSString *)onlinestr{
    if(self.isOnline){
        return  Local(@"Online");
    }else{
        return Local(@"Offline");
    }
}

- (NSString *)triggerStr{
    switch (self.subDeviceType) {
        case MotionSensorType:
        {
            if(self.trigger){
               return  Local(@"Sensing someone");
            }else{
               return  Local(@"Sensing on body");
            }
        }
            break;
        case MagnetometerType:
        {
            if(self.trigger){
                return  Local(@"Open");
                
            }else{
                return  Local(@"Close");
            }
        }
            break;
        case FireSensorType:
        {
            if(self.trigger){
                return  Local(@"Detection of smoke");
                
            }else{
                return  Local(@"Detection is normal");
            }
        }
            break;
            
        case GasSensorType:
        {
            if(self.trigger){
                return  Local(@"Detection of smoke");
                
            }else{
                return  Local(@"Detection is normal");
            }
        }
            break;
        case WaterSensorType:
        {
            if(self.trigger){
                return  Local(@"Open");
                
            }else{
                return  Local(@"Close");
            }
        }
            break;
        case RemoterContorlType:
        {
            return @"";
        }
            break;
            
        default:
        {
            if(self.trigger){
                return  Local(@"Open");
                
            }else{
                return  Local(@"Close");
            }
        }
            break;
    }

}

- (NSString *)disassembleEnableStr{
    if(self.disassembleEnable){
        return  Local(@"Tamper trigger");
        
    }else{
        return  Local(@"Tamper security");
    }
}

- (void)setSettingStr:(NSString *)settingStr{
    
//    NSLog(@"%@设备的状态%@",self.subDeviceName,settingStr);
    _settingStr = settingStr;
    for(int i = (int)settingStr.length-1;i >= 0;i--){
        BOOL stateAtstr = [[settingStr substringWithRange:NSMakeRange(i, 1)] boolValue];
        switch (i) {
            case 0:
                //暂时没有安排数据
                self.enableCheackOffline = stateAtstr;
                break;
            case 1:
                //设备是否有报警延时
                self.armDlyEnable = stateAtstr;
                break;
            case 2:
                //设备是否有布防延时
                self.almDlyEnable = stateAtstr;
                break;
            case 3:
                //暂时没有安排数据
                break;
            case 4:
                //白天布防有效
                self.daytimeEffective = stateAtstr;
                break;
            case 5:
                //撤防时有效
                self.disArmEffective = stateAtstr;
                break;
            case 6:
                //在家布防有效
                self.stayArmEffective = stateAtstr;
                break;
            case 7:
                //外出布防有效
                self.awayArmEffective = stateAtstr;
                break;
            default:
                break;
        }
    }
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
    self.subDeviceTypeName = @"UndownDevice";
//    NSLog(@"设备类型对应的文字： %@",mutStr);
    if([mutStr isEqualToString:@"0000"]){
    
    }else if([mutStr isEqualToString:@"0d00"]){
        self.subDeviceType = MotionSensorType;
        self.subDeviceTypeName = @"Human body sensing";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_hongwai");


    }else if([mutStr isEqualToString:@"0100"]){
        self.subDeviceType = MagnetometerType;
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


    }else if([mutStr isEqualToString:@"1501"]){
        self.subDeviceType = RemoterContorlType;
        self.subDeviceTypeName = @"Remote control";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_remot");


    }else if([mutStr isEqualToString:@"0080"]){
        self.subDeviceType = APPType;
        self.subDeviceTypeName = @"APP Client";

    }else if([mutStr isEqualToString:@"1d02"]){

    }else if([mutStr isEqualToString:@"2502"]){
        self.subDeviceType = AlarmType;
        self.subDeviceTypeName = @"Siren";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_Siren");
        self.SirenId = [[self.IEEE description] substringWithRange:NSMakeRange(1, 4)];
        int num = 0;
        for (int i = 3; i >=  0 ; i--) {
            NSString  *aStr = [self.SirenId substringWithRange:NSMakeRange(i, 1)];
            aStr = [[JDAppGlobelTool shareinstance] charToInt:aStr];
            num += pow(16,3-i)*aStr.intValue;
        }
        self.SirenId = [NSString stringWithFormat:@"%d",num];

    }else if([mutStr isEqualToString:@"aa8a"]){
        self.subDeviceType = DoorRingType;
        self.subDeviceTypeName = @"Doorbell";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_Doorbell");
        
    }else if([mutStr isEqualToString:@"bb8b"]){
        self.subDeviceType = PGMType;
        self.subDeviceTypeName = @"PGM";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_PGM");
        self.PGMId = [[self.IEEE description] substringWithRange:NSMakeRange(1, 5)];

    }else if([mutStr isEqualToString:@"ffff"]){
        
    }else if([mutStr isEqualToString:@"ffff"]){

    }else{
        self.subDeviceType = UndownType;
        self.subDeviceTypeName = @"UndownDevice";
        self.subDeviceIcon = RepalceImage(@"Device_getaway_unknow");

        
        //其余的是为定义的保留类型。
    }
    //设备的默认的名字是其类型名字
    self.subDeviceName = self.subDeviceTypeName;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation NewAlarm : NSObject

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self getArmWithData:data];
    }
    return self;
}

- (void)getArmWithData:(NSData *)data{
    
    //解析时间
    NSData *timeData = [data subdataWithRange:NSMakeRange(0 , 4)];
    Byte *timeByte = (Byte *)timeData.bytes;
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    for(int i = 0; i < timeData.length;i++){
        //获取时间 字符串
        [mutStr appendFormat:@"%@", [NSString stringWithFormat:@"%0x",timeByte[i]]];
    }
    //大小端转化
    NSMutableString *timeStr = [[NSMutableString alloc]init];
    for(int i = (int)mutStr.length-2;i >=0 ;i= i-2){
        [timeStr appendString:[mutStr substringWithRange:NSMakeRange(i, 2)]];
    }
    NSLog(@"%@-- %@",mutStr,timeStr);
    UInt64 mac1 =  strtoul([timeStr UTF8String], 0, 16);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:mac1];
    self.armDate = [formatter stringFromDate:date];
   
    //解析设备
    self.armDevice = [[JDGizSubDevice alloc]init];
    self.armDevice.IEEE = [data subdataWithRange:NSMakeRange(4, 8)];
    self.armDevice.endpoint = [data subdataWithRange:NSMakeRange(12, 1)];
    self.armDevice.ProfileID = [data subdataWithRange:NSMakeRange(13, 2)];
    self.armDevice.DeviceID = [data subdataWithRange:NSMakeRange(15, 2)];
    
    //这里进行解析， 将设备的类型名字和类型以及设备名字都设置
    self.armDevice.subDeviceZonetypeData = [data subdataWithRange:NSMakeRange(17, 2)];
    self.armDevice.stateStr = [[JDAppGlobelTool shareinstance] getBinaryByhex:[data subdataWithRange:NSMakeRange(19, 1)]];
    
    self.maskCode =  [data subdataWithRange:NSMakeRange(20, 1)];
    self.event = [data subdataWithRange:NSMakeRange(21, 1)];
    self.content = [[JDAppGlobelTool shareinstance] getContentWithEventData:[data subdataWithRange:NSMakeRange(19, 3)] type:self.armDevice.subDeviceType];
    
    //设备的名字设置
    self.armDevice.subDeviceName = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(22, 32)] encoding:NSUTF8StringEncoding];
    //如果没有命名  取设备的型号名字 设备型号没有名字 则显示未知名字
    self.armDevice.subDeviceName = self.armDevice.subDeviceName?self.armDevice.subDeviceName:self.armDevice.subDeviceTypeName;
    self.armDevice.subDeviceName = self.armDevice.subDeviceName?self.armDevice.subDeviceName:Local(@"Unnamed");
}

- (NSString *)description{

    return  [NSString stringWithFormat:@"%@--%@--%@--%@--%@ -- %@",self.armDate,self.armDevice.subDeviceName,self.armDevice.subDeviceTypeName,self.content,self.armDevice.stateStr,self.armDevice.subDeviceZonetypeData];
}

@end
