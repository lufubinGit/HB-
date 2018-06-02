//
//  ModifyEvent.m
//  jadeApp2
//
//  Created by JD on 2016/12/5.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ModifyEvent.h"
#import "DeviceInfoModel.h"
#import "JDAppGlobelTool.h"

@implementation ModifyEvent
{
    JDGizSubDevice *_subDevice;
    id _event;
    ModEventType _eventType;
}


- (instancetype)initWithEvent:(id)event eventType:(ModEventType)type forsubDevice:(JDGizSubDevice *)subDevice
{
    self = [super init];
    if (self) {
        _subDevice = subDevice;
        _eventType = type;
        _event = event;
        [self getOrder];
    }
    return self;
}

// 编辑成指令 保存到request
- (void)getOrder{

    char s[] = {0x05};
    NSMutableData *Sdata = [NSMutableData dataWithBytes:s length:sizeof(s)];
    NSDictionary *request = nil;

    NSData *hexData = [NSData data];
    //修改状态
    if(_eventType == ModEventCancleFlashesType){
        NSMutableString *stateStr = [[NSMutableString alloc]initWithString:_subDevice.stateStr];
        [stateStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@"0"];
        hexData = [[JDAppGlobelTool shareinstance] getHexBybinary:stateStr];
        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(0, 49)]];
        [Sdata appendData:hexData];
        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(50, 2)]];
        request = @{@"binary": Sdata};
        self.request = request ;
    }else if(_eventType == ModEventModNameType){//修改名字
        NSString *name = _event;
        NSMutableData *nameData = [[NSMutableData alloc]initWithData:[name dataUsingEncoding:NSUTF8StringEncoding]];
        //名字过滤  太长会被清理
        int lenth = 31;
        if(nameData.length>=lenth){
            int i = 0;
            int countA = lenth-i;
            nameData = [[NSMutableData alloc]initWithData:[nameData subdataWithRange:NSMakeRange(0, countA)]];
            ;
            while (![[NSString alloc]initWithData:nameData encoding:NSUTF8StringEncoding]) {
                i++;
                countA = lenth-i;
                nameData = [[NSMutableData alloc]initWithData:[nameData subdataWithRange:NSMakeRange(0, countA)]];
            }
        }
        char s2[] = {0x00};
        int count = (int)(32 - nameData.length);
        for(int i = 0;i < count;i++){
            [nameData appendData:[NSMutableData dataWithBytes:s2 length:sizeof(s2)]];
        }
        
        NSMutableData *data =  [NSMutableData dataWithData:[_subDevice.productID subdataWithRange:NSMakeRange(0, 17)]];
        NSData *lastData = [_subDevice.productID subdataWithRange:NSMakeRange(49, 3)];
        [data appendData:nameData];
        [data appendData:lastData];
        [Sdata appendData:data];
        request = @{@"binary": Sdata};
        self.request = request;
    }else if (_eventType == ModEventModSetType){  //整体设置的修改
        hexData = [[JDAppGlobelTool shareinstance] getHexBybinary:_event];
        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(0, 50)]];
        [Sdata appendData:hexData];
        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(51, 1)]];
        request = @{@"binary": Sdata};
        self.request = request ;
    }
//    else{
//        switch (_eventType) {
//            case ModEventModArmDlyType:{ //设置是否有延时报警
//                [setString replaceCharactersInRange:NSMakeRange(1, 1) withString:bitStr];
//            }
//                break;
//            case ModEventModAlmDlyType:{ //设置是否有延时布防
//                [setString replaceCharactersInRange:NSMakeRange(2, 1) withString:bitStr];
//            }
//                break;
//            case ModEventModDisarmEffectiveType:{ //撤防时有效
//                [setString replaceCharactersInRange:NSMakeRange(5, 1) withString:bitStr];
//            }
//                break;
//            case ModEventModArmstayEffectiveType:{ //外出布防时有效
//                [setString replaceCharactersInRange:NSMakeRange(6, 1) withString:bitStr];
//            }
//                break;
//            case ModEventModArmawayEffectiveType:{ //留守布防是否有效
//                [setString replaceCharactersInRange:NSMakeRange(7, 1) withString:bitStr];
//            }
//                break;
//            default:
//                break;
//        }
//        hexData = [[JDAppGlobelTool shareinstance] getHexBybinary:setString];
//        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(0, 50)]];
//        [Sdata appendData:hexData];
//        [Sdata appendData:[_subDevice.productID subdataWithRange:NSMakeRange(51, 1)]];
//        request = @{@"binary": Sdata};
//        self.request = request;
//    }
}

@end
