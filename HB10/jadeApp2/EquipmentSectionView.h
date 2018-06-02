//
//  EquipmentSectionView.h
//  jadeApp2
//
//  Created by JD on 2016/11/18.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceInfoModel;
@class EquipmentPage;
@interface EquipmentSectionView : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImageV ;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *briefLabel;
@property (nonatomic,strong) DeviceInfoModel *devcieModel;
@property (nonatomic,strong) UIImageView *signalImage;  //WIFI 信号图标
@property (nonatomic,strong) UIImageView *armImage;     //报警信号图标
@property (nonatomic,strong) UIImageView *GSMSignalImage;     //GSM 信号图标
@property (nonatomic,strong) EquipmentPage *lastPage;

@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UIButton *setbutton,*deleteButton;
@property (nonatomic,strong) UITableView *tableView;   //view 所在的tableView
@property (nonatomic,assign) BOOL isShow;


/**
 * @brief  初始化
 *
 * @param  <#携带参数#>
 *
 * @return <#返回值#>
 
 */
- (instancetype)initWithFrame:(CGRect)frame device:(DeviceInfoModel *)device tableView:(UITableView *)tableView;

/**
 * @brief  刷新数据
 *
 * @param  <#携带参数#>
 *
 * @return <#返回值#>
 
 */
- (void)refrshDataWithModel:(DeviceInfoModel *)model;


/**
 * @brief  删除view对应的设备
 *
 * @param  <#携带参数#>
 *
 * @return <#返回值#>
 
 */
- (void)deleteCenterDevice;





@end
