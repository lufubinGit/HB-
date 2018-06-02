//
//  Headfile.swift
//  jadeApp2
//
//  Created by JD on 2017/1/10.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

import Foundation

//公共使用常量
let SCREEN_HIGHT:CGFloat = UIScreen.main.bounds.size.height
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let CamerAdrr = GizSupport.sharedGziSupprot().gizUserName + "JDCamerAdrr"
let GetACamer = "getNewCamer"
let GetDevicePhone = "getdevicephone"
let ModifyDeviceNumSuc = "ModifyDeviceNumSuc"
let AppLanguage:String = "appLanguage"

//颜色
let APPBLUECOlOR = RGBA(r:100,g:200,b:200,a:1) //蓝色
let APPMAINCOLOR = RGBA(r:208,g:20,b:23,a:1.0)//APP 主色调
let APPAMAINNAVCOLOR  =  RGBA(r:208,g:20,b:23,a:1.0)  //导航颜色
let APPSAFEGREENCOLOR = RGBA(r:0,g:238,b:0,a:1)//安全绿色
let APPGRAYBLACKCOLOR = RGBA(r:85,g:88,b:85,a:1)// 灰黑色
let APPBACKGROUNDCOLOR = RGBA(r:230,g:230,b:230,a:1)//默认的灰色背景
func APPLINECOLOR()->UIColor{
    return UIColor.init(white: 0.0, alpha: 0.1)
}

//let APPLINECOLOR = [UIColor colorWithWhite:0.6 alpha:0.3]  //人工线条颜色
//本地化语言
// MARK - 语言本地化相关代码  **************************************************
func setAppLanguage(type:JDGSMLaunageType){
    var aStr:String? = ""
    if(type == JDGSMLaunageType.EN){
        aStr = "en"
    }else if(type == JDGSMLaunageType.CH){
        aStr = "zh-Hans"
    }else if(type == JDGSMLaunageType.RU){
        aStr = "ru"
    }else{
        aStr = "en"
    }
    UserDefaults.standard.set(aStr, forKey: AppLanguage)
    UserDefaults.standard.synchronize()
}

func appLanguage()->JDGSMLaunageType{  //默认情况使用当前APP使用的语言。当没有任何设置的时候， 只要设置一次之后就会使用中文了／
    var obj = UserDefaults.standard.object(forKey: AppLanguage)
    if(obj == nil){
        let languages = Locale.preferredLanguages
        obj = languages.first!
    }
    if((obj as! String).contains("en"))
    {
        return JDGSMLaunageType.EN
    }else if((obj as! String).contains("zh-Hans")){
        return JDGSMLaunageType.CH
        
    }else if((obj as! String).contains("ru")){
        return JDGSMLaunageType.RU
        
    }else{
        return JDGSMLaunageType.EN
    }
}

func Local(str: String)->String{
    var s:String = ""
    let type:JDGSMLaunageType = appLanguage()
    var path:String? = nil
    if(type == JDGSMLaunageType.EN){
        path = Bundle.main.path(forResource: "en", ofType: "lproj")!
    }else if(type == JDGSMLaunageType.CH){
        path = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
    }else if(type == JDGSMLaunageType.RU){
        path = Bundle.main.path(forResource: "ru", ofType: "lproj")
    }else{
        path = Bundle.main.path(forResource: "en", ofType: "lproj")!
    }
    let bundle = Bundle.init(path: path!)
    s = (bundle?.localizedString(forKey: str, value: "", table: nil))!
    return s
}


//点击键盘消失
func dismissKeyboard(aView:UIView){
    for view:UIView in aView.subviews {
        
        if view.isKind(of: UITextField.classForCoder()){
            view.resignFirstResponder()
        }
    }
    
}

//获取图片函数
func imageWithName(name:NSString) -> UIImage{
    return UIImage.init(named: name as String)!
}

//尺寸
func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
func X(aView:UIView) -> CGFloat {
    return aView.frame.origin.x
}
func Y(aView:UIView) -> CGFloat {
    return aView.frame.origin.y
}
func Hight(aView:UIView) -> CGFloat {
    return aView.bounds.size.height
}
func Width(aView:UIView) -> CGFloat {
    return aView.bounds.size.width
}
func CenterX(aView:UIView) -> CGFloat {
    return aView.center.x
}
func CenterY(aView:UIView) -> CGFloat {
    return aView.center.y
}
func Left(aView:UIView)->CGFloat{
    return aView.frame.origin.x + aView.frame.size.width
}
func Right(aView:UIView)->CGFloat{
    return aView.frame.origin.x
}
func Bottom(aView:UIView)->CGFloat{
    return aView.frame.origin.y + aView.frame.size.height
}
func Top(aView:UIView)->CGFloat{
    return aView.frame.origin.y
}

extension UIButton{
    //设置buton的文字和图片的位置
    func setButtonImageSize(type:FBButtonType, space:CGFloat){
        let space:CGFloat = space
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith:CGFloat = self.imageView!.frame.size.width
        let imageHeight:CGFloat = self.imageView!.frame.size.height
        let labelWidth:CGFloat = self.titleLabel!.intrinsicContentSize.width
        let labelHeight:CGFloat = self.titleLabel!.intrinsicContentSize.height
        if(type == FBButtonType.ImageLeft){
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }else if(type == FBButtonType.ImageBottom){
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }else if(type == FBButtonType.ImageTop){
            self.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }else if(type == FBButtonType.ImageRight){
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
    }
}

public class SwiftGlobleTool: NSObject {
    
    /**
     延时函数  最多可以延时七个回调
     */
    static let shareGlobleTool = SwiftGlobleTool()
    //最多可同时延时三个函数的执行
    var delayFirst:((Void)->(Void))?
    var delaySecond:((Void)->(Void))?
    var delayThird:((Void)->(Void))?
    var delayFouth:((Void)->(Void))?
    var delayFive:((Void)->(Void))?
    var delaySix:((Void)->(Void))?
    var delaySeven:((Void)->(Void))?
    var LaunchAPP:Bool = true

    func delayFirstRun() {
        self.delayFirst!()
        self.delayFirst = nil
    }
    func delaySecondRun() {
        self.delaySecond!()
        self.delaySecond = nil
    }
    func delayThirdRun() {
        self.delayThird!()
        self.delayThird = nil
    }
    func delayFourRun() {
        self.delayFouth!()
        self.delayFouth = nil
    }
    func delayFiveRun() {
        self.delayFive!()
        self.delayFive = nil
    }
    func delaySixRun() {
        self.delaySix!()
        self.delaySix = nil
    }
    func delaySevenRun() {
        self.delaySeven!()
        self.delaySeven = nil
    }
    
    func delayAction(atime:TimeInterval,closures: @escaping (Void) -> (Void)){
        
        if(delayFirst != nil){
            if(delaySecond != nil){
                if(delayThird != nil){
                    if(delayFouth != nil){
                        if(delayFive != nil ){
                            if(delaySix != nil){
                                if(self.delaySeven != nil){
                                    self.delaySeven = closures
                                    self.perform(#selector(delaySevenRun), with: nil, afterDelay: atime)
                                }else{
                                    print("回调太快  暂无block 可用")
                                }
                            }else{
                                self.delaySix = closures
                                self.perform(#selector(delaySixRun), with: nil, afterDelay: atime)
                            }
                        }else{
                            self.delayFive = closures
                            self.perform(#selector(delayFiveRun), with: nil, afterDelay: atime)
                        }
                    }else{
                        self.delayFouth = closures
                        self.perform(#selector(delayFourRun), with: nil, afterDelay: atime)
                    }
                    
                }else{
                    self.delayThird = closures
                    self.perform(#selector(delayThirdRun), with: nil, afterDelay: atime)
                }
            }else{
                self.delaySecond = closures
                self.perform(#selector(delaySecondRun), with: nil, afterDelay: atime)
            }
        }else{
            self.delayFirst = closures
            self.perform(#selector(delayFirstRun), with: nil, afterDelay: atime)
        }
    }
    
    func addMaskImage(aView:UIView) {
        let launchView:UIImageView = UIImageView.init(frame: CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height: SCREEN_HIGHT))
        launchView.image = UIImage.init(named: "JD_GATE_1242x2208")
        if( SCREEN_HIGHT/SCREEN_WIDTH == 1.5){
            launchView.image = UIImage.init(named: "JD_GATE_4S")
        }
        launchView.backgroundColor = UIColor.white
        
        aView.addSubview(launchView)
//        self.delayAction(atime: 3) { () -> (Void) in
//            
////            UIView.animate(withDuration: 2.0, animations: {
////                aView.alpha = 0
////                aView.center = CGPoint.init(x: SCREEN_WIDTH/2.0, y: SCREEN_HIGHT/2.0)
////                aView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH*sizeScale, height: SCREEN_HIGHT*sizeScale)
////            })
//            SwiftGlobleTool.shareGlobleTool.LaunchAPP = false
//        }
    }

}



/**
 *  按钮的类别
 */
internal enum FBButtonType{
    case ImageLeft    //图片在左边
    case ImageTop     //图片在上方
    case ImageRight   //图片在右边
    case ImageBottom  //图片在下边
    //    case OnlyImage    //只有图片
    //    case OnlyTitle    //只有文字
}
/**
 *  语言
 */
internal enum JDGSMLaunageType{
    case EN         //英文
    case CH         //中文
    case RU         //俄文
}
