//
//  APPVersionViewController.m
//  jadeApp2
//
//  Created by JD on 2016/12/20.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "APPVersionViewController.h"
#import "JDAppGlobelTool.h"


@interface APPVersionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *problemTitle;
@property (weak, nonatomic) IBOutlet UILabel *tipTitle;
@property (weak, nonatomic) IBOutlet UIButton *telNum;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation APPVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.telNum setTitle:OfficialTel forState:UIControlStateNormal];
    self.problemTitle.text = Local(@"Have any questions please contact:");
    self.tipTitle.text = Local(@"Or through the feedback page to our message.");
    self.title = Local(@"Version Information");
    self.company.text = Local(@"Copyright © 2016 Shenzhen JiaDe Sensing Technology Co., Ltd. All rights reserved");
    self.icon.image = [UIImage imageNamed:@"JADE_Icon"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    self.version.text =  [NSString stringWithFormat:@"V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
#if ANKA
    self.company.text = Local(@"Copyright © 2016 Shenzhen ANKA Sensing Technology Co., Ltd. All rights reserved");
    self.icon.image = [UIImage imageNamed:@"ANKA_Icon"];
#endif
    self.icon.layer.cornerRadius = PublicCornerRadius*2.0;
    self.icon.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dialling:(id)sender {
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"40007550688"];
#if ANKA
    str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"075589603006"];
#endif
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

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
