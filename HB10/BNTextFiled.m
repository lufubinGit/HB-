 //
//  BNTextFiled.m
//  jadeApp2
//
//  Created by JD on 2016/12/26.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "BNTextFiled.h"
#import "UIImage+BlendingColor.h"
#import "Masonry.h"
#import "JDAppGlobelTool.h"



#define cellHei WIDTH/8.0

@implementation BNTextFiledCell


@end

@implementation BNTextFiled
{
    UIView *_listView;
    UIView *_superV;
}
- (instancetype)initRecordTextWithIdentify:(NSString *)identify frame:(CGRect)rect insuper:(UIView *)superView{
    self = [super init];
    if (self) {
        //监听开始编辑状态
        [self addTarget:self action:@selector(showInputRecordList) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
        //监听编辑完成的状态
        [self addTarget:self action:@selector(hidenInputRecordList) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
          [self addTarget:self action:@selector(eidtChange) forControlEvents:UIControlEventEditingChanged];// 可在自定义selector处
        
        self.frame = rect;
        self.identify = identify;
        CGFloat hei = self.inputRecordListArr.count>3?cellHei*self.inputRecordListArr.count:cellHei*3;
        _listView  = [[UIView alloc]initWithFrame:CGRectMake(self.x,self.y+self.height + 10 , self.width ,hei)];
        _listView.userInteractionEnabled = YES;

        _listView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        for(int i = 0; i < self.inputRecordListArr.count;i++){
            BNTextFiledCell *cell = [BNTextFiledCell buttonWithType:UIButtonTypeCustom];
            cell.frame = CGRectMake(0, i*cellHei, WIDTH, cellHei);
            cell.index = i;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-1, cell.width, 1)];
            line.backgroundColor = APPLINECOLOR;
            cell.content = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.width, cell.height-1)];
            cell.content.backgroundColor = [UIColor clearColor];
            cell.content.text = self.inputRecordListArr[i][@"accout"];
            cell.content.textAlignment = NSTextAlignmentLeft;
            cell.content.textColor = APPGRAYBLACKCOLOR;
            cell.content.font = [UIFont systemFontOfSize:15];
            [cell addSubview:cell.content];
            [cell addSubview:line];

            [cell setTitleColor:APPGRAYBLACKCOLOR forState:UIControlStateNormal];
            [cell setBackgroundImage:[UIImage createImageWithColor:APPLINECOLOR] forState:UIControlStateHighlighted];
            [cell addTarget:self action:@selector(chooseRecord:) forControlEvents:UIControlEventTouchUpInside];
            cell.titleLabel.textAlignment = NSTextAlignmentLeft;
            cell.titleEdgeInsets = UIEdgeInsetsMake(cell.titleEdgeInsets.top, cell.titleEdgeInsets.left - cell.width/3.0, cell.titleEdgeInsets.bottom, cell.titleEdgeInsets.right+cell.width/3.0);
            [_listView addSubview:cell];
        }
        [_listView setLayerWidth:0.5 color:APPLINECOLOR cornerRadius:PublicCornerRadius BGColor:[UIColor whiteColor]];
    }
    [superView addSubview:self];
    _superV = superView;
    return self;
}

- (void)showInputRecordList{
    [_superV addSubview:_listView];
    [_superV bringSubviewToFront:_listView];
    _listView.y = self.y + self.height+10;
    _listView.hidden = NO;
    _listView.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat hei = 0;
        if(self.inputRecordListArr.count){
            hei = self.inputRecordListArr.count>3?cellHei*self.inputRecordListArr.count:cellHei*3;
        }else{
            hei = 0;
        }
        _listView.height = hei;
    }];
}

- (void)hidenInputRecordList{
    [UIView animateWithDuration:0.3 animations:^{
        _listView.height = 0;
 
    } completion:^(BOOL finished) {
         _listView.hidden = YES;
        [_listView removeFromSuperview];
    }];
}

- (void)eidtChange{
    if(self.text.length < 3){
        [self hidenInputRecordList];
    }
}

- (void)saveInputContent:(NSString *)accout psw:(NSString *)psw{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:accout forKey:@"accout"];
    [dic setValue:psw forKey:@"psw"];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:self.identify];
    if(!arr) {
        arr = [[NSArray alloc]initWithObjects:dic, nil];
    }else{
       NSMutableArray *mut = [[NSMutableArray alloc]initWithArray:arr];
        //有一样的先删除
        for ( int i = 0; i < mut.count;i++ ) {
            NSDictionary *d = mut[i];
            if([dic isEqualToDictionary:d]){
                [mut removeObject:d];
            }
        }
        [mut addObject:dic];
        arr = [NSArray arrayWithArray:mut];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:self.identify];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)chooseRecord:(BNTextFiledCell *)cell{
    
    [self hidenInputRecordList];
    if(self.recordCall){
        NSDictionary *dic = self.inputRecordListArr[cell.index];
        self.recordCall(dic);
    }
}


//获取在本地存的资源
- (NSArray *)inputRecordListArr{

    if(!_inputRecordListArr){
        _inputRecordListArr = [[NSUserDefaults standardUserDefaults] objectForKey:self.identify];
        if (!_inputRecordListArr){
            _inputRecordListArr = [[NSArray alloc]init];  //防止为空
        }
    }
    return _inputRecordListArr;
}

- (void)dealloc{

}

@end
