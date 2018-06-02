//
//  CloudSaveTool.h
//  jadeApp2
//
//  Created by JD on 2016/10/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@class UserInfoModel ;
@interface CloudSaveTool : NSObject

@property (nonatomic,strong)CKDatabase *publicDB;


/**
 * @brief  单例初始化
 *
 * @param  nil
 *
 * @return CloudSaveTool
 */
+ (CloudSaveTool *)shareInstance;



/**
 * @brief  将用户数据存储在云端
 *
 * @param  userInfoModel 包含用户属性的model
 *
 * @param  succeed 成功的回调
 *
 * @param  failed 失败的回调 附带错误信息
 *
 * @return nil
 */
- (void)cloudSaveObject:(UserInfoModel *)userInfoModel succeed:(void(^)())succeed failed:(void(^)(NSError *))failed;

/**
 * @brief  将用户储存在云端的信息取出
 *
 * @userAccout
 *
 * @param  userInfoModel 包含用户属性的model
 *
 * @param  succeed 成功的回调  附带一个用户model的参数
 *
 * @param  failed 失败的回调 附带错误信息
 *
 * @return nil
 */
- (void )cloudGetUserInfoWithUseraccout:(NSString *)userAccout Succeed:(void(^)(UserInfoModel* ))succeed failed:(void(^)(NSError *))failed;



/**
 * @brief  更改 用户信息
 *
 * @param  userModel 修改后的用户信息
 *
 * @param  succeed 成功的回调
 *
 * @param  failed 失败的回调 附带错误信息
 *
 * @return nil
 
 */
- (void)cloudModifyUserInfo:(UserInfoModel *)userInfoModel succeed:(void(^)())succeed failed:(void(^)(NSError *))failed;





@end
