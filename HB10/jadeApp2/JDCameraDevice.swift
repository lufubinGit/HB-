////
////  File.swift
////  jadeApp2
////
////  Created by JD on 2017/1/12.
////  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
////
//
//import Foundation
//
//public class JDCameraDevice:NSObject {
//    
//    //prop
//    var remark : NSString?          //备注
//    var camerName : NSString?       //用户给摄像机取得账户名
//    var camerPassword : NSString?   //用户给摄像机去的账户密码
//    var cloudID : NSString?         //摄像机的云ID
//    var currentImage : NSData?     //摄像机当前的视图画面
//    var camerNetIsonline : Bool = false   //摄像机是否在线
//    var conectTing : Bool = false
//    
//    //子设备拥有  主设备不具备的
//    var voice : Bool = false
//    var recording : Bool = false
//    
//    
////    var esee:EseeNetLive!
//    //lazy
//    
//    //func
//    
//    /**
//     /连接设备
//     */
//    func connect(complated:@escaping () -> ()) {
//        
//        if self.conectTing == false{
//            self.conectTing = true
//             esee = EseeNetLive.init(eseeNetLiveVideoWithFrame: CGRect.init())
//            esee .setDeviceInfoWithDeviceID(self.cloudID as String!, passwords: self.camerPassword as String!, userName: self.camerName as String!, channel: 0, port: 0)
//            esee.connect(withPlay: false, bitRate: SD) { (result:EseeNetState) in
//                if result == EseeNetStateConnectSuccess||result == EseeNetStateLoginSuccess||result == EseeNetStateLoading{
//                    self.camerNetIsonline = true
//                }else{
//                    self.camerNetIsonline = false
//                }
//                self.conectTing = false
//                //连界回调之后应该 运行block
//               complated()
//            }
//        }
//    }
//    
//    func palyCamer()  {
//        
//    }
//    func stopCamer() {
//        
//    }
//    
//    func exist() -> Bool{
//        let camerArr = (UserDefaults.standard.value(forKey: CamerAdrr) as? NSArray)
//        if(camerArr != nil){
//            for dict:NSDictionary in camerArr as! [NSDictionary] {
//                if((dict.value(forKey: "cloudID")as! String).isEqual(self.cloudID)){
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    func saveCamer(){
//        //保存起来并返回
//        let camerArr = (UserDefaults.standard.value(forKey: CamerAdrr) as? NSArray)
//        let mutArr: NSMutableArray = NSMutableArray.init()
//        let dic = getClassAllPorp(aObject: self,filter: ["esee","currentImage"]) as? NSMutableDictionary
//        if(camerArr != nil){
//            mutArr.addObjects(from: camerArr as! [Any])
//            for dict:NSDictionary in camerArr as! [NSDictionary] {
//                if((dict.value(forKey: "cloudID")as! String).isEqual(self.cloudID)){
//                    mutArr .remove(dict)
//                }
//            }
//        }
//        mutArr.add(dic!)
//        let UD = UserDefaults()
//        UD.setValue(mutArr, forKey: CamerAdrr)
//        UD.synchronize()
//    }
//    
//    func deleteCamer(){
//        let camerArr:NSArray = (UserDefaults.standard.value(forKey: CamerAdrr) as? NSArray)!
//        let mutArr: NSMutableArray = NSMutableArray.init()
//        for dic:NSDictionary in camerArr as! [NSDictionary]{
//            if (self.cloudID?.isEqual(to: dic.value(forKey: "cloudID") as! String))!{
//                mutArr.remove(dic)
//            }
//        }
//        let UD = UserDefaults()
//        UD.setValue(mutArr, forKey: CamerAdrr)
//        UD.synchronize()
//    }
//    
//}
