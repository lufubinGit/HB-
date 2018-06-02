//
//  JDNetWorkTool.m
//  jadeApp2
//
//  Created by JD on 2016/10/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "JDNetWorkTool.h"
#import "WeatherModel.h"
#import "JDAppGlobelTool.h"


@implementation JDNetWorkTool

+ (id)shareInstance{
    static JDNetWorkTool* tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[JDAppGlobelTool shareinstance] getCurrentWifiNameAndPassWord];
        tool = [JDNetWorkTool manager];
        // 因为传递过去和接收回来的数据都不是json类型的，所以在这里要设置为AFHTTPRequestSerializer和AFHTTPResponseSerializer
        tool.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
        tool.responseSerializer = [AFHTTPResponseSerializer serializer] ;// 响应
        tool.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
         //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    });
    return tool;
}

- (void)addobserverforNet{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        // 网络连接状态更改的回调
        // AFNetworkReachabilityStatusUnknown          = -1, 未知
        // AFNetworkReachabilityStatusNotReachable     = 0,  无网络连接
        // AFNetworkReachabilityStatusReachableViaWWAN = 1,  运营网络（具体的网络并不知道）
        // AFNetworkReachabilityStatusReachableViaWiFi = 2,  wifi 连接
        
        [[JDAppGlobelTool shareinstance] getCurrentWifiNameAndPassWord];
        if([[JDAppGlobelTool shareinstance].currentWifiName containsString:@"XPG"] ){
            
            [[JDAppGlobelTool shareinstance] pushWithLinkCenterDevice];
        }
        
        NSLog(@"%ld", (long)status);
    }];
}

- (void)JDGetWeatherAtCurrentCitySuc:(void(^)(id))suc failed:(void(^)(id))fail{

    /*NSString *APIURL = [NSString stringWithFormat:%sDomesticWeatherAPI,[[NSString stringWithFormat:@"北京"] UTF8String]];*/
    
    NSString * str =  [JDAppGlobelTool shareinstance].currentCity;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSLog(@"%@",[str stringByAddingPercentEscapesUsingEncoding:enc]);
    
//    NSLog(@"%@",[NSString stringWithFormat:DomesticWeatherAPI,[str stringByAddingPercentEscapesUsingEncoding:enc]]
//         );
    [self POST:[NSString stringWithFormat:DomesticWeatherAPI,[str stringByAddingPercentEscapesUsingEncoding:enc]]  parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WeatherModel *model = [[WeatherModel alloc]initWithXMLData:responseObject];

        NSLog(@"%@",model);
        if(suc){
            suc(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(fail){
            fail(error);
        }
        
    }];
}

@end
