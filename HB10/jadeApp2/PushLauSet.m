//
//  PushLauSet.m
//  JADE
//
//  Created by JD on 2017/11/18.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "PushLauSet.h"
#import "JDAppGlobelTool.h"

@interface PushLauSet ()
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UIButton *CH;
@property (weak, nonatomic) IBOutlet UIButton *EN;
    @property (strong, nonatomic) IBOutlet UIButton *RU;
    


@end

@implementation PushLauSet
{
    UIButton *_lastButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips.text = Local(@"Choose push language");
    [self initUI];
}

- (void)initUI{
    [self.CH setTitleColor:APPBLUECOlOR forState:UIControlStateSelected];
    [self.EN setTitleColor:APPBLUECOlOR forState:UIControlStateSelected];
    [self.RU setTitleColor:APPBLUECOlOR forState:UIControlStateSelected];
    self.CH.tintColor = [UIColor whiteColor];
    self.EN.tintColor = [UIColor whiteColor];
    self.RU.tintColor = [UIColor whiteColor];
    if (self.currentDevice.lau == CH){
        self.CH.selected = YES;
        _lastButton = self.CH;
    }else if(self.currentDevice.lau == RU){
        self.RU.selected = YES;
        _lastButton = self.RU;
    }else if(self.currentDevice.lau == EN){
        self.EN.selected = YES;
        _lastButton = self.EN;
    }else{
    
    }
}

- (IBAction)CHClick:(id)sender {
    [self action:self.CH type:CH];
}

- (IBAction)RUClick:(id)sender {
    [self action:self.RU type:RU];
}
    
- (IBAction)ENCLick:(id)sender {
    [self action:self.EN type:EN];
}

- (void)action:(UIButton*) btn type:(DeviceLauType)type{
    NSString* flag = (type==CH)?@"0":@"1";
     [SVProgressHUD showWithStatus:Local(@"Loading")];
    NSDictionary *request = @{@"system_language":flag};
    for ( DeviceInfoModel *device in [[GizSupport sharedGziSupprot] deviceList]) {
        if([device.gizDevice.did isEqualToString:self.currentDevice.gizDevice.did]){
            [[GizSupport sharedGziSupprot] gizSendOrderWithSN:41 device:device withOrder:request callBack:^(NSDictionary *datamap) {
                NSLog(@" 请求成功 %@",datamap);
                [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
                
                if (_lastButton == btn){
                    return;
                }
                _lastButton.selected = NO;
                btn.selected = YES;
                _lastButton = btn;
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
