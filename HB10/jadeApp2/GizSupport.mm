//
//  GziSupport.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/7.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "GizSupport.h"
#import "JDAppGlobelTool.h"
#import "FunSupport.h"
#import "DeviceInfoModel.h"
#import "JPushSupport.h"
#import "GWNet.h"
#import <GWP2P/GWP2P.h>


#define SDK [GizWifiSDK sharedInstance]
typedef void(^Succeed)(void);        //默认不带任何参数
typedef void(^Failed)(NSString *);   //返回失败原因
typedef void(^Call)(NSDictionary *);


@interface GizSupport ()

@property (nonatomic,copy)Succeed suc;

@property (nonatomic,copy)Failed fai;

@property (nonatomic,copy)Succeed GetTestCodeSuc,registerSuc,ReplacePswSuc,ChangePasswordSuc,LoginSuc,AirLinkSuc,SoftAPSuc,FindDeviceSuc,DeviceLineSuc,BindDeviceSuc,UnbindDeviceSuc,DeviceLoginSuc,GetDeviceHardSuc,ModifyDeviceNameSuc,GetServiceSuc;

@property (nonatomic,copy)Failed GetTestCodeFai,registerFai,ReplacePswFai,ChangePasswordFai,LoginFai,AirLinkFai,SoftAPFai,FindDeviceFai,DeviceLineFai,BindDeviceFai,UnbindDeviceFai,GetDeviceHardFai,ModifyDeviceNameFai,GetServiceFai;



@property (nonatomic,copy)Call call;
@property (nonatomic,copy)Call SendOrderCall,GetDeviceStateCall;



@property (nonatomic,strong) UIViewController *Vc;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,strong) NSDictionary *binaryDict;

@end

@implementation GizSupport
{
    BOOL isDiscoverLock;
    NSString *_buffName;
    NSString *_buffPsw;

}

+ (GizSupport*)sharedGziSupprot{
    static GizSupport* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[GizSupport alloc] init];
        [GizWifiSDK sharedInstance].delegate = sharedSupport;
    });
    return sharedSupport;
}

- (NSDictionary*) productInfo{

    return [NSDictionary dictionaryWithObjectsAndKeys:@"4c245d27d6c64efdb8e5727f956f97ad", @"6931177c6802488787e4af52581730b3",@"170a1a16f8b842a9a2f392067bd66635", @"58aa9e10ae2d4d788507226d718cb8d1",@"e9a729af199b4171ba1208dd37159fc2", @"a072d3ba727a46c7a00f31f1a8e14cc0",@"169ae55ba304484196272b4035946259",@"d57fda00a50e40b393a6a4b8992a51d1",@"440359e62f954cf988cd7d9eb051393a",@"7138fa0fd7ff45b4b3d9c49d2da35caa", nil];
    
    // 7138fa0fd7ff45b4b3d9c49d2da35caa key    440359e62f954cf988cd7d9eb051393a   探测器
}

#pragma mark -- get set 
- (NSMutableArray *)dataArr{

    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (NSDictionary *)binaryDict{

    if(!_binaryDict){
        _binaryDict = [[NSDictionary alloc]init];
    }
    return _binaryDict;
}


- (NSDictionary *)dataDict{
    
    if(!_dataDict){
        _dataDict = [[NSDictionary alloc]init];
    }
    return _dataDict;
}

- (void)setDeviceList:(NSMutableArray *)deviceList{
    //这里 有的设备已经添加了子设备，所以不能直接更改 ，应该采用替换的方式
    if(!_deviceList){
        _deviceList = [[NSMutableArray alloc]init];
    }
    for (int i = 0; i < deviceList.count ; i++) {
        GizWifiDevice *device = deviceList[i];
        int k = 0;
        for(int j = 0;j < _deviceList.count;j++){
            DeviceInfoModel *oldModel = _deviceList[j];
            if([oldModel.gizDevice.did isEqualToString:device.did]){
                oldModel.gizDevice = device;
                k++;
            }
        }
        if(k == 0){  //说明这是一个新的设备
            DeviceInfoModel *model = [[DeviceInfoModel alloc]init];
            model.gizDevice = deviceList[i];
            [_deviceList addObject:model];
        }
    }
}

- (void)setIsLogined:(BOOL)isLogined
{
    _isLogined = isLogined;
    if(!_isLogined){
        self.GizUserName = nil;
        self.GizUserPassword = nil;
        self.GizToken = nil;
        self.GizUid = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:GizLogOutSuc object:nil];
        [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
        } failed:^(NSString *) {
        }];
    }else{
        //绑定推送
        [self gizBindPush];
        //刷新she bei
        [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
        } failed:^(NSString *) {
        }];
    }
    //将密码保存在本地
    [[NSUserDefaults standardUserDefaults] setObject:self.GizUserName forKey:JadeUserName];
    [[NSUserDefaults standardUserDefaults] setObject:self.GizUserPassword forKey:jadeUserPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //对比新存储的密码  如果不一样 说明是切换账户了
    if(![self.GizUserName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:JadeUserName]] && self.GizUserName){
        //发送通知 告知是新登陆的用户
        [[NSNotificationCenter defaultCenter] postNotificationName:OtherNewUserLogin object:nil];
    }


}

- (void)initSDK{
//    [GizWifiSDK startWithAppID:XPGAppID specialProductKeys:nil cloudServiceInfo:nil autoSetDeviceDomain:YES];
    
    [GizWifiSDK startWithAppID:XPGAppID appSecret:XPGAppSecret specialProductKeys:nil cloudServiceInfo:nil autoSetDeviceDomain:YES];
    [GizWifiSDK setLogLevel:GizLogPrintNone];
    
    [self gizGetCurrentServiceSucceed:^{
        
    } failed:^(NSString *) {

    }];
}

- (void)gizBindPush{
    if(self.GizToken){
        [[GizWifiSDK sharedInstance] channelIDBind:self.GizToken channelID:[JPushSupport JPushGetId] alias:nil pushType:GizPushJiGuang];
    }
}

- (void)gizGetCurrentServiceSucceed:(void (^ )(void))Sucsse
                          failed:(void (^ )(NSString*))failed{
    [GizWifiSDK sharedInstance].delegate = self;
     [GizWifiSDK getCurrentCloudService];
    self.GetServiceSuc = Sucsse;
    self.GetServiceFai = failed;
}

- (void)setGizCurrentDevice:(GizWifiDevice *)gizCurrentDevice{
    _gizCurrentDevice = gizCurrentDevice;
    _gizCurrentDevice.delegate = self;
}

//通过手机获取短讯验证码
- (void)gizGetTestCodeWithPhone:(NSString *)phoneNum
                        Succeed:(void (^ )(void))Sucsse
                         failed:(void (^ )(NSString*))failed{

    [GizWifiSDK sharedInstance].delegate = self;
    [[GizWifiSDK sharedInstance] requestSendPhoneSMSCode:XPGAppSecret
                                                   phone:phoneNum];
    

    
    self.GetTestCodeSuc = Sucsse;
    self.GetTestCodeFai = failed;
}

//手机号加验证码注册
- (void)gizregisterWithPhone:(NSString *)phone
                    testCode:(NSString *)testCode
                    password:(NSString *)psw
                     Succeed:(void (^ )(void))Sucsse
                      failed:(void (^ )(NSString*))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] registerUser:phone
                                     password:psw
                                   verifyCode:testCode
                                  accountType:GizUserPhone];
    self.registerSuc = Sucsse;
    self.registerFai = failed;
}

//重置密码
- (void)gizReplacePswWithTestCode:(NSString *)testCode
                         userName:(NSString *)userName
                      newPassword:(NSString *)newPsw
                             type:(GizUserAccountType)userType
                          Succeed:(void (^ )(void))Sucsse
                           failed:(void (^ )(NSString*))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] resetPassword:userName
                                    verifyCode:testCode
                                   newPassword:newPsw
                                   accountType:userType];
  
    self.ReplacePswSuc = Sucsse;
    self.ReplacePswFai = failed;

}

//密码修改
- (void)gizChangePasswordWithOldPassWord:(NSString *)oldPsw
                             newPassword:(NSString *)newPsw
                                 Succeed:(void (^ )(void))Sucsse
                                  failed:(void (^ )(NSString *))failed{
    [GizWifiSDK sharedInstance].delegate = self;
    [[GizWifiSDK sharedInstance] changeUserPassword:self.GizToken
                                        oldPassword:oldPsw
                                        newPassword:newPsw];
    self.ReplacePswSuc = Sucsse;
    self.ReplacePswFai = failed;
}


//邮箱用户注册
- (void)gizRegisteWithUserName:(NSString *)userName
                      password:(NSString *)password
                       Succeed:(void (^ )(void))Sucsse
                        failed:(void (^ )(NSString *))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] registerUser:userName
                                     password:password
                                   verifyCode:nil
                                  accountType:GizUserEmail];
    self.registerSuc = Sucsse;
    self.registerFai = failed;
}

//登录
- (void)gizLoginWithUserName:(NSString *)userName
                    password:(NSString *)password
                     Succeed:(void (^ )(void))Sucsse
                      failed:(void (^ )(NSString *))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] userLogin:userName password:password];
    _buffName = userName;
    _buffPsw = password;
    self.LoginSuc = Sucsse;
    self.LoginFai = failed;
}

//airlink 模式
- (void)gizSetDeviceWifiAirLinkAtViewControll:(UIViewController *)Vc
                                     WiFiName:(NSString *)wifiName
                                 WiFiPassword:(NSString *)PSW
                               wifiGAgentType:(GizWifiGAgentType)GAgentType
                                      Succeed:(void (^ )(void))Sucsse
                                       failed:(void (^ )(NSString *))failed
{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] setDeviceOnboarding:wifiName key:PSW configMode:GizWifiAirLink softAPSSIDPrefix:nil timeout:60 wifiGAgentType:@[@(GizGAgentRTK),@(GizGAgentESP)]];
    
    self.AirLinkSuc = Sucsse;
    self.AirLinkFai = failed;

}
//softAP 模式
- (void)gizSetDeviceWifiSoftAPAtViewControll:(UIViewController *)Vc
                                    WiFiName:(NSString *)wifiName
                                WiFiPassword:(NSString *)PSW
                              wifiGAgentType:(GizWifiGAgentType)GAgentType
                                     Succeed:(void (^ )(void))Sucsse
                                      failed:(void (^ )(NSString *))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    [[GizWifiSDK sharedInstance] setDeviceOnboarding:wifiName key:PSW configMode:GizWifiSoftAP softAPSSIDPrefix:JDGizDeviceSoftAPWiFi timeout:60000 wifiGAgentType:@[@(GAgentType)]];
    self.SoftAPSuc = Sucsse;
    self.SoftAPFai = failed;
}


- (void)gizFindDeviceSucceed:(void (^ )(void))Sucsse failed:(void (^ )(NSString *))failed{
    //防止操作中点了以后卡主线程。
    if(isDiscoverLock){
        return;
    }
    [GizWifiSDK sharedInstance].delegate = self;

    isDiscoverLock = YES;
    [[GizWifiSDK sharedInstance] getBoundDevices:self.GizUid token:self.GizToken specialProductKeys:nil];
    self.FindDeviceSuc = Sucsse;
    self.FindDeviceFai = failed;
}

- (void)gizDeviceLineWithDevice:(DeviceInfoModel *)device Succeed:(void (^ )(void))Sucsse failed:(void (^ )(NSString *))failed{
    device.gizDevice.delegate = self;
    
//    [[GizWifiSDK sharedInstance] bindRemoteDevice:@"559d9f2360424f9f9600abe0c9cf88eb" token:@"65d94299b59e4d52bd6fa61a23e87da9" mac:@"60019423ADA0" productKey:@"6931177c6802488787e4af52581730b3" productSecret:@"4c245d27d6c64efdb8e5727f956f97ad"];
    
    [[GizWifiSDK sharedInstance] bindRemoteDevice:self.GizUid token:self.GizToken mac:device.gizDevice.macAddress productKey:device.gizDevice.productKey productSecret:self.productInfo[device.gizDevice.productKey]];
    self.DeviceLineSuc = Sucsse;
    self.DeviceLineFai = failed;
}

- (void)gizBindDeviceWithQRcodeString:(NSString *)QRcodeString Succeed:(void (^ )(void))Sucsse failed:(void (^ )(NSString *))failed{
//    NSDictionary *dict = [[JDAppGlobelTool shareinstance]getScanResult:QRcodeString];
//    NSString *did = [dict valueForKey:@"did"];
//    NSString *passcode = [dict valueForKey:@"passcode"];
//    [GizWifiSDK sharedInstance] bindRemoteDevice:<#(NSString *)#> token:<#(NSString *)#> mac:<#(NSString *)#> productKey:<#(NSString *)#> productSecret:<#(NSString *)#>
//    [[GizWifiSDK sharedInstance] bindDeviceWithUid:self.GizUid token:self.GizToken did:did passCode:passcode remark:nil];
    
    NSArray *arr = [QRcodeString componentsSeparatedByString:@"|"];
    if (arr.count < 3){
        DLog(@"分享失败哟");
    }
    for (int i = 0 ; i<arr.count; i++) {
        if (!arr[i]){
            [SVProgressHUD showErrorWithStatus:Local(@"Failed")];
            return;
        }
    }
//    [[GizWifiSDK sharedInstance] bindRemoteDevice:self.GizUid token:self.GizToken mac:arr[0] productKey:arr[1]  productSecret:arr[2]];
    
    self.BindDeviceSuc = Sucsse;
    self.BindDeviceFai = failed;
}

//解绑
- (void)gizUnbindDeviceWithDeviceDid:(DeviceInfoModel *)device Succeed:(void (^ )(void))Sucsse{
    [GizWifiSDK sharedInstance].delegate = self;
    
    [[GizWifiSDK sharedInstance] unbindDevice:self.GizUid token:self.GizToken did:device.gizDevice.did];
    self.UnbindDeviceSuc = Sucsse;
}


- (void)gizDeviceLoginWithDevice:(DeviceInfoModel *)device Succeed:(void (^ )(void))Sucsse{
    //如果没有设置委托，则设置委托到当前使用的Cocoa类所对应的实例
    //需要开发者自行把 uid 和 token 换成实际的值
    device.gizDevice.delegate = self;
    if(!device.gizDevice.isSubscribed){
        [device.gizDevice setSubscribe:device.gizDevice.productKey subscribed:YES];
    }
    self.DeviceLoginSuc = Sucsse;
}

- (void)gizGetDeviceHardwareInfo:(DeviceInfoModel *)device Succeed:(void (^ )(void))Sucsse failed:(void (^ )(NSString *))failed{
    [GizWifiSDK sharedInstance].delegate = self;

    if(!device.gizDevice.isSubscribed){
        [device.gizDevice setSubscribe:device.gizDevice.productKey subscribed:YES];
    }
    device.gizDevice.delegate = self;
    [device.gizDevice getHardwareInfo];
    self.GetDeviceHardSuc = Sucsse;
    self.GetDeviceHardFai = failed;
}

//发送信息
- (void)gizSendOrderWithSN:(int)sn device:(DeviceInfoModel *)device withOrder:(NSDictionary *)order callBack:(void (^ )(NSDictionary*))sendCall{
    
//  一旦调用这个函数，打上Gi 中的标签
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"gizForcJSON"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//  对已订阅变为可控状态的设备
    device.gizDevice.delegate = self;
    if(device.gizDevice.netStatus == GizDeviceControlled){
        [device.gizDevice write:order withSN:sn];
    }else{
//  非可控状态  订阅
        [device.gizDevice setSubscribe:device.gizDevice.productKey subscribed:YES];
        self.suc = ^{
            [device.gizDevice write:order withSN:sn];
        };
    }
    self.SendOrderCall = sendCall;
}

- (void)gizGetDeviceStatesWithSN:(int)sn
                          device:(DeviceInfoModel *)device
                        callBack:(void (^ )(NSDictionary*))call{
    
    device.gizDevice.delegate = self;

    [device.gizDevice getDeviceStatus:nil];
    self.SendOrderCall = call;
}

//  更改设备的名字
- (void)gizModifyDeviceNameWithDevice:(DeviceInfoModel *)device
                                 name:(NSString *)name
                              Succeed:(void (^ )(void))Sucsse
                               failed:(void (^ )(NSString *))failed{
    device.gizDevice.delegate = self;
    [device.gizDevice setCustomInfo:nil alias:name];
    self.ModifyDeviceNameSuc = Sucsse;
    self.ModifyDeviceNameFai = failed;
}

#pragma mark - delegate
//获取  改变服务器回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didGetCurrentCloudService:(NSError *)result cloudServiceInfo:(NSDictionary *)cloudServiceInfo{
    
    if(result.code == GIZ_SDK_SUCCESS){
        if(self.GetServiceSuc){
            
            NSLog(@"%@",cloudServiceInfo);
            self.GetServiceSuc();
            self.GetServiceSuc = nil;
        }
    }else{
        if(self.GetServiceFai){
            self.GetServiceFai([self getErrStringWithRsult:result]);
            self.GetServiceFai = nil;
        }
    }
    
}
//  验证码获取的回调接口
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError *)result token:(NSString *)token{
    if(result.code == GIZ_SDK_SUCCESS){
        //获取验证码成功
        if(self.GetTestCodeSuc){
            self.GetTestCodeSuc();
        }
    }
    else{
        if(self.GetTestCodeFai){
            self.GetTestCodeFai([self getErrStringWithRsult:result]);
        }
    }
}

//  重置密码 回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChangeUserPassword:(NSError *)result{
    
    if(result.code == GIZ_SDK_SUCCESS){
        //获取验证码成功
        if(self.ReplacePswSuc){
            self.ReplacePswSuc();
            self.ReplacePswSuc = nil;
        }
    }
    else
    {
        if(self.ReplacePswFai){
            self.ReplacePswFai([self getErrStringWithRsult:result]);
            self.ReplacePswFai = nil;
        }
    }
}

//  注册接口回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token{
    if(result.code == GIZ_SDK_SUCCESS)
    {
        //注册成功，可以成功获取到 uid 和 token
        [GizSupport sharedGziSupprot].GizUid = uid;
        [GizSupport sharedGziSupprot].GizToken = token;
        if(self.registerSuc){
            self.registerSuc();
        }
        NSLog(@"机智云注册成功,uid%@ token %@",uid,token);
        
    }
    else{
        if(self.registerFai){

            self.registerFai([self getErrStringWithRsult:result] );
        }
    }
}

- (NSString *)getErrStringWithRsult:(NSError *)err{
    NSDictionary *dict = err.userInfo;
    return  dict[@"NSLocalizedDescription"];
}

//登录接口回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token
{
    if(result.code == GIZ_SDK_SUCCESS){
        [GizSupport sharedGziSupprot].GizUid = uid;
        [GizSupport sharedGziSupprot].GizToken = token;
        [GizSupport sharedGziSupprot].isLogined = YES;
        if(_buffName){
            [GizSupport sharedGziSupprot].GizUserName = _buffName;
            [GizSupport sharedGziSupprot].GizUserPassword = _buffPsw;
            _buffPsw = nil;
            _buffName = nil;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:GizLoginSuc object:nil];
        });
        if(self.LoginSuc){
            self.LoginSuc();
        }
        NSLog(@"机智云登录成功,uid%@ token %@",uid,token);
        //有看头登录
        [self logYoosee:token];
        
    }else{
        if(self.LoginFai){
            self.LoginFai([self getErrStringWithRsult:result]);
        }
    }
}


//有看头登录
- (void)logYoosee:(NSString *)token{
    
    NSString * tk = token ? token : self.GizToken;
    
    [GWNetSingleton  thirdLoginWithPlatformType:@"2" withUnionID:tk withUser:[GizSupport sharedGziSupprot].GizUserName withPassword:[GizSupport sharedGziSupprot].GizUserPassword withAppleToken:nil withOption:@"3" withStoreID:nil completion:^(BOOL success, NSString *errorCode, NSString *errorString, NSDictionary *json) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //sender.enabled = YES;
            //登录成功后连接P2P
            if ([errorCode isEqualToString:@"0"]) {
                NSString *p2pAccount = [NSString stringWithFormat:@"0%d",[json[@"UserID"] intValue] & 0x7fffffff];
                NSString *p2pVerifyCode1 = json[@"P2PVerifyCode1"];
                NSString *p2pVerifyCode2 = json[@"P2PVerifyCode2"];
                NSString *sessionID1 = json[@"SessionID"];
                NSString *sessionID2 = json[@"SessionID2"];
                //这个连接返回的结果只是指本地处理结果。因为和P2P服务器的连接是异步的,需要通过GWP2PClient的linkStatus属性判断当前与P2P服务器的连接状态。在本地成功而linkStatus异常的情况下可以控制局域网内的设备。
                BOOL success = [[GWP2PClient sharedClient] connectWithAccount:p2pAccount codeStr1:p2pVerifyCode1 codeStr2:p2pVerifyCode2 sessionID1:sessionID1 sessionID2:sessionID2 customerIDs:nil];
                if (success){
                    //跳转到设备列表
                    DLog(@"有看头 登录成功   别忘记了做处理～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～");
                }else{
                    DLog(@"有看头 登录失败   别忘记了做处理～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～");
                }
            }
        });
    }];
}

- (void)logoutYooseeConnect{
    [[GWP2PClient sharedClient] disconnect];
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChannelIDBind:(NSError *)result{

    NSLog(@"绑定推送  --  %ld",(long)result.code);
}



//配置入网设备接口回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError *)result mac:(NSString *)mac did:(NSString *)did productKey:(NSString *)productKey{
    if(result.code == GIZ_SDK_SUCCESS){
        //配置成功
        NSLog(@"配置成功 %@-",productKey);
        if(self.AirLinkSuc){
            self.AirLinkSuc();
            self.AirLinkSuc = nil;
        }
        else if(self.SoftAPSuc){
            self.SoftAPSuc();
            self.SoftAPSuc = nil;
        }
    }else if(result.code == GIZ_SDK_DEVICE_CONFIG_IS_RUNNING){
        NSLog(@"设备正在配置");
    }
    else
    {
        NSLog(@"配置出了问题啊");
        //配置失败
        if(self.AirLinkFai){
            self.AirLinkFai([self getErrStringWithRsult:result]);
            self.AirLinkFai = nil;
        }
        else if(self.SoftAPFai){
            self.SoftAPFai([self getErrStringWithRsult:result]);
            self.SoftAPFai = nil;
        }
    }
    NSLog(@"%@  配置结果 ",result);

}

//搜索设备回调  列表  在这里一般会自己调用
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError *)result deviceList:(NSArray *)deviceList {
    if(result.code == GIZ_SDK_SUCCESS){
        //设置设备列表
        [[NSNotificationCenter defaultCenter] postNotificationName:GizDeviceRefrsh object:nil];

        NSLog(@"云端设备有 %lu 个",(unsigned long)deviceList.count);
        self.deviceList = (NSMutableArray*)deviceList;
        if(self.FindDeviceSuc){
            self.FindDeviceSuc();
        }
        //此处刷新是为了 在设备的状态被改变的时候进行实时汇报   比如： 有设备断线， 有设备上线等  都会触发在云端的设备集合。 这里可以获取到。
        
        //有可能是设备自动上报的情况

    }else{
    
        if(self.FindDeviceFai){
            self.FindDeviceFai([self getErrStringWithRsult:result]);
        }
    }
    isDiscoverLock = NO;
}

//绑定设备回调
- (void)wifiSDK:(GizWifiSDK*)wifiSDK didBindDevice:(NSError*)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS)
    {
        //绑定成功   刷新列表
        NSLog(@"绑定成功  %@",did);
        [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
            if(self.BindDeviceSuc){
                self.BindDeviceSuc();
            }
        } failed:^(NSString *) {
            
        }];
    }else{
        NSLog(@"绑定失败  %@",did);
        //绑定失败
        if(self.BindDeviceFai){
            self.BindDeviceFai([self getErrStringWithRsult:result]);
        }
    }
}

//解除绑定
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did{
    
    //刷新所以的中空设备列表
    if(result.code == GIZ_SDK_SUCCESS){
       [self gizFindDeviceSucceed:^{
           if(self.UnbindDeviceSuc){
               self.UnbindDeviceSuc();
           }
        } failed:^(NSString *) {
            
        }];
    }else{
       //失败不做任何动作
    }
}


//订阅设备回调
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed{
    if(result.code == GIZ_SDK_SUCCESS){
        NSLog(@"订阅成功");
        if(self.DeviceLoginSuc){
            self.DeviceLoginSuc();
        }
    }else{
    
        //失败不做任何动作
    }
}



- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result{

    if(result.code == GIZ_SDK_SUCCESS) {
        NSLog(@"%@",device.alias);
        if(self.ModifyDeviceNameSuc){
            DeviceInfoModel *model = [[DeviceInfoModel alloc]init];
            model.gizDevice = device;
            [self gizGetDeviceStatesWithSN:0 device:model callBack:^(NSDictionary *data) {
                
            }];
            self.ModifyDeviceNameSuc();
        }
    }else{
        if(self.ModifyDeviceNameFai){
            self.ModifyDeviceNameFai([self getErrStringWithRsult:result]);
        }
    }
}


//获取硬件信息回调
- (void)device:(GizWifiDevice *)device didGetHardwareInfo:(NSError *)result hardwareInfo:(NSDictionary *)hardwareInfo
{
    if(result.code == GIZ_SDK_SUCCESS){
        if(self.GetDeviceHardSuc){
            self.GetDeviceHardSuc();
        }
        NSString *hardWareInfo1 = [NSString stringWithFormat:@"WiFi Hardware Version: %@\n WiFi Software Version: %@\n MCU Hardware Version: %@\n MCU Software Version: %@\nFirmware Id: %@\nFirmware Version: %@\nProduct Key: %@\nDevice ID: %@\nDevice IP: %@\nDevice MAC: %@"
                                   , ![hardwareInfo valueForKey: @"wifiHardVersion"]?@"":[hardwareInfo valueForKey: @"wifiHardVersion"]
                                   , ![hardwareInfo valueForKey: @"wifiSoftVersion"]?@"":[hardwareInfo valueForKey: @"wifiSoftVersion"]
                                   , ![hardwareInfo valueForKey: @"mcuHardVersion"]?@"":[hardwareInfo valueForKey: @"mcuHardVersion"]
                                   , ![hardwareInfo valueForKey: @"mcuSoftVersion"]?@"":[hardwareInfo valueForKey: @"mcuSoftVersion"]
                                   , ![hardwareInfo valueForKey: @"firmwareId"]?@"":[hardwareInfo valueForKey: @"firmwareId"]
                                   , ![hardwareInfo valueForKey: @"firmwareVer"]?@"":[hardwareInfo valueForKey: @"firmwareVer"]
                                   , ![hardwareInfo valueForKey: @"productKey"]?@"":[hardwareInfo valueForKey: @"productKey"]
                                   , device.did, device.ipAddress, device.macAddress];
        [[[UIAlertView alloc] initWithTitle:Local(@"Device hardware information")
                                    message:hardWareInfo1 delegate:self cancelButtonTitle:Local(@"OK")
                          otherButtonTitles:nil, nil] show];
    }else{
        
        if(self.GetDeviceHardFai){
            self.GetDeviceHardFai([self getErrStringWithRsult:result]);
        }
    }

  }

//发送指令结果回调  接受指令也在这里
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary *)dataMap withSN:(NSNumber *)sn {

    //只要捕获到有效信息就传递 这里的有效数据包含了：  1. 纯数据点数据   2. 纯透传数据
    if(result.code == GIZ_SDK_SUCCESS) {
        [dataMap setValue:sn forKey:@"sn"];
        [dataMap setValue:device forKey:@"device"];
        //除了发送通知之外 还会出发回调
        if([dataMap[@"data"] allKeys].count > 0){
            if(self.SendOrderCall){
                self.SendOrderCall(dataMap);
                self.SendOrderCall = nil;
            }
            for (DeviceInfoModel *deviceM in self.deviceList) {
                if( [device.did isEqualToString:deviceM.gizDevice.did]){
                    [deviceM getData:dataMap];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GizGetDeviceData object:nil userInfo:dataMap];
        }else if ([[dataMap allKeys] containsObject:@"binary"]){
            //过滤
            [[NSNotificationCenter defaultCenter] postNotificationName:GizGetDeviceData object:nil userInfo:dataMap];
            for (DeviceInfoModel *deviceM in self.deviceList) {
                if( [device.did isEqualToString:deviceM.gizDevice.did]){
                    [deviceM getData:dataMap];
                }
            }
        }
    }
    //带SN事件处理
    if([sn intValue] == DeleteSubDeviceSN){
      
        //删除子设备之后的回调
        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteSubdeviceSuc object:nil userInfo:dataMap];
    }
}



@end
