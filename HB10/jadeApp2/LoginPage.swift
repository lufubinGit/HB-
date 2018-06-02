//
//  LoginPage.swift
//  HB10
//
//  Created by JD on 2017/7/12.
//  Copyright © 2017年 JD. All rights reserved.
//

import UIKit

class LoginPage: BaseViewController {
    
    var isLogin :Bool = false
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var regiestButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var accountText: UITextField!
    var account: BNTextFiled!
    @IBOutlet weak var pswText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: "\(LoginPage.self)", bundle: nil)
        
        print("DemoViewController----initWithNilName")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        let rect:CGRect = CGRect.init(x: self.accountText.x, y: self.accountText.y, width: 0.95*SCREEN_WIDTH, height: self.accountText.height)
        self.accountText.isHidden = true
        self.account = BNTextFiled.init(recordTextWithIdentify: "loginUserName", frame: rect, insuper: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.account.frame = CGRect.init(x: self.accountText.x, y: self.accountText.y, width: 0.95*SCREEN_WIDTH, height: self.accountText.height)
        }
        self.account.borderStyle = UITextBorderStyle.roundedRect
        self.account.font = UIFont.systemFont(ofSize: 14)
        self.account.recordCall = { dict in
            let dic:NSDictionary = (dict as NSDictionary?)!
            self.account.text =  dic.value(forKey: "accout") as? String;
            self.pswText.text =  dic.value(forKey: "psw") as? String;
        }
        
        if self.account.inputRecordListArr.count > 0 {
            if let dic :NSDictionary = self.account.inputRecordListArr.last as? NSDictionary {
                self.account.text =  dic.value(forKey: "accout") as? String;
                self.pswText.text =  dic.value(forKey: "psw") as? String;
            }
        }
        
        self.account.placeholder = Local(str: "Your E-mail")
        self.pswText.placeholder = Local(str: "Your password")

        self.title = Local(str:"Sign in")
        self.account.clearButtonMode = UITextFieldViewMode.whileEditing
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
        self.pswText.leftView = pswBg
        self.pswText.leftViewMode = UITextFieldViewMode.always
        self.pswText.clearButtonMode = UITextFieldViewMode.never
        
        let eyesButton:UIButton = UIButton.init(type: UIButtonType.custom)
        eyesButton.setImage(#imageLiteral(resourceName: "eyes_close"), for: UIControlState.normal)
        eyesButton.setImage(#imageLiteral(resourceName: "eyes_open"), for: UIControlState.selected)
        eyesButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        eyesButton.addTarget(self, action: #selector(openEye), for: .touchUpInside)
        self.pswText.rightView = eyesButton
        self.pswText.rightViewMode = .whileEditing
        
        self.loginButton.layer.cornerRadius = PublicCornerRadius
        self.loginButton.layer.masksToBounds = true
        self.loginButton.setTitle(Local(str:"Sign in"), for:UIControlState.normal)
        self.loginButton.backgroundColor = APPMAINCOLOR
        self.dismissKeyBEnable = true
        
        self.forgetButton.setTitle(Local(str: "forget"), for: .normal)
        self.regiestButton.setTitle(Local(str: "Register"), for: .normal)
    
        guard self.isLogin else {
            let backButton : UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            backButton.setImage(UIImage.init(named: "JDBack")?.BlendingColor(color: UIColor.white), for: UIControlState.normal)
            backButton.setImage(UIImage.init(named: "JDBack")?.BlendingColor(color: UIColor.white.withAlphaComponent(0.3)), for: UIControlState.highlighted)
            //        backButton.setTitle("返回", for: UIControlState.normal)
            backButton.setTitleColor(MainAPPColor, for: UIControlState.normal)
            backButton.setButtonImageSize(type: FBButtonType.ImageLeft, space: 0)
            backButton.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
            return
        }
    }

    func openEye(btn:UIButton){
        btn.isSelected = !btn.isSelected
        self.pswText.isSecureTextEntry = !btn.isSelected
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.dismisKeyB()
        if(self.account.text?.isEmpty)!{
       
            SVProgressHUD.showInfo(withStatus: Local(str: "Account can not be empty"))
            return
        }
        if(self.pswText.text?.isEmpty)!{
            SVProgressHUD.showInfo(withStatus:Local(str: "Password can not be empty"))
            return
        }
        print("开始登录")
        SVProgressHUD.show(withStatus: Local(str: "Loading"))
        GizSupport.sharedGziSupprot().gizLogin(withUserName: self.account.text, password: self.pswText.text, succeed: {
            print("登录成功");
            GizSupport.sharedGziSupprot().gizUserName = self.account.text
            GizSupport.sharedGziSupprot().gizUserPassword = self.pswText.text
            GizSupport.sharedGziSupprot().isLogined = true
            GizSupport.sharedGziSupprot().gizUserPassword = self.pswText.text
            self.account.saveInputContent(self.account.text, psw: self.pswText.text)

            self.navigationController?.dismiss(animated: true, completion: {
                SVProgressHUD.showSuccess(withStatus: Local(str: "accomplish"))

            })
        }) { (errStr) in
            SVProgressHUD.showError(withStatus:Local(str: errStr!) )
        }

        
//        
//        NSString *accout = self.username.text;
//        NSString *psw = self.passWordTextfiled.text;
//        [SVProgressHUD showWithStatus:Local(@"Loading")];
//        [[GizSupport sharedGziSupprot] gizLoginWithUserName:accout password:psw Succeed:^{
//            [GizSupport sharedGziSupprot].GizUserName = accout;
//            [GizSupport sharedGziSupprot].GizUserPassword = psw;
//            [GizSupport sharedGziSupprot].isLogined = YES;
//            [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
//            [self dismissViewControllerAnimated:YES completion:^{
//            [self.username saveInputContent:[GizSupport sharedGziSupprot].GizUserName psw:[GizSupport sharedGziSupprot].GizUserPassword];
//            }];
//            } failed:^(NSString *err){
//            [SVProgressHUD showErrorWithStatus:Local(err)];
//            }];

    }
    
    @IBAction func forget(_ sender: Any) {
        
        let page:UserFormatPswPage = UserFormatPswPage.init()
        page.isPhone = false;
        self.navigationController?.pushViewController(page, animated: true)
    }
    
    @IBAction func regiester(_ sender: Any) {
       self.navigationController?.pushViewController(UserRegiesterPage(), animated: true)
    }
    
    func back(_ sender: Any) {
        self.navigationController?.dismiss(animated: true) {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginPage:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        guard self.isLogin else {
            return navigationController.setNavigationBarHidden(false, animated: true)
        }
        guard viewController.isKind(of: LoginPage.classForCoder()) else {
            return navigationController.setNavigationBarHidden(false, animated: true)
        }
        navigationController.setNavigationBarHidden(false, animated: true)

    }

}
