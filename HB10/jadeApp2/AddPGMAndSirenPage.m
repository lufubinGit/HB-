//
//  AddPGMAndSirenPage.m
//  JADE
//
//  Created by JD on 2017/4/28.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "AddPGMAndSirenPage.h"
#import "SirenAndPGMregiest.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"


#define IDCannotEmpty Local(@"Id can not be empty")
#define PGMPlace Local(@"Enter the id of the PGM")
#define SirenPlace Local(@"Enter the id of the siren")

#define FormatError Local(@"Must be the number and combination of the letters 'a' - 'f'")
#define SixWords Local(@"Must be 6 characters")
#define SirenWords Local(@"The number entered must be between 1-65535")


@interface AddPGMAndSirenPage () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *OKbutton;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation AddPGMAndSirenPage
{
    CGFloat _floatHei;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:FoundRFSubDevice object:nil];
    [self initUI];
}

- (void)initUI {
    self.tipLabel.text = Local(@"Before connecting the siren and PGM to the gateway, you must enter any of its ID numbers consisting of at least 5 digits (for example 55555) and press the \"I confirm\" button below after entering. After successfully entering the siren / PGM identification number, press the MOD / SENS button on the siren / PGM for 3 seconds, the siren / PGM will enter the programming mode. Next, to bind the HUB to the siren / PGM, you need to remove or arm the HUB (via this application). After these actions, your siren / PGM will emit a \"Di\" signal - it means it is registered in your HUB and will be displayed in the list of installed sensors.");
    
    if(self.type == AlarmType){  //警号类型
        self.textF.placeholder = SirenPlace;
    }else if(self.type == PGMType){ //PGM类型
        self.textF.placeholder =  PGMPlace;
    }
    self.textF.delegate = self;
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.OKbutton.backgroundColor = APPBLUECOlOR;
    self.textF.height = 30;
    self.OKbutton.layer.cornerRadius = PublicCornerRadius;
    self.OKbutton.layer.masksToBounds = YES;
    [self.OKbutton setTitle:Local(@"accomplish") forState:UIControlStateNormal];
    [self.OKbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisKeyB)]];
}

- (IBAction)OkSend:(id)sender {
    if (_textF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:IDCannotEmpty];
        return;
    }
    
    
    if(self.type == PGMType){
        NSString *bigStr = @"0123456789abcdefABCDEF";
        NSString *buffStr = _textF.text;
        for(int i = 0;i < _textF.text.length;i++ ){
            
            NSString *aStr = [buffStr substringWithRange:NSMakeRange(i, 1)];
            if(![bigStr containsString:aStr]){
                [SVProgressHUD showInfoWithStatus:FormatError];
                return;
            }
        }
  
        if(_textF.text.length != 6 ){
            [SVProgressHUD showInfoWithStatus:SixWords];
            return;
        }
    }else if(self.type == AlarmType){  //警号类型的判断
        if(self.textF.text.integerValue < 1 ||self.textF.text.integerValue > 65535){
            [SVProgressHUD showInfoWithStatus:SirenWords];
            return;
        }
    }
    //完了之后发送消息  添加设备
    [self.currentDevie addTypeSubDeviceWith:self.type adress:_textF.text];
     [SVProgressHUD showWithStatus:Local(@"Loading")];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:true];
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK keyb
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    // 获取textf的高度
    CGRect newReact = [self.OKbutton convertRect:self.OKbutton.bounds toView:APPWindow];
    CGFloat btnBottom = newReact.origin.y + newReact.size.height;
    
    if(btnBottom > [UIScreen mainScreen].bounds.size.height - height) {
        [UIView animateWithDuration:0.25 animations:^{
            _floatHei = btnBottom - [UIScreen mainScreen].bounds.size.height + height;
            self.view.y -= _floatHei;
        }];
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    //获取键盘的高度
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y += _floatHei;
    }];
}

@end
