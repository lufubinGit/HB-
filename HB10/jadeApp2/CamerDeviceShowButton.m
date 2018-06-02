////
////  CamerDeviceShowButton.m
////  jadeApp2
////
////  Created by JD on 2017/1/13.
////  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
////
//
//#import "CamerDeviceShowButton.h"
//#import "UIView+Frame.h"
//#import "JDAppGlobelTool.h"
//
//@implementation CamerDeviceShowButton
//
//+ (instancetype)initwithCamer:(JDCameraDevice *)camer
//                        frame:(CGRect)frame
//                      onTable:(UITableView *)TableView
//                         call:(void (^)(void))Call{
//    CamerDeviceShowButton *camerButton = [CamerDeviceShowButton buttonWithType:UIButtonTypeCustom];
//    camerButton.frame = frame;
//    camerButton.call = Call;
//    camerButton.camer = camer;
//    camerButton.tableView = TableView;
//    [camerButton addTarget:camerButton action:@selector(clickIntoPlay:) forControlEvents:UIControlEventTouchUpInside];
//    [camerButton initUI];
//    return camerButton;
//}
//
//- (void)clickIntoPlay:(CamerDeviceShowButton *)but{
//    if(self.call){
//        self.call();
//    }
//}
//
//- (void)deleteCamer{
//    if(self.delet){
//        self.delet();
//    }
//    
//}
//
//
//
//#pragma mark - UICreaat
//- (void)initUI{
//    
//    self.backgroundColor = [UIColor whiteColor];
//    
//    //图片
//    self.iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//    [self.iconImageV setLayerWidth:0 color:nil cornerRadius:10 BGColor:nil];
//    self.iconImageV.tag = 1001;
//    self.iconImageV.centerY = self.centerY;
//    UIImage *image = self.camer.camerNetIsonline?RepalceImage(@"Devcie_Camer_onlin"):RepalceImage(@"Devcie_Camer_offlin");
//    if(self.camer.currentImage){
//        self.iconImageV.image = [UIImage imageWithData:self.camer.currentImage];
//    }else{
//        self.iconImageV.image = image;
//    }
//    [self addSubview:self.iconImageV];
//    
//    //名字和描述  单行文字  定高度为20
//    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageV.x + self.iconImageV.width+10, 0, WIDTH/2.0, 20)];
//    self.nameLabel.text = self.camer.remark;
//    self.nameLabel.font = [UIFont systemFontOfSize:17];
//    self.nameLabel.textAlignment = NSTextAlignmentLeft;
//    self.nameLabel.textColor = APPGRAYBLACKCOLOR;
//    self.nameLabel.centerY = self.centerY - 15;
//    self.nameLabel.tag = 1002;
//    [self addSubview:self.nameLabel];
//    
//    self.briefLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, 0, WIDTH/2.0, 20)];
//    self.briefLabel.textColor = [UIColor grayColor];
//    self.briefLabel.font = [UIFont systemFontOfSize:12];
//    self.briefLabel.textAlignment = NSTextAlignmentLeft;
//    self.briefLabel.centerY = self.centerY + 15;
//    self.briefLabel.text = [NSString stringWithFormat:@"ID:%@",self.camer.cloudID];
//    self.briefLabel.tag = 1003;
//    [self addSubview:self.briefLabel];
//    
//    if(self.tableView.x != 0){
//        //添加删除 按钮
//        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.deleteButton.frame = CGRectMake(self.width - 50, 0, 50, self.height);
//        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self.deleteButton setTitle:Local(@"delete") forState:UIControlStateNormal];
//        self.deleteButton.backgroundColor = [UIColor whiteColor];
//        [self.deleteButton setTitleColor:APPMAINCOLOR forState:UIControlStateNormal];
//        self.deleteButton.tag = 1007;
//        //设置按钮左边的竖线
//        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.deleteButton.height)];
//        leftLineView.backgroundColor = APPLINECOLOR;
//        [self.deleteButton addSubview:leftLineView];
//        [self addSubview:self.deleteButton];
//
//    }
//}
//
////- (void)deleteleView:(UIButton *)button{
////
////    //删除对应的摄像头
////    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CamerAdrr];
////}
//
//
//@end
