//
//  UserRegiesterPage.swift
//  HB10
//
//  Created by JD on 2017/7/12.
//  Copyright © 2017年 JD. All rights reserved.
//

import UIKit
var MainBackGroundColor:UIColor = RGBA(r: 237, g: 236, b: 236, a: 1.0)
var MainAPPColor :UIColor = RGBA(r: 208, g: 20, b: 23, a: 1.0)
let SeconBlueColor:UIColor = RGBA(r: 208, g: 20, b: 23, a: 1.0) //深蓝色
var PublicCornerRadius :CGFloat = 5.0


class UserRegiesterPage: BaseViewController {
    
    @IBOutlet weak var tipTwwo: UILabel!
    @IBOutlet weak var tipOne: UILabel!
    @IBOutlet weak var tipThree: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var psw: UITextField!
    @IBOutlet weak var checkPsw: UITextField!
    @IBOutlet weak var regiesterButton: UIButton!
    var canAction:Bool = false
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: "\(UserRegiesterPage.self)", bundle: nil)
        
        print("DemoViewController----initWithNilName")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Local(str: "Register")
        self.account.placeholder = Local(str: "Your E-mail")
        self.psw.placeholder = Local(str: "Please enter the account password")
        self.checkPsw.placeholder = Local(str: "Check the password")
        
        let accountIcon :UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 20, height: 20))
        accountIcon.image = UIImage.init(named: "user_name")
        let accountBg:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: 30, height: 20))
        accountBg.addSubview(accountIcon)
        self.account.leftView = accountBg
        self.account.leftViewMode = UITextFieldViewMode.always
        
        let pswIcon :UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 20, height: 20))
        pswIcon.image = UIImage.init(named: "password")
        let pswBg:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: 30, height: 20))
        pswBg.addSubview(pswIcon)
        self.psw.leftView = pswBg
        self.psw.leftViewMode = UITextFieldViewMode.always
        
        let pswIcon1 :UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 20, height: 20))
        pswIcon1.image = UIImage.init(named: "password")
        let pswBg1:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: 30, height: 20))
        pswBg1.addSubview(pswIcon1)
        self.checkPsw.leftView = pswBg1
        self.checkPsw.leftViewMode = UITextFieldViewMode.always
        
        self.account.delegate = self
        self.psw.delegate = self
        self.checkPsw.delegate = self
        
        
        let backButton : UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage.init(named: "JDBack")?.BlendingColor(color:UIColor.white ), for: UIControlState.normal)
        backButton.setImage(UIImage.init(named: "JDBack")?.BlendingColor(color: UIColor.white.withAlphaComponent(0.3)), for: UIControlState.highlighted)
        backButton.setTitleColor(MainAPPColor, for: UIControlState.normal)
        backButton.setButtonImageSize(type: FBButtonType.ImageLeft, space: 0)
        backButton.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)

        self.tipOne.textColor = MainAPPColor
        self.tipTwwo.textColor = MainAPPColor
        self.tipThree.textColor = MainAPPColor
        self.tip.textColor = UIColor.gray
        self.tip.text = Local(str: "After registration, the user name can not be modified")
        self.dismissKeyBEnable = true

        
        self.regiesterButton.setTitle(Local(str: "Register"), for: .normal)
        self.regiesterButton.layer.cornerRadius = PublicCornerRadius
        self.regiesterButton.layer.masksToBounds = true
        self.regiesterButton.backgroundColor = APPMAINCOLOR
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func regiester(_ sender: Any) {
        self.dismisKeyB()
        self.check()
        if(!self.tipTwwo.isHidden || !self.tipThree.isHidden || !self.tipOne.isHidden){
            print("不能注册  信息不完整")
            return
        }
        print("开始注册")
        SVProgressHUD.show(withStatus: Local(str: "Loading"))
        GizSupport.sharedGziSupprot().gizRegiste(withUserName: self.account.text, password: self.psw.text, succeed: {
            print("注册成功")
            SVProgressHUD.showSuccess(withStatus: Local(str: "accomplish"))

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(Int(1.5)), execute: {
                print("延时  时间已经过了")
                self.navigationController?.popViewController(animated: true)

            })
            
//            SVProgressHUD.showSuccess(withStatus: Local(str: "accomplish"))
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 15 * 100000000), execute: {
//                self.navigationController?.popViewController(animated: true)
//
//            })
        }) { (errStr) in
            SVProgressHUD.showError(withStatus:Local(str: errStr!) )
        }
    }
    
    func back(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func check(){
        if(self.account.text?.isEmpty)!{
            tipOne.isHidden = false
            tipOne.text = Local(str:"Your E-mail")
            return
        }else{
            tipOne.isHidden = true
        }
        
        let pswLen:NSInteger = (self.psw.text?.characters.count)!
        if(pswLen == 0){
            tipTwwo.isHidden = false
            tipTwwo.text = Local(str: "Please enter a password")
            return
        }else{
//            if(pswLen>15||pswLen<6){
//                tipTwwo.isHidden = false
//                tipTwwo.text = Local(str: "Please enter a password")
//                return
//            }
            tipTwwo.isHidden = true
        }
        
        if(self.checkPsw.text?.isEmpty)!{
            tipThree.isHidden = false
            tipThree.text = Local(str: "Please enter a duplicate password")
            return
        }else{
            if(String(describing: self.psw.text) != String(describing: self.checkPsw.text)){
                tipThree.isHidden = false
                tipThree.text = Local(str: "The two passwords are not the same")
                return
            }
            tipThree.isHidden = true
        }
    }
}

extension UserRegiesterPage:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.check()
    }
}

extension UIImage{
    //改变图片的颜色
    public func BlendingColor(color:UIColor)->UIImage{
        let Galpha:CGFloat = color.cgColor.alpha
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        let rect:CGRect = CGRect.init(x: 0, y: 0, width:self.size.width ,height: self.size.height)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: CGBlendMode.overlay, alpha: Galpha)
        self.draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: Galpha)
        let newimage:UIImage =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newimage
    }
}
