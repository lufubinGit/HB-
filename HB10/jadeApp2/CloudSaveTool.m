//
//  CloudSaveTool.m
//  jadeApp2
//
//  Created by JD on 2016/10/24.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "CloudSaveTool.h"
#import "UserInfoModel.h"
#import "NSData+DataToDic.h"
#import "NSDictionary+DicToData.h"
#import "NSObject+GetAllProp.h"
#import <objc/runtime.h>
#import "JDAppGlobelTool.h"



//如果需要设置空间  一般用于多个APP的之间的使用
#define UserInfoPlace @"JDuserInfo"
#define UserInfoPlaceType  @"NewRecordType"


//默认空间中的数据的type
#define UserRecordType @"Users"


@implementation CloudSaveTool

//初始化方法
+ (CloudSaveTool *)shareInstance{
    static CloudSaveTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[CloudSaveTool alloc] init];
    });
    return tool;
}

//存储 用户的信息 目标
- (void)cloudSaveObject:(UserInfoModel *)userInfoModel succeed:(void(^)())succeed failed:(void(^)(NSError *))failed{
    

    NSString * str = [self filterAccout:userInfoModel.userAccout];
    CKRecordID *postrecordID = [[CKRecordID alloc]initWithRecordName:str];
    
    CKRecord *postRecrod = [[CKRecord alloc] initWithRecordType:str recordID:postrecordID];
    
    //将用户类的属性和属性值打包成一个字典  其中属性对应key 属性值对应Value  因为属性中有一栏是图片类，CloudKit不支持直接对图片进行保存，但是可以转换成NSdata，这洋就可以进行保存了
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableArray *propArr = [self getAllProp:[userInfoModel class]];
    for (NSString *prop in propArr) {
        if([[userInfoModel valueForKey:prop] isKindOfClass:[UIImage class]]){
            UIImage *image = [userInfoModel valueForKey:prop] ;

            postRecrod[prop] = [NSData dataWithData:UIImagePNGRepresentation(image)];
            
        }else{
            postRecrod[prop] = [userInfoModel valueForKey:prop];
        }
    }
    //将字典打包成data
//    NSData *data = [dic dicToData];
    
    
    //record有点类似于字典， 可以直接使用键值的方式存入数据
//    postRecrod[userInfoModel.userAccout] = data;
    
    NSLog(@"%@",postRecrod);
    
    //用户信息 提交到 云
    [[[CKContainer defaultContainer] privateCloudDatabase] saveRecord:postRecrod completionHandler:^(CKRecord *savedPlace, NSError *error) {
        if(savedPlace){
            NSLog(@"%@",savedPlace);
            if(succeed){
                succeed();
            }
        }else{
            if(error){
                if(failed){
                    failed(error);
                }
            }
        }
    }];
}


//获取用户信息
- (void )cloudGetUserInfoWithUseraccout:(NSString *)userAccout Succeed:(void(^)(UserInfoModel* ))succeed failed:(void(^)(NSError *))failed{
    NSString * str = [self filterAccout:userAccout];

    UserInfoModel *model = [[UserInfoModel alloc]init];
    if(str){
        CKRecordID *postrecordID = [[CKRecordID alloc]initWithRecordName:str];
        [[[CKContainer defaultContainer] privateCloudDatabase] fetchRecordWithID:postrecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            // handle errors here
            if(error){
                if(failed){
                    
                    failed(error);
                }
            }else{  //说明查询成功
                if(succeed){
                    
                    //已经获取到了存入的数据， 并经过转换存入了字典 dic  将字典中的键值对赋给一个类对应的属性 同理因为其中有一个图片 所以需要做一个NSdata的转换
                    NSMutableArray *mArray = [self getAllProp:[model class]];
                    for (NSString *prop in mArray) { //这里如果不是在后台人为添加的数据 不会出现没有对应的属性的情况  但是为了保险起见。在UserInfoModel 重写 setVale：forUndefinedKey方法
                        id info = [record valueForKey:prop];
                        if(![info isKindOfClass:[NSData class]]){
                            //                        [model setValue:[dic valueForKey:prop] forKey:prop];
                            [model setValue:record[prop] forKey:prop];
                            
                        }else{
                            UIImage *image = [UIImage imageWithData:info];
                            [model setValue:image forKey:prop];
                        }
                    }
                  
                    NSString *path =  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserAvtar.png",userAccout]];
                    NSData *imageData = UIImagePNGRepresentation(model.userAvtar);
                    if([imageData writeToFile:path atomically:YES]){
                        NSLog(@"头像保存到本地成功");
                    }
                    succeed(model);
                }
            }
        } ];
    }
}

//修改用户的信息
- (void)cloudModifyUserInfo:(UserInfoModel *)userInfoModel succeed:(void(^)())succeed failed:(void(^)(NSError *))failed{
  
    NSString * str = [self filterAccout:userInfoModel.userAccout];
    CKRecordID *postrecordID = [[CKRecordID alloc]initWithRecordName:str];
    [[[CKContainer defaultContainer] privateCloudDatabase] deleteRecordWithID:postrecordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if(!error){
        
            [self cloudSaveObject:userInfoModel succeed:^{
                if(succeed){
                    succeed();
                }
            } failed:^(NSError *err) {
                if(failed){
                    failed(err);
                }
            }];
        }else{
        
            if(failed){
                NSLog(@"删除失败");
                failed(error);
            }
        }
    }];
}

//过滤数字开头的账户
- (NSString *)filterAccout:(NSString *)accout{

    NSString *mutStr = [NSString stringWithFormat:@"A%@",accout];
    if([accout containsString:@"@"]){
        mutStr = [mutStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
        mutStr = [mutStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    return mutStr;
}



@end
