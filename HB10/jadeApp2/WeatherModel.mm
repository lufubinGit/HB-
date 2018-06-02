//
//  WeatherModel.m
//  jadeApp2
//
//  Created by JD on 2016/10/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "WeatherModel.h"
#import <objc/runtime.h>

#define SunnyDay  @"sunny"  //晴天
#define Drizzle   @"drizzle"   //小雨
#define Cloud     @"cloud"     //多云
#define CloudyDay @"cloudy day"  //阴天
#define ModerateRain @"moderate rain"  //中雨
#define Shower   @"shower"  //阵雨


@implementation WeatherModel
{
    NSString *_currentEle;
    NSMutableDictionary *_dic;
}


- (instancetype)initWithXMLData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.XMLdata = data;
        _dic = [[NSMutableDictionary alloc]init];

        [self analysisXML];
    }
    return self;
}

- (void)setWeatheImage{

    self.wetherImage = [UIImage imageNamed:@"weather"];
}

/**
 * @brief  使用NSXMLParser 解析XML
 *
 * @param  nil
 *
 * @return nil
 */

- (void)analysisXML{
    // 传入XML数据，创建解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.XMLdata];
    // 设置代理，监听解析过程
    parser.delegate = self;
    // 开始解析(parse方法是阻塞式的)
    [parser parse];
    
}

#pragma XMLparser 代理
// 当扫描到文档的开始时调用（开始解析）
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"获取文件,开始解析");
    
}

// 当扫描到文档的结束时调用（解析完毕）
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析完毕");

    NSLog(@"%@",self);
    [self setWeatheImage];
}

//当扫描到元素的时候
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    _currentEle = elementName;

}

// 当扫描到元素的结束时调用
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
}


//先获取元素符号 然后再这里给元素符号赋值
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(![string isEqualToString:@"\n"]){
        [self setValue:string forKey:_currentEle];
        [_dic setObject:string forKey:_currentEle];
    }
    

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
}

- (NSString *)description{

    
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@  ",self.city,self.temperature1,self.temperature2,self.status1,self.status2,self.wetherImage];
}
@end
