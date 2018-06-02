//
//  VideoPlayPage.h
//  JADE
//
//  Created by JD on 2017/6/5.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoPlayPage.h"
//#import "HSLSearchDevice.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "StreamPlayLib.h"
//#import "IPCClientNetLib.h"
//#import "MyGLViewController.h"
#import "LeftSlideViewController.h"
#import "JDAppGlobelTool.h"
@class DeviceInfoModel;
@class JDGizSubDevice;
@class EquipmentPagel;
@class SubDeviceShowPage;

@interface VideoPlayPage : BaseViewController
@property (nonatomic,strong) JDGizSubDevice *camera;  //摄像头的ID
@property (nonatomic,strong) DeviceInfoModel *dModel;
@property (nonatomic,strong) SubDeviceShowPage *deviceViewPage;  //上个页面
//- (void)ProcessYUV420Data:(Byte *)yuv420 Width:(int)width Height:(int)height;
//- (void)ProcessSearchRecordFile:(const STRU_SDCARD_RECORD_FILE *)pRecFile;
//- (void)ProcessEvent:(int)nType;
//- (void)ProcessP2pMode:(int)mode;
//- (void)ProcessAlarmMessage:(int)nType;
//- (void)ProcessGetParam:(int)nType Data:(const char*)szMsg DataLen:(int)len;
//- (void)ProcessSetParam:(int)nType Result:(int)result;
@end
