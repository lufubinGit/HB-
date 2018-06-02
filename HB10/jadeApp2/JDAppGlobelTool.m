////
//  JDAppGlobelTool.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "JDAppGlobelTool.h"
#import "DeviceInfoModel.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "EnumHeader.h"
#define ControlDeviceSet @"controlDeviceSet"
@implementation JDAppGlobelTool
+ (JDAppGlobelTool*)shareinstance{
    static JDAppGlobelTool* tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[JDAppGlobelTool alloc] init];
#if JADE
        tool.officialEmail = @"jadeiot@163.com";              //公司邮件
        tool.officialProductUrl = @"https://www.baidu.com";   //公司默认的网址  如果没有找到的话
        tool.officialTel = @"400-0755-0688";                  //公司电话
        tool.companyUrl = @"http://gb.jade-iot.com/znwl.html";  //公司网址
        tool.aPPMAINCOLOR = RGBColor(208,20,23,1.0);            //主色调
        tool.aPPAMAINNAVCOLOR = RGBColor(208,20,23,1.0);        //导航颜色
        tool.GizAPPId = @"042be520150448cab4111d32562e9a4f";  //机智云的ID
        tool.GizAPPKey = @"e094b94fcf164434ab71e07883488123";  //机智云的key
        tool.JpushId = @"938d023ac86972f96ec4ef07";  //极光的ID
        tool.JpushKey = @"681b2eee4977c72f0af0f32c";  //极光Key

#endif
#if ANKA
        tool.officialEmail = @"980946981@qq.com";              //公司邮件
        tool.officialProductUrl = @"https://www.baidu.com";   //公司默认的网址  如果没有找到的话
        tool.officialTel = @"0755-8960-3006";                  //公司电话
        tool.companyUrl = @"http://www.szcaj.com/index.php/zh/";  //公司网址
        tool.aPPMAINCOLOR = RGBColor(239,161,55,1.0);            //主色调
        tool.aPPAMAINNAVCOLOR = RGBColor(239,161,55,1.0);        //导航颜色
        tool.GizAPPId = @"dcebccf924cf45288a0593da9cfd66d6";  //机智云的ID
        tool.GizAPPKey = @"647f42e902a94d6a8c460e5d543b7a97";  //机智云的key
        tool.JpushId = @"bb4b9d335dd6d48ebd59df6e";  //极光的ID
        tool.JpushKey = @"48c4a8e5229590ff1b582ea3";  //极光Key
    
#endif
    });
    return tool;
}


- (UIImage *)repalceImage:(NSString *)imageName{
    NSString *bid =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if([bid isEqualToString:@"com.jade-iot.www.jadeApp2"]){
        return [UIImage imageNamed:[NSString stringWithFormat:@"JADE_%@",imageName]];
    }else{
       return [UIImage imageNamed:[NSString stringWithFormat:@"ANKA_%@",imageName]];
    }

//#if JADE
//#endif
//
//#if ANKA
//    return [UIImage imageNamed:[NSString stringWithFormat:@"ANKA_%@",imageName]];
//#endif
}

//给起始画面添加效果
- (void)addMaskAtView:(UIView*)View{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:View.bounds];
    imageV.image = [UIImage imageNamed:@"JD_GATE_1242x2208"];
    if(HIGHT/WIDTH == 1.5){
        imageV.image = [UIImage imageNamed:@"JD_GATE_4S"];
    }
    [View addSubview:imageV];
   [self delayTimer:2.0 doBlock:^{
       [UIView animateWithDuration:2.0 animations:^{
         
           imageV.transform = CGAffineTransformScale(imageV.transform, 1.2, 1.2);
           imageV.alpha = 0;
       } completion:^(BOOL finished) {
           [imageV removeFromSuperview];
           
       }];
   }];

}


- (void) delayTimer:(NSTimeInterval )timerInterval doBlock:(void (^ )(void))completion{
    __block NSTimeInterval timer = timerInterval;
    
        // something
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:timer];
        if(self.delay == nil){
            self.delay = completion;
            [self performSelector:@selector(delayAction) withObject:nil afterDelay:timer];

        }else{
            if(self.delay1 == nil){
                self.delay1 = completion;
                [self performSelector:@selector(delayAction1) withObject:nil afterDelay:timer];

            }else{
                if(self.delay2 == nil){
                    self.delay2 = completion;
                    [self performSelector:@selector(delayAction2) withObject:nil afterDelay:timer];

                }else{
                    NSLog(@"回调用完了");

                }
            }
        }
}
- (void)delayAction{
    if(self.delay){
        self.delay();
        self.delay = nil;
    }
}
- (void)delayAction1{
    if(self.delay1){
        self.delay1();
        self.delay1 = nil;
    }
}
- (void)delayAction2{
    if(self.delay2){
        self.delay2();
        self.delay2 = nil;
    }
}

- (NSString *)currentWifiName{
    [self getCurrentWifiNameAndPassWord];
    return _currentWifiName;
}

- (BOOL)enableNotic{

    if([[NSUserDefaults standardUserDefaults] objectForKey:noticSwitch] == nil){
    
        _enableNotic = YES;  //默认开启的
    }else{
        _enableNotic  = [[[NSUserDefaults standardUserDefaults] objectForKey:noticSwitch] boolValue];

    }
    return _enableNotic;
}

//获取当前链接到的Wi-Fi名字和密码  返回的是一个字典
- (NSDictionary *)getCurrentWifiNameAndPassWord{
    CFArrayRef myArray = CNCopySupportedInterfaces();
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (myArray != nil) {
        @try {
            CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
            if (myDict != nil) {
                dic = (NSDictionary*)CFBridgingRelease(myDict);
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    NSLog(@"wifiName:%@", dic);
    _currentWifiName = dic[@"SSID"];
    if(!_currentWifiName){
        _currentWifiName = Local(@"WI-FI is not connected");
    }
    return dic;
}

- (NSString*)currentWifiPassKey{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = [self getCurrentWifiNameAndPassWord];
    NSString *key = [dic objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
    if(key){
        return key;
    }
    return @"未连接Wifi";
}

- (void)setCurrentCity:(NSString *)currentCity{
    [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _currentCity = currentCity;
    
}





//- (NSString *)currentCity{
//
//    if(!_currentCity){
//        _currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:_currentCity forKey:@"City"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    return _currentCity;
//}

//- (DeviceInfoModel *)getDeviceModel:(JDDeviceType )type{
//
//    DeviceInfoModel *model = [[DeviceInfoModel alloc]init];
//    model.deviceType = type;
//
//    switch (type) {
//        case type1:
//        {
//            model.gizDeviceName = @"型号1";
//        }
//            break;
//        case type2:
//        {
//            model.gizDeviceName = @"";
//        }
//            break;
//        default:
//            break;
//    }
//    return model;
//}

- (BOOL)isFirstUser{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:UserFirstUseAPP]){
        _isFirstUser = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"noFirst" forKey:UserFirstUseAPP];
    }else{
        _isFirstUser = NO;
    }
    return _isFirstUser;
}

- (NSArray *)controlDeviceArr{

    return [[NSUserDefaults standardUserDefaults] objectForKey:ControlDeviceSet];
}

- (void)addControlDeviceWithModelType:(JDDeviceType )type{

    NSMutableArray *mutArr = [self.controlDeviceArr mutableCopy];
    [mutArr addObject:[NSNumber numberWithInteger:type]];
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:ControlDeviceSet];
}

- (void)registerKeyBForView:(UIView *)view{

    for (id vi in [view subviews]) {
        if([vi isKindOfClass:[UITextField class]] || [vi isKindOfClass:[UITextView class]]){
            [vi resignFirstResponder];
        }else{
            if([vi subviews].count > 0){
                [self registerKeyBForView:vi];
            }else{
                continue;  //如果已经是最上面的视图了 那直接返回就是
            }
        }
    }
}


//通过时间戳获取时间
- (NSString *)getTimeWithUnixtime:(NSTimeInterval )timeInterval{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSLog(@"%f  = %@",timeInterval,confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

-(NSTimeInterval )TimeStamp:(NSString *)strTime{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@",currentDateStr);
    return [currentDateStr floatValue];;
}

- (NSDictionary *)getScanResult:(NSString *)result
{
    NSArray *arr1 = [result componentsSeparatedByString:@"?"];
    if(arr1.count != 2)
        return nil;
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
    for(NSString *str in arr2)
    {
        NSArray *keyValue = [str componentsSeparatedByString:@"="];
        if(keyValue.count != 2)
            continue;
        
        NSString *key = keyValue[0];
        NSString *value = keyValue[1];
        [mdict setValue:value forKeyPath:key];
    }
    return mdict;
}

- (NSString *)stringWithAsciiStr:(NSString *)str{

    NSString *newStr = str;
    return newStr;
}


/* 通过获取到的data数据获得设备的相关的信息  */
- (NSArray *)getContentWithEventData:(NSData *)eventData type:(ZoneType)type{

    NSMutableArray *contentArr = [[NSMutableArray alloc]init];
    NSData *stateData = [eventData subdataWithRange:NSMakeRange(0, 1)];
    NSData *maskData = [eventData subdataWithRange:NSMakeRange(1, 1)];
    NSData *propData = [eventData subdataWithRange:NSMakeRange(2, 1)];
    //状态字符
    NSString *stateStr = [self getBinaryByhex:stateData];
    //掩码字符
    NSString *maskStr = [self getBinaryByhex:maskData];
    //事件属性字符
    NSMutableString *propStr = [[NSMutableString alloc]init];
    Byte *propByte = (Byte*)[propData bytes];
    for(int i = 0;i < propData.length;i++){
        [propStr appendString:[NSString stringWithFormat:@"%0x",propByte[i]]];
    }
    //具体事件
    NSString *prop = @"";
    NSLog(@"%@",propStr);
    switch ([propStr integerValue]){
        case 1:{
            //报警事件
            prop = Local(@"Alarm");
        }
            break;
        case 2:{
            //推送事件
            prop = Local(@"");

            }
            break;
        case 3:{
            //报警+推送
            prop = Local(@"Alarm");

            }
            break;
        case 4:{
            //探测器有报警延时
            prop = Local(@"Alarm delay");

            }
            break;
        case 5:{
            //报警事件 + 探测器有报警延时
            prop = Local(@"Alarm delay");

        }
            break;
        case 6:{
            //推送事件 + 探测器有报警延时
            prop = Local(@"Alarm delay");
            
        }
            break;
        case 7:{
            //报警事件 + 推送事件 +探测器有报警延时
            prop = Local(@"Alarm delay");

        }
            break;
        default:
            break;
    }
   
    for(int i = (int)maskStr.length -1;i >= 0;i--){
        //普通情况
        NSString *contentStr = [NSString string];
        if([[maskStr substringWithRange:NSMakeRange(i, 1)] boolValue]){
            BOOL stateBit = [[stateStr substringWithRange:NSMakeRange(i, 1)] boolValue];
            switch (i) {
                case 0:
                {
                    //报警位  舍弃
                }
                    break;
                case 1:
                {
                    if(stateBit){
                        contentStr = Local(@"Device off-line");
                    }else{
                        contentStr = Local(@"Devcie on-line");
                    }
                }
                    break;
                case 2:
                {
                   //没有
                }
                    break;
                case 3:
                {
                   //没有
                }
                    break;
                case 4:
                {
                   //没有
                }
                    break;
                case 5:
                {
                    if(stateBit){
                        contentStr = Local(@"Device battery low voltage");
                    }else{
                        contentStr = Local(@"Device battery returned to normal");
                    }

                }
                    break;
                case 6:
                {
                    if(stateBit){
                        contentStr = Local(@"Device disassembly alarm");
                    }else{
                        contentStr = Local(@"Device disassembly alarm revocation");
                    }

                }
                    break;
                case 7:
                {
                    if(stateBit){
                        switch (type) {
                            case MotionSensorType:
                            {
                                contentStr = Local(@"Sensing someone");
                            }
                                break;
                            case MagnetometerType:
                            {
                                contentStr = Local(@"Open");
                            }
                                break;
                            case RemoterContorlType:
                            {
                                contentStr = Local(@"Trigger alarm");
                            }
                                break;
                            case UndownType:
                            {
                                contentStr = Local(@"Trigger alarm");
                            }
                                break;
                            default:
                                contentStr = Local(@"Trigger alarm");
                                break;
                        }
                        
                    }else{
                        
                        switch (type) {
                            case MotionSensorType:
                            {
                                contentStr = Local(@"Sensing on body");
                            }
                                break;
                            case MagnetometerType:
                            {
                                contentStr = Local(@"Close");
                            }
                                break;
                            case RemoterContorlType:
                            {
                                contentStr = Local(@"Trigger alarm revocation");
                            }
                                break;
                            case UndownType:
                            {
                                contentStr = Local(@"Trigger alarm revocation");
                            }
                                break;
                            default:
                                contentStr = Local(@"Trigger alarm revocation");
                                break;
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        if(prop.length && contentStr.length){
            contentStr  = [contentStr stringByAppendingString:@"-"];
            contentStr = [contentStr stringByAppendingString:prop];
        }
       
        if(contentStr.length){
            [contentArr addObject:contentStr];
        }
    }
    
    //特殊情况  遥控器 和 app的操作
    NSString *contentStr = [NSString string];
    if(type == RemoterContorlType || type == APPType){
        if([maskStr isEqualToString:@"11111111"]){
            contentArr = [NSMutableArray array];
            if([stateStr isEqualToString:@"00000000"]){
                contentStr = Local(@"Disarm");
            }else if ([stateStr isEqualToString:@"00000001"]){
                contentStr = Local(@"ArmStay");
            }else if ([stateStr isEqualToString:@"00000010"]){
                contentStr = Local(@"Armaway");
            }
            if(contentStr.length){
                [contentArr addObject:contentStr];
            }
        }
    }

    
    return contentArr;
}

- (BOOL)getWordWithStateStr:(NSString *)str index:(NSInteger )index{
   
   return [[str substringWithRange:NSMakeRange(index-1, 1)] boolValue];
}




- (NSString *)getBinaryByhex:(NSData *)data
{
    
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSMutableString *mutString = [[NSMutableString alloc]init];
    Byte *dateByte = (Byte *)[data bytes];
    for(int i = 0; i < data.length;i++){
        [mutString appendFormat:@"%@", [NSString stringWithFormat:@"%0x",dateByte[i]]];
    }
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    for (int i=0; i<[mutString length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [mutString substringWithRange:rage];
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        binaryString = (NSMutableString *)[NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
    }
    
    NSMutableString *str0 = [NSMutableString stringWithString:@"0000"];
    if(binaryString.length < 8){
    
        [str0 appendString:binaryString];
    }else{
        str0 = binaryString;
    }
    return str0;
}

- (NSData *)getHexBybinary:(NSString *)binary{
    
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0" forKey:@"0000"];
    
    [hexDic setObject:@"1" forKey:@"0001"];
    
    [hexDic setObject:@"2" forKey:@"0010"];
    
    [hexDic setObject:@"3" forKey:@"0011"];
    
    [hexDic setObject:@"4" forKey:@"0100"];
    
    [hexDic setObject:@"5" forKey:@"0101"];
    
    [hexDic setObject:@"6" forKey:@"0110"];
    
    [hexDic setObject:@"7" forKey:@"0111"];
    
    [hexDic setObject:@"8" forKey:@"1000"];
    
    [hexDic setObject:@"9" forKey:@"1001"];
    
    [hexDic setObject:@"10" forKey:@"1010"];
    
    [hexDic setObject:@"11" forKey:@"1011"];
    
    [hexDic setObject:@"12" forKey:@"1100"];
    
    [hexDic setObject:@"13" forKey:@"1101"];
    
    [hexDic setObject:@"14" forKey:@"1110"];
    
    [hexDic setObject:@"15" forKey:@"1111"];
    NSMutableData *HexData=[[NSMutableData alloc] init];

    int X = 0;
    for (int i = 0; (i+4) <= [binary length]; i = i+4) {
        NSRange rage;
        rage.length = 4;
        rage.location = i;
        NSString *key = [binary substringWithRange:rage];
        if(i == 0){
            X += [[hexDic objectForKey:key] intValue]*16;
        }else{
            X += [[hexDic objectForKey:key] intValue];
        }
    }
    
    char input[] = {X};
    NSData *data = [NSData dataWithBytes:input length:sizeof(input)];
    [HexData appendData:data];
    return HexData;
}


//abcdef  转成 10 11 12 13 14 15
- (NSString*)charToInt:(NSString *)S{
    if([S isEqualToString:@"a"]||[S isEqualToString:@"A"]){
        S = @"10";
    }
    else if([S isEqualToString:@"b"]||[S isEqualToString:@"B"]){
        S = @"11";
    }
    else  if([S isEqualToString:@"c"]||[S isEqualToString:@"C"]){
        S = @"12";
    }
    else  if([S isEqualToString:@"d"]||[S isEqualToString:@"D"]){
        
        S = @"13";
    }
    else if([S isEqualToString:@"e"]||[S isEqualToString:@"E"]){
        S = @"14";
    }
    else if([S isEqualToString:@"f"]||[S isEqualToString:@"F"]){
        S = @"15";
    }
    return S;
}
- (NSData *)hex2data:(NSString *)hex {

    NSMutableData *data = [NSMutableData dataWithCapacity:hex.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < hex.length / 2; i++) {
        byte_chars[0] = [hex characterAtIndex:i*2];
        byte_chars[1] = [hex characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
    
}

- (void)pushWithLinkCenterDevice{
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
//        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = Local(@"Connect the device Wi-Fi is successful, click back to APP.");
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 0;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

//获取文本高度
- (CGFloat)getStrHeiWithString:(NSString *)string width:(CGFloat)width font:(CGFloat)font{

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//制造镂空效果
- (void)creatHollowInMap:(UIView *)map withHollowRect:(CGRect)hollowRect color:(UIColor*)color handleBlock:(void (^ )(void))hand{
    
    UIView *Bgview = [[UIView alloc]initWithFrame:map.bounds];
    Bgview.backgroundColor = color;
    //创建一个全屏大的path111
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:map.bounds];
    //创建一个方形的 path
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:hollowRect];
    [path appendPath:rectPath];
    CAShapeLayer *SPlayer = [CAShapeLayer layer];
    
    SPlayer.path = path.CGPath;
    SPlayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则 这里采用的是奇偶规则
    SPlayer.fillColor = [UIColor grayColor].CGColor;
    SPlayer.opacity = 0.8;
    Bgview.layer.mask = SPlayer;
    Bgview.layer.masksToBounds = NO;
    [map addSubview:Bgview];
    self.hollow = hand;
    Bgview.userInteractionEnabled = YES;
    UIView *actionView = [[UIView alloc]initWithFrame:hollowRect];
    actionView.backgroundColor = [UIColor clearColor];
    actionView.userInteractionEnabled = YES;
    [Bgview addSubview:actionView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissSelfView:)];
    [actionView addGestureRecognizer:tap];
}

- (void)disMissSelfView:(UITapGestureRecognizer *)tap{

    if(self.hollow){
        self.hollow();
        self.hollow = nil;
    }
    [tap.view.superview removeFromSuperview];
    [tap.view removeFromSuperview];
}

@end
