//
//  EidtPhoneNumPage.swift
//  jadeApp2
//
//  Created by JD on 2017/2/9.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

import Foundation

fileprivate let cellHei:CGFloat = 60

class PhoneNum: NSObject {
    var PhoneNum: String! = ""
    var index: NSNumber! = nil
    var type: NSNumber! = nil
    var type1 : Bool = false
    var type2 : Bool = false
    
}

class ModifyPhoneNumPage: BaseViewController {
    var PN : PhoneNum! = nil
    var currentDevice : DeviceInfoModel! = nil
    var textF:UITextField! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.view.backgroundColor = APPBACKGROUNDCOLOR
        self.title = PN.PhoneNum
        let Bgview:UIView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: cellHei))
        Bgview.backgroundColor = UIColor.white
        
        textF = UITextField.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH-20, height: cellHei))
        textF.placeholder = PN.PhoneNum
        textF.textAlignment = NSTextAlignment.left
        textF.keyboardType = UIKeyboardType.numberPad
        textF.delegate = self
        Bgview.addSubview(textF)
        self.view.addSubview(Bgview)
        
        //添加保存按钮
        let saveButton = UIButton.init(type: UIButtonType.custom)
        saveButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        saveButton.setTitle(Local(str: "Save"), for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.init(white: 1.0, alpha: 0.3), for: UIControlState.highlighted)
        saveButton.addTarget(self, action: #selector(save), for: UIControlEvents.touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(refrshData), name: NSNotification.Name(rawValue: ModifyDeviceNumSuc), object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: saveButton)
    }
    
    func refrshData() {
        SVProgressHUD.dismiss()
        self.navigationController!.popViewController(animated: true)
    }
    
    func save(){
        if(textF.text == nil){
            SVProgressHUD.showInfo(withStatus: Local(str: "Please enter the correct phone number."))
            return
        }
        SVProgressHUD.show(withStatus: "")
        self.currentDevice.eidtPhoneInfo(withType: PN.type.intValue, index: PN.index.intValue, num:textF.text)
        
    }
}

extension ModifyPhoneNumPage: UITextFieldDelegate{
   
}

class EidtPhoneNumPage : BaseViewController{
    var currentDevice : DeviceInfoModel! = nil
    var  eidtButton:UIButton! = nil
    lazy var mytableView : UITableView = {
        let myTableview = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HIGHT), style: UITableViewStyle.plain)
        myTableview.delegate = self
        myTableview.dataSource = self
        myTableview.backgroundColor = UIColor.clear
        myTableview.tableFooterView = self.creatTableFooterView()
        myTableview.register(UINib.init(nibName: "EidtPhoneNumCell", bundle: nil), forCellReuseIdentifier: "EidtPhoneNumCell")
        return myTableview
    }()

    lazy var changeArr : NSMutableArray = {
        var changeArr = NSMutableArray.init()
        return changeArr
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentDevice.getPhoneNum()
        self.initUI()
        self.addNotic()
    }
    
    func initUI(){
        self.view.backgroundColor = APPBACKGROUNDCOLOR
        self.addEidtButton()
        self.view.addSubview(self.mytableView)
    }
    
    func addNotic(){
        NotificationCenter.default.addObserver(self, selector: #selector(refrshData), name: NSNotification.Name(rawValue: GetDevicePhone), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modiySuc), name: NSNotification.Name(rawValue: ModifyDeviceNumSuc), object: nil)
        
    }
    
    func addEidtButton() {
        eidtButton = UIButton.init(type: UIButtonType.custom)
        eidtButton.backgroundColor = UIColor.clear
        eidtButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        eidtButton.addTarget(self, action: #selector(eidtNum), for: UIControlEvents.touchUpInside)
        eidtButton.setTitle(Local(str: "Eidt"), for: UIControlState.normal)
        
        eidtButton.isEnabled = false
        eidtButton.setTitleColor(UIColor.init(white: 1.0, alpha: 0.3), for: UIControlState.highlighted)
        eidtButton.setTitleColor(UIColor.init(white: 1.0, alpha: 0.3), for: UIControlState.disabled)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: eidtButton)
        
    }
    
    func eidtNum(button:UIButton) {
        self.mytableView.setEditing(!self.mytableView.isEditing, animated: true)
        if(self.mytableView.isEditing){
            eidtButton.setTitle(Local(str: "OK"), for: UIControlState.normal)
        }else{
            eidtButton.setTitle(Local(str: "Eidt"), for: UIControlState.normal)

        }
    }
    
    func saveInfo() {
        SVProgressHUD.show(withStatus: "")
        for i in 0..<self.changeArr.count{
            let PN :PhoneNum = self.changeArr[i] as!PhoneNum
            if (PN.type1 == true && PN.type2 == true){
                PN.type = 3
            }else if(PN.type1 == false && PN.type2 == true){
                PN.type = 2
            }else if(PN.type1 == true && PN.type2 == false){
                PN.type = 1
            }else{
                PN.type = 0
            }
            self.currentDevice.eidtPhoneInfo(withType: PN.type.intValue, index: PN.index.intValue, num: PN.PhoneNum)
        }
        self.changeArr.removeAllObjects()
    }
    
    func refrshData(){
        self.mytableView.reloadData()
        SVProgressHUD.dismiss()
        if(self.currentDevice.phoneNumArr != nil){
            if(self.currentDevice.phoneNumArr.count > 0){
                eidtButton.isEnabled = true
            }else{
                eidtButton.isEnabled = false
            }
        }
    }
    
    func modiySuc() {
        self.currentDevice.getPhoneNum()
        self.refrshData()
    }
    
    func addNum(){
        
        if(self.currentDevice.phoneNumArr != nil){
            if(self.currentDevice.phoneNumArr.count>=6){
                SVProgressHUD.showInfo(withStatus:Local(str: "You can add up to six phone numbers."))
                return;
            }
        }
            let alertVC = UIAlertController.init(title: Local(str: "Add a phone number."), message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertVC.addTextField { (text) in
                text.placeholder = Local(str: "Enter the phone number you want to add.")
                text.keyboardType = UIKeyboardType.numberPad
            }
            alertVC.addAction(UIAlertAction.init(title: Local(str: "OK"), style: UIAlertActionStyle.default, handler: { (OKaction) in
                let text:UITextField = (alertVC.textFields?.first)!
                if((text.text?.count)! > 0){
                    self.currentDevice.addDevicePhonNum(text.text)
                    SVProgressHUD.show(withStatus: "")
                }
                alertVC.dismiss(animated: true, completion: nil)
            }))
            alertVC.addAction(UIAlertAction.init(title: Local(str: "Cancle"), style: UIAlertActionStyle.cancel, handler: { (cancleAction) in
                alertVC.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func creatTableFooterView() -> UIView{
    
        let footerView  = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: cellHei))
        footerView.backgroundColor = UIColor.clear
        footerView.isUserInteractionEnabled = true
        
        let BgView = UIView.init(frame: CGRect.init(x: 5, y: 5, width: SCREEN_WIDTH-10, height: cellHei-10))
        BgView.backgroundColor = UIColor.white
        BgView.layer.masksToBounds = true
        BgView.layer.cornerRadius = 3.0
        BgView.isUserInteractionEnabled = true
        
        let addButton = UIButton.init(type: UIButtonType.custom)
        addButton.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-10, height: cellHei-10)
        addButton.setImage(imageWithName(name: "phoneNumAdd"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addNum), for: UIControlEvents.touchUpInside)
        BgView.addSubview(addButton)
        footerView.addSubview(BgView)
        return footerView
    }
    
    
    func creatTableheadView() -> UIView {
        
        // 总开关
 
        let wifiEnableView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        let titleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH - 65, height: wifiEnableView.height))
        let openS = UISwitch.init(frame: CGRect.init(x: SCREEN_WIDTH - 60, y: 0, width: 50, height: 30))
        openS.centerY = wifiEnableView.height/2.0
        openS.isOn = false
        titleLabel.textColor = APPGRAYBLACKCOLOR
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = Local(str: "Send alarm message only when the host is not Wi-Fi")
        let line0 : UIView = UIView.init(frame: CGRect.init(x: 0, y: Hight(aView: wifiEnableView)-1, width: SCREEN_HIGHT, height: 1))
        line0.backgroundColor = APPLINECOLOR()
        
        wifiEnableView.addSubview(titleLabel)
        wifiEnableView.addSubview(openS)
        wifiEnableView.addSubview(line0)

        let datapoint = currentDevice.gizDeviceDataPointArr.filter { (item) -> Bool in
            if let dataP = item as? DataPointModel{
                return dataP.dataPointName == "sms_control"
            }
            return false
        }
        
        if datapoint.count > 0{
            if let data = datapoint.first as? DataPointModel {
                if let bol =  data.dataPointValue as? String{
                    openS.isOn = bol == "1"  //只有当值为1的时候才是打开的
                }
                if let bol =  data.dataPointValue as? Int{
                    openS.isOn = bol == 1 //只有当值为1的时候才是打开的
                }
            }
        }
        
        openS.addTarget(self, action: #selector(setWifiSwitch), for: .valueChanged)
        
        // 描述信息
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: cellHei/1.5 + wifiEnableView.height))
        headView.backgroundColor = UIColor.white
        let numlabel = UILabel.init(frame: CGRect.init(x: 18, y: wifiEnableView.height, width: SCREEN_WIDTH*0.6, height: cellHei/2.0))
        numlabel.textAlignment = NSTextAlignment.left
        numlabel.textColor = APPGRAYBLACKCOLOR
        numlabel.text = Local(str: "Preset phone number")
        numlabel.font = UIFont.systemFont(ofSize: 14)
        
        let callLabel = UILabel.init(frame: CGRect.init(x:SCREEN_WIDTH*0.6-8, y: wifiEnableView.height, width: SCREEN_WIDTH*0.2, height: cellHei/2.0))
        callLabel.textAlignment = NSTextAlignment.center
        callLabel.textColor = APPGRAYBLACKCOLOR
        callLabel.numberOfLines = 0
        callLabel.text = Local(str: "Dialing alarm")
        callLabel.font = UIFont.systemFont(ofSize: 13)
        
        let messageLabel = UILabel.init(frame: CGRect.init(x:SCREEN_WIDTH*0.8-8, y: wifiEnableView.height, width: SCREEN_WIDTH*0.2, height: cellHei/2.0))
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.textColor = APPGRAYBLACKCOLOR
        messageLabel.numberOfLines = 0
        messageLabel.text = Local(str: "SMS alarm")
        messageLabel.font = UIFont.systemFont(ofSize: 13)

        let line : UIView = UIView.init(frame: CGRect.init(x: 0, y: Hight(aView: headView)-1, width: SCREEN_HIGHT, height: 1))
        line.backgroundColor = APPLINECOLOR()
        
        headView.addSubview(numlabel)
        headView.addSubview(callLabel)
        headView.addSubview(messageLabel)
        headView.addSubview(line)
        headView.addSubview(wifiEnableView)
        
        return headView
    }
    
    func setWifiSwitch(s: UISwitch){
        var str = "0"
        if s.isOn { str = "1" }
        let request = ["sms_control":Int(str)]
        SVProgressHUD.show(withStatus: "")
        GizSupport.sharedGziSupprot().gizSendOrder(withSN: 661, device: self.currentDevice, withOrder: request as Any as! [AnyHashable : Any]) { (dic) in
            
            debugPrint("设置 仅仅在 wifi 下发送 信息的回调。")

            if let data = dic!["data"] as? NSDictionary {
                if let sms_control = data["sms_control"] as? Int{
                    s.isOn = sms_control == 1
                    SVProgressHUD.dismiss()
                    return
                }
            }
            s.isOn = !s.isOn
            // 设置 仅仅在 wifi 下发送 信息的回调。
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK -@protocol UITableViewDelegate
extension EidtPhoneNumPage: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EidtPhoneNumCell = tableView.dequeueReusableCell(withIdentifier: "EidtPhoneNumCell") as! EidtPhoneNumCell
        cell.setCell(phone: self.currentDevice.phoneNumArr[indexPath.row] as! PhoneNum)
        let PN :PhoneNum = self.currentDevice.phoneNumArr[indexPath.row] as!PhoneNum
       
        let CallBlock:(Bool!) -> Void = {
        abool in
                PN.type2 = abool
                print("type2 电话改变\(PN.type2)")
                var k:Int = 0
                for i in 0..<self.changeArr.count {
                    let pn:PhoneNum = self.changeArr[i] as! PhoneNum
                    if(PN.index.intValue == pn.index.intValue){
                        k = k+1
                    }
                }
                if(k==0){
                    self.changeArr.add(PN)
                }
            self.saveInfo()
        }
        cell.clickedCallButtonAction = CallBlock
        let MsnBlock:(Bool!) -> Void = {
            abool in
                PN.type1 = abool
                //            self.changeArr.add(PN)
                print("type1 短信改变\(PN.type1)")
                var k:Int = 0
                for i in 0..<self.changeArr.count {
                    let pn:PhoneNum = self.changeArr[i] as! PhoneNum
                    if(PN.index.intValue == pn.index.intValue){
                        k = k+1
                    }
                }
                if(k==0){
                    self.changeArr.add(PN)
                }
             self.saveInfo()
        }
        cell.clickedMsnButtonAction = MsnBlock

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

//MARK -@protocol UITableViewDataSource
extension EidtPhoneNumPage: UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.currentDevice.phoneNumArr != nil){
            return self.currentDevice.phoneNumArr.count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHei
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.creatTableheadView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHei/1.5 + 50
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionArr = NSMutableArray.init()
        let deleteAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: Local(str: "delete")) { (dleteAction, IndexPath) in
            //删除
            let PN :PhoneNum = self.currentDevice.phoneNumArr[indexPath.row] as!PhoneNum
            self.currentDevice.eidtPhoneInfo(withType: PN.type.intValue, index: PN.index.intValue, num: "111111111111111")
        }
        let eidtAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: Local(str: "Eidt")) { (dleteAction, IndexPath) in
            //进入编辑
            let page:ModifyPhoneNumPage = ModifyPhoneNumPage.init()
            page.currentDevice =  self.currentDevice
            page.PN = self.currentDevice.phoneNumArr[indexPath.row] as! PhoneNum
            self.navigationController?.pushViewController(page, animated: true)

        }
        actionArr.add(deleteAction)
        actionArr.add(eidtAction)
        return actionArr as? [UITableViewRowAction]
    }

}

