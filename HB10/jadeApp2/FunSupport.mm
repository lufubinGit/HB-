////
////  FunSupport.m
////  FunSDKDemo
////
////  Created by lufubin on 16/5/10.
////  Copyright © 2016年 jadeiot. All rights reserved.
////
//
#import "FunSupport.h"
#import "objc/runtime.h"
//
////
////@implementation DevInfo
////
////@end
////
////typedef void(^XmeyeResult)(NSString *);
////@interface FunSupport ()
////@property (nonatomic,copy)XmeyeResult result;
////
////@end
//



//
@implementation FunSupport
//
//+ (FunSupport*)sharedFunSupprot
//{
//    static FunSupport* sharedSupport = nil;
//    
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        
//        sharedSupport = [[self alloc] init];
//
//    });
////    FUN_DebugInfo(<#FUN_HANDLE hObj#>, <#char *szBuffer#>, <#int nMaxSize#>)
//    return sharedSupport;
//}
////初始化
//- (int)alarmNetinit:(NSString*)deviceToken
//           UserName:(NSString*)userName
//           Password:(NSString*)password;
//{
//    if (userName == nil) {
//        return -1;
//    }
//    if (password == nil) {
//        password = @"";
//    }
//    if (deviceToken.length == 0) {
//        deviceToken = @"<1854c4b2 8f1ecc05 474fb2d9 63788b2d dd18418a b75bf2df "
//        @"92892201 7771e9b2>";
//    }
//    NSString* token = [[deviceToken substringFromIndex:1] substringToIndex:71];
//    NSString* str =
//    [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    //将token发送至服务器
//    const char* tokenChar = [str UTF8String];
//    
//    SMCInitInfo pinfo = { 0 };
//    STRNCPY(pinfo.user, SZSTR(userName));
//    STRNCPY(pinfo.password, SZSTR(password));
//    STRNCPY(pinfo.token, (const char*)tokenChar);
//    
//    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString* bundleIdentifiler =
//    [infoDictionary objectForKey:@"CFBundleIdentifier"];
//    STRNCPY(pinfo.szAppType, [bundleIdentifiler UTF8String]);
//    
//    if ([self languageIsChinese]) {
//        pinfo.language = ELG_CHINESE;
//        
//    } else {
//        pinfo.language = ELG_ENGLISH;
//    }
//    
//    pinfo.appType = 101; //正式版本
//    
//    int init_result = MC_Init(self.handle, &pinfo, 0);
//    NSLog(@"init_result =%d", init_result);
//    return init_result;
//}
//
//- (int)initSDK
//{
//    
//    
//    SInitParam pa;
//    pa.nAppType = H264_DVR_LOGIN_TYPE_MOBILE;
//    FUN_Init(0, &pa);
//    [self alarmNetinit:nil UserName:@"" Password:@""];
//    FUN_InitNetSDK();
//    
//    //设置用于存储设备信息等的数据配置文件
//    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(
//                                                             NSCachesDirectory, NSUserDomainMask, YES);
//    NSString* path = [pathArray lastObject];
//    
//    //设置配置文件存储目录
//    FUN_SetFunStrAttr(EFUN_ATTR_CONFIG_PATH,
//                      [[path stringByAppendingString:@"/Configs/"] UTF8String]);
//    //设置升级文件存储目录
//    FUN_SetFunStrAttr(EFUN_ATTR_UPDATE_FILE_PATH,
//                      [[path stringByAppendingString:@"/Updates/"] UTF8String]);
//    //设置临时文件存储目录
//    FUN_SetFunStrAttr(EFUN_ATTR_TEMP_FILES_PATH,
//                      [[path stringByAppendingString:@"/Temps/"] UTF8String]);
//    
//    //填写开放平台申请到的uuid， appkey等。
//    FUN_XMCloundPlatformInit(constStrApiAppUuid, constStrApiAppKey,
//                             constStrApiAppSecret, constIntApiMoveCard);
//    self.handle = FUN_RegWnd((__bridge void*)self);
//
//    
//    //用户注册等相关接口需要先设置下云服务
//    [self setDevListMode:E_DevList_Server];
//    
//    return 0;
//}
//
//- (void)setDevListMode:(int)mode
//{
//    
//    //设置用于存储设备信息等的数据配置文件
//    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(
//                                                             NSCachesDirectory, NSUserDomainMask, YES);
//    NSString* path = [pathArray lastObject];
//    
//    if (E_DevList_Local == mode) {
//        //设置本地登录设备相关信息保存文件的位置
//        FUN_SysInit([[path stringByAppendingString:@"/LocalDevs.db"] UTF8String]);
//    } else if (E_DevList_Server == mode) {
//        //设置云服务
//        FUN_SysInit(constStrServerAddrs, constIntServerPort);
//    } else if (E_DevList_AP == mode) {
//        //设置AP模式(app直连设备热点)下设置设备信息保存文件位置
//        FUN_SysInitAsAPModel(
//                             [[path stringByAppendingString:@"/APDevs.db"] UTF8String]);
//    }
//}
//
//- (void)userlogined:(NSString*)name andPassword:(NSString*)password
//{
//    self.currentUserName = name;
//    self.currentPassword = password;
//    self.isLogined = YES;
//}
//
//- (void)userlogout
//{
//    self.isLogined = NO;
//    self.currentUserName = nil;
//    self.currentPassword = nil;
//}
//
//- (void)deviceUpdated:(SDBDeviceInfo*)dev andCount:(int)count
//{
//    
//    if (!self.arrayDevList) {
//        self.arrayDevList = [[NSMutableArray alloc] initWithCapacity:100];
//    }
//    [self.arrayDevList removeAllObjects];
//    
//    for (int i = 0; i < count; i++) {
//        SDBDeviceInfo* pDevInfo = &dev[i];
//        [self deviceAdded:pDevInfo];
//    }
//}
//
//- (void)deviceAdded:(SDBDeviceInfo*)dev
//{
//    DevInfo* devinfo = [[DevInfo alloc] init];
//    devinfo.ip = [NSString stringWithUTF8String:dev->devIP];
//    devinfo.name = [NSString stringWithUTF8String:dev->Devname];
//    devinfo.sn = [NSString stringWithUTF8String:dev->Devmac];
//    devinfo.username = [NSString stringWithUTF8String:dev->loginName];
//    devinfo.password = [NSString stringWithUTF8String:dev->loginPsw];
//    devinfo.type = dev->nType;
//    devinfo.port = dev->nPort;
//    if (!self.arrayDevList) {
//        self.arrayDevList = [[NSMutableArray alloc] initWithCapacity:100];
//    }
//    [self.arrayDevList addObject:devinfo];
//}
//
//- (int)handle
//{
//    if(!_handle){
//        _handle = FUN_RegWnd((__bridge void*)self);
//    }
//    return _handle;
//}
//
//- (void)deviceRemoved:(NSString*)sn
//{
//    
//    if (!self.arrayDevList) {
//        return;
//    }
//    for (DevInfo* devInfo in self.arrayDevList) {
//        if ([devInfo.sn isEqualToString:sn]) {
//            [self.arrayDevList removeObject:devInfo];
//        }
//    }
//}
//
//- (void)searchDeviceWithTimeout:(int)timeout
//                      andTarget:(id)tar
//                      andAction:(SEL)sel
//{
//    self.searchDevListener = tar;
//    self.searchDevAction = sel;
//    
//    FUN_DevSearchDevice(self.handle, timeout, 0);
//}
//
//- (void)cancelSearchDevice
//{
//    self.searchDevListener = nil;
//    self.searchDevAction = nil;
//}
//
//- (void)OnFunSDKResult:(NSNumber*)pParam
//{
//    NSInteger nAddr = [pParam integerValue];
//    MsgContent* msg = (MsgContent*)nAddr;
//    self.resultMsg = [NSString stringWithUTF8String:msg->szStr];
//
//    switch (msg->id) {
//            NSLog(@"buzo ??/");
//        case EMSG_DEV_SEARCH_DEVICES: {
//            self.arrayDevSearchedList = [[NSMutableArray alloc]init];
//            struct SDK_CONFIG_NET_COMMON_V2* netCommonBuf =
//            (struct SDK_CONFIG_NET_COMMON_V2*)msg->pObject;
//            for (int i = 0; i < msg->param2; ++i) {
//                DevInfo* devinfo = [[DevInfo alloc] init];
//                devinfo.ip = [NSString stringWithFormat:@"%d.%d.%d.%d",
//                              netCommonBuf[i].HostIP.c[0],
//                              netCommonBuf[i].HostIP.c[1],
//                              netCommonBuf[i].HostIP.c[2],
//                              netCommonBuf[i].HostIP.c[3]];
//                devinfo.name = [NSString stringWithUTF8String:netCommonBuf[i].HostName];
//                devinfo.sn = [NSString stringWithUTF8String:netCommonBuf[i].sSn];
//                devinfo.username = @"admin";
//                devinfo.password = @"";
//                devinfo.type = netCommonBuf[i].DeviceType;
//                devinfo.port = netCommonBuf[i].TCPPort;
//                [self.arrayDevSearchedList addObject:devinfo];
//
//                
////                if(!_arrayDevSearchedList.count){
////                    for (DevInfo* dev in self.arrayDevSearchedList) {
////                        if(![devinfo.sn isEqualToString:dev.sn]){
////                            [self.arrayDevSearchedList addObject:devinfo];
////                        }
////                    }
////
////                }else{
////                    [self.arrayDevSearchedList addObject:devinfo];
////
////                }
//                
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    [self XmeyeResult:(XmeyeFuctionSeq)msg->seq messageInt:msg->param1 messageStr:[NSString stringWithUTF8String:msg->szStr]];
//}
//
////雄迈方法调用
//
////发送手机验证码
//- (void)XmeyeGetTestCodeWithPhoneNum:(NSString *)phoneNum userName:(NSString *)userName result:(void (^ )(NSString* result))result{
//    if(FUN_SysSendPhoneMsg(self.handle, [phoneNum UTF8String], [userName UTF8String], SendPhoneMessageSeq) == 0){
//        self.result = result;
//    }
//}
//
////手机验证码注册
//- (void)XmeyeRegisteWithUserName:(NSString *)userName password:(NSString *)password phoneNum:(NSString *)phoneNum tectCode:(NSString *)testCode result:(void (^ )(NSString* result))result{
//    
//    if([password isEqualToString:JadeTestCode]){
//        
//        if(FUN_SysNoValidatedRegister(self.handle,[userName UTF8String],[password UTF8String],RegisterFucSeq) == 0){
//            
//            self.result = result;
//        }
//    }
//    else{
//        if(FUN_SysRegUserToXM(self.handle,[userName UTF8String],[password UTF8String],[testCode UTF8String],[phoneNum UTF8String],RegisterFucSeq) == 0){
//            self.result = result;
//        }
//    }
//}
//
////发送邮箱验证吗
//- (void)XmeyeGetTestCodeWithEmail:(NSString *)email userName:(NSString *)userName result:(void (^ )(NSString* result))result{
//    
//    if(FUN_SysSendEmailCode(self.handle, [email UTF8String], GetEmailtestCodeSeq)== 0){
//        self.result = result;
//    }
//    
//}
//
////邮箱验证吗注册
//- (void)XmeyeRegisterWithEmailTestCode:(NSString *)emailCode userName:(NSString *)userName password:(NSString *)psw Email:(NSString *)email result:(void (^ )(NSString*result))result{
//    if(FUN_SysRegisteByEmail(self.handle, [userName UTF8String], [psw UTF8String], [email UTF8String], [emailCode UTF8String], RegisterWithEmailCodeSeq) == 0){
//        self.result = result;
//    }
//}
//
////普通注册
//- (void)XmeyeNormalRegisteWithuserName:(NSString *)userName password:(NSString *)password result:(void (^ )(NSString*result))result{
//    if(FUN_SysNoValidatedRegister(self.handle, [userName UTF8String], [password UTF8String],NormalRegisterFucSeq) == 0){
//        self.result = result;
//    }
//    
//}
//
////登录
//- (void)XmeyeLoginWithUserName:(NSString *)userName passWord:(NSString*)password result:(void (^ )(NSString* result))result{
//    if(FUN_SysLoginToXM(self.handle, [userName UTF8String], [password UTF8String], LoginFucSeq) == 0){
//        self.result = result;
//    }
//}
//
////用户修改密码
//- (void)XmeyeModifyWithUserName:(NSString *)userName oldPsw:(NSString *)oldPsw newPsW:(NSString *)newPsw result:(void (^ )(NSString* result))result{
//    if(FUN_SysPsw_Change(self.handle, [userName UTF8String], [oldPsw UTF8String], [newPsw UTF8String], ModifyuserPswSeq) == 0){
//        self.result = result;
//    }
//}
//
////搜索设备
//- (void)XmeyeSearchDeviceWithResult:(void (^ )(NSString* result))result{
//
//    if(FUN_DevSearchDevice(self.handle, 60000, SearchDeviceSeq) == 0){
//        self.result = result;
//    }
//}
//
////JS配置
//- (void)XmeyeConfigDeviceWithDeviceID:(NSString *)deviceId Result:(void (^)(NSString *))result{
//    NSLog(@"%@",deviceId);
//    if(FUN_DevGetConfig_Json(self.handle, [@"3bbfa19c87cef106" UTF8String], SZSTR(@"Simplify.Encode"), 1024, -1,120000,SetDeviceSeq) == 0){
//        self.result = result;
//    }
//}
//
////雄迈结果处理
//- (void)XmeyeResult:(XmeyeFuctionSeq)seq messageInt:(int)pramar messageStr:(NSString *)str
//{
//    NSLog(@"%d,%d,%@",seq,pramar,str);
//    if(seq == RegisterFucSeq){     // 手机验证吗注册
//        if(self.result){
//            if(pramar == 2000|| [str containsString:@"成功"]||pramar == 0){
//                self.result(XmeyeResultSuccess);
//            }else{
//                self.result([self ErrorString:pramar
//]);
//            }        }
//    }else if (seq == NormalRegisterFucSeq){ //普通用户注册 （无需验证码）
//        if(pramar == 2000|| [str containsString:@"成功"]||pramar == 0){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//    }else if (seq == LoginFucSeq){   //用户登录
//        if(pramar == 2000|| [str containsString:@"成功"]||pramar == 0){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//        
//    }else if (seq == SendPhoneMessageSeq){  //发送手机验证码
//        if(pramar == 2000|| [str containsString:@"成功"]){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//        
//    }else if (seq == SearchDeviceSeq){  //搜索设备
//        if(pramar == 2000|| [str containsString:@"成功"]||self.arrayDevSearchedList.count > 0){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//        
//    }else if (seq == SetDeviceSeq){    //设置设备
//        if(pramar == 2000||[str containsString:@"成功"]){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//    }else if (seq == GetEmailtestCodeSeq){  //发送邮箱验证码
//        if(pramar == 2000||[str containsString:@"成功"]){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//    }else if (seq == RegisterWithEmailCodeSeq){  //邮箱验证码注册
//        if(pramar == 2000||[str containsString:@"成功"]){
//            self.result(XmeyeResultSuccess);
//        }else{
//            self.result([self ErrorString:pramar]);
//        }
//    }
//    
//    self.result = nil;
//}
//
//
//
//
//-(BOOL)languageIsChinese
//{
//    NSString *language =[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
//    if ([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hans-CN"] || [language hasPrefix:@"zh-Hans"]){
//        return YES;
//    }
//    else{
//        return NO;
//    }
//}
//
////雄迈错误码
//- (NSString *)ErrorString:(int)pramar
//{
//    
//    switch (abs(pramar)) {
//        case 604012:
//            return @"用户名已被注册";
//            break;
//        case 604010:
//            return @"验证码错误";
//            break;
//        case 604000:
//            return @"用户名或密码错误";
//            break;
//        case 604021:
//            return @"手机号已存在";
//            break;
//        case 604018:
//            return @"密码格式不正确";
//            break;
//        case 604300:
//            return @"发送失败";
//            break;
//        case 604011:
//            return @"密码不一致";
//            break;
//        case 10005:
//            return @"操作超时";
//            break;
//        case 210210:
//            return @"用户名或密码错误";
//            break;
// 
//        default:
//            return @"操作失败";
//            break;
//    }
//    
//    
//}
@end
