//
//  BNTextFiled.h
//  jadeApp2
//
//  Created by JD on 2016/12/26.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNTextFiledCell : UIButton
@property (nonatomic,assign) NSInteger index;  //在上级页面中展示的位置
@property (nonatomic,strong) UILabel *content;

@end

typedef void(^RecordCall)(NSDictionary *);
@interface BNTextFiled : UITextField
/** 历史记录数组 */
@property (nonatomic,strong) NSArray *inputRecordListArr;

/** 存储的数据的大小 */
@property (nonatomic,assign) CGFloat sizeOfRecord;

/** 对象的身份字符 */
@property (nonatomic,strong) NSString *identify;

/** 选中之后的回调 */
@property (nonatomic,copy) RecordCall recordCall;



/**
 * @brief  初始化方法
 *
 * @param  identify   对象的身份字符  用于存储记录 
 * @param  rect       大小
 * @param  superView  所在的父控件
 *
 * @return 类实例
 
 */

- (instancetype)initRecordTextWithIdentify:(NSString *)identify frame:(CGRect)rect insuper:(UIView *)superView;

/**
 * @brief  展示输入的记录
 *
 * @param  nil
 *
 * @return nil
 
 */
- (void)showInputRecordList;



/**
 * @brief  隐藏输入的记录
 *
 * @param  nil
 *
 * @return nil
 
 */
- (void)hidenInputRecordList;

/**
 * @brief  存储账号类型记录
 *
 * @param
 *
 * @return
 
 */
- (void)saveInputContent:(NSString *)accout psw:(NSString *)psw;

@end
