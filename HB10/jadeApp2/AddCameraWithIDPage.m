//
//  AddCameraWithIDPage.m
//  
//
//  Created by JD on 2018/4/17.
//

#import "AddCameraWithIDPage.h"
#import "JDAppGlobelTool.h"
#import "CameraModel.h"
#import "elian.h"
#import "DeviceInfoModel.h"
#import <GWP2P/GWP2P.h>
#import "SubDeviceShowPage.h"
#import "StartConfirmPage.h"

@interface AddCameraWithIDPage ()
@property (strong, nonatomic) IBOutlet UITextField *idTextF;
@property (strong, nonatomic) IBOutlet UIButton *addCameraBtn;
@property (strong, nonatomic) IBOutlet UITextField *pswTextF;

@end

@implementation AddCameraWithIDPage
{
    BOOL _isBined;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.idTextF.placeholder = Local(@"Please enter the camera ID");
    self.pswTextF.placeholder = Local(@"Please enter your password");
    [self.addCameraBtn setTitle:Local(@"Add camera") forState:UIControlStateNormal];
    self.addCameraBtn.layer.cornerRadius = PublicCornerRadius;
    _isBined = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[[UIImage imageNamed:@"JDBack"] BlendingColorWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backBtn setImage:[[UIImage imageNamed:@"JDBack"] BlendingColorWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
    self.dismissKeyBEnable = YES;
    self.addCameraBtn.backgroundColor = APPBLUECOlOR;
}

- (void)back{
    BOOL flag = NO;
    Class cls;
    if (!_isBined){
        cls = [StartConfirmPage class];
    }else{
        cls = [SubDeviceShowPage class];
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:cls]){
            flag = YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    if (!flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCamera:(id)sender {
    if (self.idTextF.text.length <1) {
        [SVProgressHUD showInfoWithStatus: Local(@"Please enter the camera ID")];
        return;
    }
    if (self.pswTextF.text.length <1) {
        [SVProgressHUD showInfoWithStatus: Local(@"Please enter your password")];
        return;
    }
    NSString *Id = self.idTextF.text;
    NSString *psw = self.pswTextF.text;

    
     [SVProgressHUD showWithStatus:Local(@"Loading")];
    __weak typeof(self) weakSelf = self;
    [[GWP2PClient sharedClient] getDeviceWifiListWithDeviceID:Id devicePassword:psw completionBlock:^(GWP2PClient *client, BOOL success, NSDictionary<NSString *,id> *dataDictionary) {
        
        if (!self) {
            return ;
        }
        if(success){
            NSArray *cameraArr = [[NSUserDefaults standardUserDefaults] valueForKey:CameraDeviceDid(weakSelf.dModel.gizDevice.did)];
            if([cameraArr containsObject:Id]){
                [SVProgressHUD showInfoWithStatus:Local(@"The device already exists")];  //如果已经添加了 会有提示的
            }else{
                [[GizSupport sharedGziSupprot] gizFindDeviceSucceed:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.dModel addCameraWithID:Id compelet:^{
                            _isBined = true;
                            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
                        }];
                    });
                } failed:^(NSString *err) {
                    
                }];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:Local(@"The camera ID or password is wrong. Please try again")];
        }
    }];
}




@end
