//
//  WeatherModel.h
//  jadeApp2
//
//  Created by JD on 2016/10/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherModel : NSObject <NSXMLParserDelegate>

/** 获取到的data */
@property (nonatomic,strong)NSData *XMLdata;

/** 城市名称 */
@property (nonatomic,strong) NSString *city;

/** 天气对应的图片 */
@property (nonatomic,strong) UIImage *wetherImage;

/** 天气更新时间 */
@property (nonatomic,strong) NSString *udatetime;

/** 最高气温 */
@property (nonatomic,strong) NSString *temperature1;

/** 最低气温 */
@property (nonatomic,strong) NSString *temperature2;

/** 第一种状态 */
@property (nonatomic,strong) NSString *status1;

/** 第二种状态 */
@property (nonatomic,strong) NSString *status2;


/**
 * @brief  初始化
 *
 * @param  data  将要被解析的XML数据
 *
 * @return nil
  */
- (instancetype)initWithXMLData:(NSData *)data;

@end
