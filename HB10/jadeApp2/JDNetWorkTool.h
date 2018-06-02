//
//  JDNetWorkTool.h
//  jadeApp2
//
//  Created by JD on 2016/10/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef void(^requestSuc)(id);
typedef void(^requestFai)(id);

@interface JDNetWorkTool : AFHTTPSessionManager


/**
 * @brief  单例初始化
 *
 * @param  nil
 *
 * @return nil
 *
 * @exception NSException nil
 *
 * @see someMethod
 * @see someMethodByInt:
 * @warning  警告: appledoc中显示为蓝色背景, Doxygen中显示为红色竖条.
 * @bug 缺陷: appledoc中显示为黄色背景, Doxygen中显示为绿色竖条.
 */
+ (id)shareInstance;


/**
 * @brief  获取天气信息
 *
 * @param  nil
 *
 * @return nil
 *
 */
- (void)JDGetWeatherAtCurrentCitySuc:(void(^)(id))suc failed:(void(^)(id))fail;



/**
 * @brief  添加网络监听
 *
 * @param
 *
 * @return
 
 */
- (void)addobserverforNet;

@end
