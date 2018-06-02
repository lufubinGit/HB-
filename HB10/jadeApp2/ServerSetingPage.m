//
//  ServerSetingPage.m
//  jadeApp2
//
//  Created by JD on 2017/1/5.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ServerSetingPage.h"
#import "GizSupport.h"
#define China @"China"
#define America @"America East"
#define Europe @"Europe"
#import "JDAppGlobelTool.h"
@interface ServerSetingPage ()

@property (weak, nonatomic) IBOutlet UILabel *tipTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;
@property (weak, nonatomic) IBOutlet UILabel *nameOne;
@property (weak, nonatomic) IBOutlet UILabel *nameTwo;
@property (weak, nonatomic) IBOutlet UILabel *nameThree;
@property (weak, nonatomic) IBOutlet UILabel *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@property (nonatomic,strong) NSArray *nameArr,*labelArr;
@property (nonatomic,strong) NSArray *imageVArr;
@property (nonatomic,strong) NSArray *buttonArr;

@end

@implementation ServerSetingPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameArr = @[China,America,Europe];
    self.imageVArr = @[_imageOne,_imageTwo,_imageThree];
    self.buttonArr = @[_buttonOne,_buttonTwo,_buttonThree];
    self.labelArr = @[_nameOne,_nameTwo,_nameThree];
    
    
    NSString *str = Local(@"The current server");
    self.tipTitle.text = [NSString stringWithFormat:@"%@:%@",str,self.nameArr.firstObject];
    for (int i = 0;i < self.buttonArr.count;i++) {
        UILabel *label = self.labelArr[i];
        NSString *nameStr = self.nameArr[i];
        UIImageView *imageV = self.imageVArr[i];
        label.text = nameStr;
        label.textColor = APPGRAYBLACKCOLOR;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
//        if([GizSupport sharedGziSupprot].serverType){
//        
//            
//        }else{
//            if(i == 0){
//                label.textColor = APPMAINCOLOR;
//                imageV.image = [UIImage imageNamed:@"server_set_seletor"];
//            }
//        }
        
        
       
        
        UIButton *button = self.buttonArr[i];
        button.tag = i;
        [button addTarget:self action:@selector(chooseOneServer:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)chooseOneServer:(UIButton *)button{
    
    for(int i = 0;i < self.buttonArr.count;i++){
        UIImageView *imageV =  self.imageVArr[i];
        NSString *str = self.nameArr[i];
        if(button.tag == i){
            imageV.image = [UIImage imageNamed:@"server_set_seletor"];
//            str.
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
