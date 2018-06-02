//
//  ProductIntroducePage.m
//  jadeApp2
//
//  Created by JD on 2016/10/17.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "JDWebViewController.h"
#import "UIImage+BlendingColor.h"
#import "JDAppGlobelTool.h"

#define DeafultURL @"https://www.baidu.com"
#define LeftButtonTitle Local(@"back")


@interface JDWebViewController ()<UIWebViewDelegate>



@property(nonatomic,strong) UIWebView *webView;

@end

@implementation JDWebViewController
{
    UIActivityIndicatorView *_juhua;
}


- (JDWebViewController *)initWithURLString:(NSString *)urlString{
    self = [super init];
    if (self) {
        [self.view addSubview:self.webView];
        if(urlString){
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DeafultURL]]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackButton{

    UIButton *leftNavButton = NavLeftButton;
    
    //左边的按钮
    leftNavButton.frame = CGRectMake(5, 20, 80, 44);
    leftNavButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 56);
    leftNavButton.titleEdgeInsets = UIEdgeInsetsMake(10, -15, 10, 0);
    leftNavButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftNavButton setImage:[UIImage imageNamed:@"Commend_back"] forState:UIControlStateNormal];
    [leftNavButton setImage:[[UIImage imageNamed:@"Commend_back"] imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateHighlighted];
    [leftNavButton setTitle:LeftButtonTitle forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
}

- (void)navBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.height = self.view.height-64;
        _webView.delegate = self;
        //添加一个菊花 加载的时候转动起来
        _juhua = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _juhua.center = CGPointMake(self.webView.centerX,self.webView.centerY-64);
        [self.webView addSubview:_juhua];
        [_juhua stopAnimating];
    }
    return _webView;
}

#pragma mark - webView delgate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_juhua startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_juhua stopAnimating];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_juhua stopAnimating];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}



@end
