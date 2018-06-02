//
//  MainTabBar.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/6.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "MainTabBar.h"
#import "USerCenterPage.h"
#import "SysSetingPage.h"
#import "EquipmentPage.h"
#import "JDAppGlobelTool.h"

@interface MainTabBar ()

@end

@implementation MainTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setItemTitle];
}

- (void)setItemTitle{

    NSArray *navArr = [self childViewControllers];
    
    self.tabBar.tintColor = APPAMAINNAVCOLOR;
    for (int i = 0; i < navArr.count;i++) {
        
        UINavigationController *nav = navArr[i];
        nav.navigationBar.barTintColor = APPAMAINNAVCOLOR;
        nav.navigationBar.tintColor = [UIColor whiteColor];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        if([nav.viewControllers.firstObject isKindOfClass:[UserCenterPage class]]){
            nav.tabBarItem.title = @"User";
            nav.tabBarItem.image = [UIImage imageNamed:@"user"];
            nav.tabBarItem.selectedImage = [UIImage imageNamed:@"user_1"];
        }

        else if([nav.viewControllers.firstObject isKindOfClass:[SysSetingPage class]]){
            nav.tabBarItem.title = @"Seting";
            nav.tabBarItem.image = [UIImage imageNamed:@"seting"];
            nav.tabBarItem.selectedImage = [UIImage imageNamed:@"seting_1"];
        }
        else if([nav.viewControllers.firstObject isKindOfClass:[EquipmentPage class]]){
            nav.tabBarItem.title = @"Device";
            nav.tabBarItem.image = [UIImage imageNamed:@"device"];
            nav.tabBarItem.selectedImage = [UIImage imageNamed:@"device_1"];
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
