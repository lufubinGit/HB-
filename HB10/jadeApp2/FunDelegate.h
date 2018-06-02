//
//  FunDelegate.h
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#ifndef FunDelegate_h
#define FunDelegate_h

// 雄迈 定义的一个协议

@protocol FunDelegate <NSObject>

@required
-(void)OnFunSDKResult:(NSNumber *) pParam;

@end



#endif /* FunDelegate_h */
