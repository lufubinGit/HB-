//
//  SetGatewayNumCell.m
//  jadeApp2
//
//  Created by JD on 2016/11/14.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SetGatewayNumCell.h"
#import "JDAppGlobelTool.h"

@implementation SetGatewayNumCell
{
   NSInteger _oldNum;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(GateWayCellType)Type{
    if(Type == NumType){
        self.numTextFiled.delegate = self;
        self.numTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        self.numRange.text = [NSString stringWithFormat:@"(0 - %ld)",(long)self.num];
        self.numTextFiled.placeholder = Local(@"delay time");
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    NSLog(@"开始编辑咧");
    if(self.cellB2){
        self.cellB2(self.index);
    }
   _oldNum = [textField.text intValue];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    if([textField.text integerValue] > self.num){
        NSString *string = Local(@"Numerical range");
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@:0 - %ld",string,(long)self.num]];
        textField.text = nil;
        
    }else if (_oldNum == [textField.text intValue]){
        //如果数值相等 则什么都不做
    }else{
        if(self.cellB){
            self.cellB([textField.text intValue]);
            _oldNum = [textField.text intValue];
        }
        NSLog(@"上报数据   还需要刷新数据");
    }
}

@end
