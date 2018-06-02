//
//  PrivacyPage.m
//  jadeApp2
//
//  Created by JD on 2016/12/20.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "PrivacyPage.h"
#import "JDAppGlobelTool.h"

#define Title Local(@"Privacy Policy")
#define HeadViewHei 60

@interface PrivacyPage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *tipTitle;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation PrivacyPage
{
    UIView *_headView;
    UIView *_footView;
    CGFloat _footeViewHei;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipTitle = Title;
    self.title = Title;
    self.contentStr = Local(@"Iot-Alarm APP (hereinafter referred to as \"Iot-Alarm\") respects and protects the privacy of all users who use the service. In order to provide you with more accurate and personalized service, Iot-Alarm will use and disclose your personal information in accordance with this Privacy Policy. But \"Iot-Alarm\" will be treated with a high degree of diligence and prudence. Except as otherwise provided in this Privacy Policy, Iot-Alarm will not disclose or provide such information to third parties without your prior permission. \"Iot-Alarm\" will update this Privacy Policy from time to time. By agreeing to the Iot-Alarm Service Agreement, you are deemed to have agreed to the entire contents of this Privacy Policy. This Privacy Policy is an integral part of the Iot-Alarm Service Use Agreement. \n\n1. Applicable \na) Personal registration information provided by you under \"Iot-Alarm\" when you register \"Iot-Alarm\"; \nb) Before you use the \"Iot-Alarm\" network service, or visit the \"Iot-Alarm\" platform page Iot-Alarm automatically receives and logs information on your browser and computer or other terminal, including but not limited to your IP address, type of browser, language used, date and time of access, hardware and software feature information And your required web page records; \n\nc) \"Iot-Alarm\" User data obtained from a business partner by legal means. \n\nYou understand and agree that the following information does not apply to this privacy policy: \n\na) The keyword information you entered when using the search service provided by the \"Iot-Alarm\" platform; \n\nb) \"Iot-Alarm\" (Including Iot-Alarm), including but not limited to participation in the event, transaction information and evaluation details; \n\nc) in violation of the law or in violation of the \"Iot-Alarm\" rules and \"Iot-Alarm\" has taken to you Measures. \n\n2. Information use \n\na) \"Iot-Alarm\" will not provide, sell, rent, share or trade your personal information to any unrelated third party unless you have received your permission in advance, or the third party and \"Iot-Alarm\" (Including \"Iot-Alarm\" affiliates) to serve you individually or jointly, and after the end of the service, it will be prohibited from accessing all of the information that it has previously been able to access. \n\nb) \"Iot-Alarm\" does not allow any third party to collect, edit, sell or distribute your personal information by any means. Any Iot-Alarm platform user who is engaged in such activities, once discovered, \"Iot-Alarm\" has the right to terminate immediately with the user's service agreement. \n\nc) For the purpose of serving the user, \"Iot-Alarm\" may use your personal information to provide you with information of interest, including but not limited to sending you product and service information, or with Iot-Alarm partners Share information so that they can send you information about their products and services (the latter requires your prior consent). \n\n3. Information Disclosure \n\nUse \"Iot-Alarm\" will disclose your personal information in whole or in part on your personal or legal requirements: \n\na Upon your prior consent, Third party disclosure; \n\nb) in order to provide you with the products and services required, and must share your personal information with a third party; \n\nc) in accordance with the relevant provisions of the law, or administrative or judicial requirements, Third party or administrative or judicial disclosure; \n\nd) if you appear in violation of the relevant Chinese laws, regulations or \"Iot-Alarm\" service agreement or the relevant rules, you need to disclose to a third party; \n\ne) And the other \"Iot-Alarm\" shall be deemed appropriate by law, regulation or website policy, and shall be deemed to be appropriate by the Respondent's request to the Respondent for the purpose of dealing with the possible rights dispute; \n\nf) Disclosure. \n\n4. Information storage and exchange \n\n \"Iot-Alarm\" The information and information you collect about your information will be stored on the server of \"Iot-Alarm\" and / or its affiliates, which may be sent to you Country, region, or \"Iot-Alarm\" to collect information and information and to be accessed, stored and displayed abroad. \n\n5. Information Security \n\n \"Iot-Alarm\" account has security features, please keep your user name and password information. \"Iot-Alarm\" will be through the user password encryption and other security measures to ensure that your information is not lost, not to be abused and altered. In spite of the foregoing safety measures, please also note that there is no \"sound security measures\" on the information network. \n\n6. Special Tips for Information Updates and Publications \n\n \"Iot-Alarm\" encourages users to update and modify their personal information to make them effective. \"Iot-Alarm\" users can easily obtain and modify their personal information at any time. Users can decide to modify their own, delete their relevant information.\n\nPlease remember that Iot-Alarm will not be held responsible for any personal information that may be collected and used by others whenever you voluntarily disclose your personal information. If you disclose your personal information in the above Channel, you may be able to cause personal information disclosure. Therefore, we remind you and please carefully consider whether it is necessary to disclose your personal information in the above channels. \n\n7. Tips for sensitive personal information \n\n Some personal information may be considered sensitive personal information because of their particularity, such as your race, religion, personal health and medical information. \n\nPlease note that the content and information you provide, upload, or post in our services, such as photos or information about your social activity, may reveal your sensitive personal information. You need to be careful about whether or not to use our services to disclose your sensitive personal information. \n\nYou agree that your sensitive personal information will be processed in accordance with the purpose and manner described in this Privacy Policy. \n\n8. Ads \n\nWe may use your information to provide you with ads that are more relevant to you. We may also use your information, through our services, email or other means to send you marketing information to provide or promote us or third parties the following goods and services: \n\na) Our goods and services, including but Is not limited to: instant messaging services, online media services, interactive entertainment services, social networking services, payment services, Internet search services, location and map services, application software and services, data management software and services, online advertising services, Internet finance and others Social media, entertainment, e-commerce, information and communication software and services (\"Internet Service\"); \n\nb) Third party goods and services including but not limited to: Internet services, food and catering, sports, music, TV, live performances and other arts and entertainment, books, magazines and other publications, clothing and accessories, jewelry, cosmetics, personal health and hygiene, electronics, collectibles, household utensils, electrical appliances, home furnishings and furnishings, pets, cars, hotels , Transportation and travel, banking, insurance and financial services, membership points and incentive programs, and other goods and services that we believe may be relevant to you. \n\nIf you do not want us to use your personal information for the above advertising purposes, you may use the instructions provided by us in the advertisements or the selection mechanism provided in a particular service to stop us from using Of personal information. \n\n9. We send you messages and messages \n\na. When you use our services, we may use your information to send email or push notifications to your device. If you do not wish to receive this information, you can choose to unsubscribe on the device as indicated in the email we sent you. \n\nb) Service-related announcements We may issue a service-related announcement when necessary (for example, when we suspend a service due to system maintenance). You may not be able to cancel these announcements that are related to the service and do not belong to the promotion. \n\nc) Our services may include or link to social media or other services (including websites) provided by third parties. For example: \n\n • You can use the \"Share\" key to share some of our content with our services, or you can log in to our services using a third-party connection. \n\n • We provide you with links to advertisements or other ways we serve so that you can access third-party services or websites. \n\n The third party social media or other services are operated by the relevant third party. Your use of such third party social media services or other services (including any personal information you provide to such third parties) shall be subject to third party's own terms of service and personal information protection statement (not this Privacy Policy) Constraints, you need to read the terms carefully. This Privacy Policy applies only to any information we collect and do not apply to any third party's services or third party information usage rules, and we are not responsible for the use of any information provided by you by any third party. \n\n10. The scope of this Privacy Policy \n\n Except for certain specific services, all of our services apply to this Privacy Policy. These specific services will apply specific personal information protection statements. The personal information protection statement for that particular service forms part of this Privacy Policy. If the personal information protection statement for any particular service is inconsistent with this Privacy Policy, the Personal Information Protection Statement for a particular service applies. \n\n In addition to this Privacy Policy, the terms used in this Privacy Policy shall have the same meanings as those defined in other public terms set forth in Iot-Alarm. \n\n Please note that this Privacy Policy does not apply to the following: \n\n • Information collected by third-party services (including any third-party websites) accessed through our services; \n\n • Information collected by other companies and organizations that conduct advertising services in our services. \n\n11. Changes to this Privacy Policy \nWe may modify the terms of this Privacy Policy at any time, which forms part of this Privacy Policy. If such changes result in a substantial reduction in your rights under this Privacy Policy, you may choose to discontinue use of the services we provide to you; in such event, if you continue to use our services, you agree to The revised Privacy Policy. \n any changes will put your satisfaction in the first place. \n\n Finally, you are the only person who is responsible for your account and password information. In any case, please be careful and safe. \n\n Source: Iot-Alarm Release Date: 2016-12-28");
    
#if ANKA

    self.contentStr = Local(@"ANKA Gateway APP (hereinafter referred to as \"ANKA\") respects and protects the privacy of all users who use the service. In order to provide you with more accurate and personalized service, ANKA will use and disclose your personal information in accordance with this Privacy Policy. But \"ANKA\" will be treated with a high degree of diligence and prudence. Except as otherwise provided in this Privacy Policy, ANKA will not disclose or provide such information to third parties without your prior permission. \"ANKA\" will update this Privacy Policy from time to time. By agreeing to the ANKA Service Agreement, you are deemed to have agreed to the entire contents of this Privacy Policy. This Privacy Policy is an integral part of the ANKA Service Use Agreement. \n\n1. Applicable \na) Personal registration information provided by you under \"ANKA\" when you register \"ANKA\"; \nb) Before you use the \"ANKA\" network service, or visit the \"ANKA\" platform page ANKA automatically receives and logs information on your browser and computer or other terminal, including but not limited to your IP address, type of browser, language used, date and time of access, hardware and software feature information And your required web page records; \n\nc) \"ANKA\" User data obtained from a business partner by legal means. \n\nYou understand and agree that the following information does not apply to this privacy policy: \n\na) The keyword information you entered when using the search service provided by the \"ANKA\" platform; \n\nb) \"ANKA\" (Including ANKA), including but not limited to participation in the event, transaction information and evaluation details; \n\nc) in violation of the law or in violation of the \"ANKA\" rules and \"ANKA\" has taken to you Measures. \n\n2. Information use \n\na) \"ANKA\" will not provide, sell, rent, share or trade your personal information to any unrelated third party unless you have received your permission in advance, or the third party and \"ANKA\" (Including \"ANKA\" affiliates) to serve you individually or jointly, and after the end of the service, it will be prohibited from accessing all of the information that it has previously been able to access. \n\nb) \"ANKA\" does not allow any third party to collect, edit, sell or distribute your personal information by any means. Any ANKA platform user who is engaged in such activities, once discovered, \"ANKA\" has the right to terminate immediately with the user's service agreement. \n\nc) For the purpose of serving the user, \"ANKA\" may use your personal information to provide you with information of interest, including but not limited to sending you product and service information, or with ANKA partners Share information so that they can send you information about their products and services (the latter requires your prior consent). \n\n3. Information Disclosure \n\nUse \"ANKA\" will disclose your personal information in whole or in part on your personal or legal requirements: \n\na Upon your prior consent, Third party disclosure; \n\nb) in order to provide you with the products and services required, and must share your personal information with a third party; \n\nc) in accordance with the relevant provisions of the law, or administrative or judicial requirements, Third party or administrative or judicial disclosure; \n\nd) if you appear in violation of the relevant Chinese laws, regulations or \"ANKA\" service agreement or the relevant rules, you need to disclose to a third party; \n\ne) And the other \"ANKA\" shall be deemed appropriate by law, regulation or website policy, and shall be deemed to be appropriate by the Respondent's request to the Respondent for the purpose of dealing with the possible rights dispute; \n\nf) Disclosure. \n\n4. Information storage and exchange \n\n \"ANKA\" The information and information you collect about your information will be stored on the server of \"ANKA\" and / or its affiliates, which may be sent to you Country, region, or \"ANKA\" to collect information and information and to be accessed, stored and displayed abroad. \n\n5. Information Security \n\n \"ANKA\" account has security features, please keep your user name and password information. \"ANKA\" will be through the user password encryption and other security measures to ensure that your information is not lost, not to be abused and altered. In spite of the foregoing safety measures, please also note that there is no \"sound security measures\" on the information network. \n\n6. Special Tips for Information Updates and Publications \n\n \"ANKA\" encourages users to update and modify their personal information to make them effective. \"ANKA\" users can easily obtain and modify their personal information at any time. Users can decide to modify their own, delete their relevant information.\n\nPlease remember that ANKA will not be held responsible for any personal information that may be collected and used by others whenever you voluntarily disclose your personal information. If you disclose your personal information in the above Channel, you may be able to cause personal information disclosure. Therefore, we remind you and please carefully consider whether it is necessary to disclose your personal information in the above channels. \n\n7. Tips for sensitive personal information \n\n Some personal information may be considered sensitive personal information because of their particularity, such as your race, religion, personal health and medical information. \n\nPlease note that the content and information you provide, upload, or post in our services, such as photos or information about your social activity, may reveal your sensitive personal information. You need to be careful about whether or not to use our services to disclose your sensitive personal information. \n\nYou agree that your sensitive personal information will be processed in accordance with the purpose and manner described in this Privacy Policy. \n\n8. Ads \n\nWe may use your information to provide you with ads that are more relevant to you. We may also use your information, through our services, email or other means to send you marketing information to provide or promote us or third parties the following goods and services: \n\na) Our goods and services, including but Is not limited to: instant messaging services, online media services, interactive entertainment services, social networking services, payment services, Internet search services, location and map services, application software and services, data management software and services, online advertising services, Internet finance and others Social media, entertainment, e-commerce, information and communication software and services (\"Internet Service\"); \n\nb) Third party goods and services including but not limited to: Internet services, food and catering, sports, music, TV, live performances and other arts and entertainment, books, magazines and other publications, clothing and accessories, jewelry, cosmetics, personal health and hygiene, electronics, collectibles, household utensils, electrical appliances, home furnishings and furnishings, pets, cars, hotels , Transportation and travel, banking, insurance and financial services, membership points and incentive programs, and other goods and services that we believe may be relevant to you. \n\nIf you do not want us to use your personal information for the above advertising purposes, you may use the instructions provided by us in the advertisements or the selection mechanism provided in a particular service to stop us from using Of personal information. \n\n9. We send you messages and messages \n\na. When you use our services, we may use your information to send email or push notifications to your device. If you do not wish to receive this information, you can choose to unsubscribe on the device as indicated in the email we sent you. \n\nb) Service-related announcements We may issue a service-related announcement when necessary (for example, when we suspend a service due to system maintenance). You may not be able to cancel these announcements that are related to the service and do not belong to the promotion. \n\nc) Our services may include or link to social media or other services (including websites) provided by third parties. For example: \n\n • You can use the \"Share\" key to share some of our content with our services, or you can log in to our services using a third-party connection. \n\n • We provide you with links to advertisements or other ways we serve so that you can access third-party services or websites. \n\n The third party social media or other services are operated by the relevant third party. Your use of such third party social media services or other services (including any personal information you provide to such third parties) shall be subject to third party's own terms of service and personal information protection statement (not this Privacy Policy) Constraints, you need to read the terms carefully. This Privacy Policy applies only to any information we collect and do not apply to any third party's services or third party information usage rules, and we are not responsible for the use of any information provided by you by any third party. \n\n10. The scope of this Privacy Policy \n\n Except for certain specific services, all of our services apply to this Privacy Policy. These specific services will apply specific personal information protection statements. The personal information protection statement for that particular service forms part of this Privacy Policy. If the personal information protection statement for any particular service is inconsistent with this Privacy Policy, the Personal Information Protection Statement for a particular service applies. \n\n In addition to this Privacy Policy, the terms used in this Privacy Policy shall have the same meanings as those defined in other public terms set forth in ANKA. \n\n Please note that this Privacy Policy does not apply to the following: \n\n • Information collected by third-party services (including any third-party websites) accessed through our services; \n\n • Information collected by other companies and organizations that conduct advertising services in our services. \n\n11. Changes to this Privacy Policy \nWe may modify the terms of this Privacy Policy at any time, which forms part of this Privacy Policy. If such changes result in a substantial reduction in your rights under this Privacy Policy, you may choose to discontinue use of the services we provide to you; in such event, if you continue to use our services, you agree to The revised Privacy Policy. \n any changes will put your satisfaction in the first place. \n\n Finally, you are the only person who is responsible for your account and password information. In any case, please be careful and safe. \n\n Source: ANKA Release Date: 2017-2-13")  ;
#endif
    

    [self.view addSubview:self.tableView];
    [self creatHeadView];
    [self creatFootView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma creatView headView footView
- (void)creatHeadView{
   
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 20)];
    [_headView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = APPBLUECOlOR;
    titleLabel.text = Title;
 
    //添加线条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 59, WIDTH-20, 1)];
    lineView.backgroundColor = APPLINECOLOR;
    [_headView addSubview:lineView];
    self.tableView.tableHeaderView = _headView;
    
}
- (void)creatFootView{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20,0)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = self.contentStr;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.textColor = APPGRAYBLACKCOLOR;
    CGSize titleSize = [self.contentStr boundingRectWithSize:CGSizeMake(WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _footView.height = titleSize.height+100;
    titleLabel.size = titleSize;
    [_footView addSubview:titleLabel];
    _footView.backgroundColor = [UIColor whiteColor];
    _footeViewHei  = _footView.height;
    self.tableView.tableFooterView = _footView;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [[UITableViewCell alloc]init];
}

#pragma mark - 懒加载
- (UITableView *)tableView{

    if(!_tableView){
    
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
