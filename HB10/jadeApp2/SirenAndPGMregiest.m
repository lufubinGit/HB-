//
//  SirenAndPGMregiest.m
//  JADE
//
//  Created by JD on 2017/4/29.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SirenAndPGMregiest.h"

@interface SirenAndPGMregiest ()

@end

@implementation SirenAndPGMregiest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
}

- (void)initUI{

    if(self.type == AlarmType){  //警号类型
       
    }else if(self.type == PGMType) { //PGM 类型
    
    
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
