//
/** @file GWP2PPlayer+Fisheye.h @brief 鱼眼画面控制的播放器分类 */
//  P2PSDK
//
//  Created by zengyuying on 17/3/31.
//  Copyright © 2017年 gwell. All rights reserved.
//

#import "GWP2PPlayer.h"
#import "GWP2PDevice.h"



/**
 @brief 鱼眼画面控制的播放器分类
 */
@interface GWP2PPlayer (Fisheye)

/** 鱼眼显示形状,可直接修改 */
@property (nonatomic, assign) GWP2PFisheyeShapeType shapeType;


/**
 放大,对应缩放手势
 */
- (void)fisheyeZoomIn;

/**
 缩小,对应缩放手势
 */
- (void)fisheyeZoomOut;

/**
 指定位置放大,对应长按手势

 @param location 在View中的位置
 */
- (void)fisheyeZoomInWithLocation:(CGPoint)location;

/**
 指定位置缩小,对应双击手势

 @param location 在View中的位置
 */
- (void)fisheyeZoomOutWithLocation:(CGPoint)location;

/**
 移动鱼眼画面,对应拖拽手势,手势状态changed时调用,传入当前手势位置坐标及上次手势位置坐标

 @param lastLocation    上次手势位置坐标
 @param currentLocation 当前手势位置坐标
 */
- (void)fisheyeMoveFrom:(CGPoint)lastLocation to:(CGPoint)currentLocation;

/**
 设置惯性移动,在拖拽手势结束时调用;调用fisheyeEnableDrift:NO后无效

 @param vector 矢量坐标,如:x=手势当前位置x-手势上次响应的x,y=手势当前位置y-手势上此响应的y;
 */
- (void)fisheyeFlingWithVector:(CGPoint)vector;

/**
 如果画面正在自动旋转,则停止;对应单击手势
 */
- (void)fisheyeStopDrift;

/**
 开启/关闭漂移,默认开启,开启时拖拽手势有惯性并在手势结束后自动旋转

 @param enaleDrift 开启/关闭
 */
- (void)fisheyeEnableDrift:(BOOL)enaleDrift;

/**
 设置漂移速度,默认30

 @param speed 速度,默认30
 */
- (void)fisheyeSetDriftSpeed:(CGFloat)speed;


@end
