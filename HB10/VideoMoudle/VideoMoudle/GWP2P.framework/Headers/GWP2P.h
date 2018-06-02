//
/** @file GWP2P.h @brief 该文件包含GWP2P SDK所有头文件 */
//  P2PSDK
//
//  Created by apple on 17/2/24.
//  Copyright © 2017年 gwell. All rights reserved.
//


//设置
#import "GWP2PClient.h"                     //初始化连接
#import "GWP2PClient+DeviceInfomation.h"
#import "GWP2PClient+PictureAndSound.h"
#import "GWP2PClient+Defense.h"
#import "GWP2PClient+Alarm.h"
#import "GWP2PClient+Record.h"
#import "GWP2PClient+SceneMode.h"
#import "GWP2PClient+APMode.h"
#import "GWP2PClient+Sensor.h"
#import "GWP2PDefine.h"


//监控、视频通话、回放
#import "GWP2PPlayer.h"                 //播放器基类
#import "GWP2PPlayer+Fisheye.h"         //鱼眼画面控制分类
#import "GWP2PVideoPlayer.h"            //监控、视频通话时使用
#import "GWP2PPlaybackPlayer.h"         //回放使用
#import "GWP2PCallDefine.h"
#import "GWP2PUserCommandDefine.h"

//配网
#import "GWP2PDeviceLinker.h"   //设备联网

//模型
#import "GWP2PDevice.h" //设备
#import "GWP2PLanDevice.h" //局域网搜索到的设备