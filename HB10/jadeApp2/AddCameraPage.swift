//
////  AddCameraPage.swift
////  jadeApp2
////
////  Created by JD on 2017/1/11.
////  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
////
//
//import Foundation
//import AVKit
//
//private let MytableviewTopHei: CGFloat = 30       //每一小行的高度
//private let JDCellHei: CGFloat = 40       //每一小行的高度
//private let NameLabelFont: CGFloat = 14   //行名称字体的大小
//private let ImageToCellHeiScale = 0.7       //图片的高度和cell的高度比
////MARK: AddCameraPage
//public class AddCameraPage: BaseViewController {
//    
//    //prop
//    
//    //lazy
//    lazy var myTableview: UITableView = {
//        let myTableview = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HIGHT), style: UITableViewStyle.plain)
//        myTableview.delegate = self
//        myTableview.dataSource = self
//        myTableview.tableFooterView = UIView()
//        myTableview.backgroundColor = UIColor.clear
//        myTableview.tableHeaderView = self.creatTableHeaderView()
//        myTableview.tableFooterView = self.creatTableFooterView()
//        return myTableview
//    }()
//    
//    lazy var contentArr: NSMutableArray = {
//        var contentArr = NSMutableArray.init()
//        return contentArr
//    }()
//    
//    lazy var dataArr: NSMutableArray = {
//        var dataArr:NSMutableArray = NSMutableArray.init(array:[Local(str:"CloudID:"),Local(str:"Remark:")])
////        ,Local(str:"Account:"),Local(str:"Password:")
//        return dataArr
//    }()
//    
//    lazy var imageArr : NSMutableArray = {
//        var imageArr:NSMutableArray =  NSMutableArray.init(array: [imageWithName(name: "addCamera_QR"),"","",imageWithName(name: "eyes_close")])
//        return imageArr
//    }()
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        self.initUI()
//    }
//    override public func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    override public func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
//    override public func dismisKeyB() {
//        for view:UIView in (self.myTableview.tableHeaderView?.subviews)! {
//            for xView:UIView in view.subviews {
//                if xView.isKind(of: UITextField.classForCoder()){
//                    xView.resignFirstResponder()
//                }
//            }
//        }
//    }
//    
//    //func
//    func initUI(){
//        self.title = Local(str: "Add a camera") as String
//        self.view.backgroundColor = APPBACKGROUNDCOLOR
//        self.view.addSubview(self.myTableview)
//        self.creartSaveButton()
//        self.dismissKeyBEnable = true
//    }
//    
//    
//    func creartSaveButton(){
//        let saveButton = UIButton.init(type: UIButtonType.custom)
//        saveButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
//        saveButton.setTitle(Local(str: "Save") as String, for: UIControlState.normal)
//        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//        saveButton.setTitleColor(UIColor.init(white: 1.0, alpha: 0.3), for: UIControlState.highlighted)
//        saveButton.addTarget(self, action: #selector(saveID), for: UIControlEvents.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: saveButton)
//    }
//    
//    func creatTableHeaderView() -> UIView{
//        let headerView:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(self.dataArr.count) * JDCellHei + MytableviewTopHei))
//        headerView.backgroundColor = UIColor.clear
//        for index in 0 ..< self.dataArr.count{
//            let cell = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(index)*JDCellHei + MytableviewTopHei, width: Width(aView: headerView), height: JDCellHei))
//            cell.backgroundColor = UIColor.white
//            cell.isUserInteractionEnabled = true
//            
//            let nameLable = UILabel.init()
//            nameLable.textAlignment = NSTextAlignment.left
//            nameLable.font = UIFont.systemFont(ofSize: NameLabelFont)
//            nameLable.backgroundColor = UIColor.white
//            nameLable.textColor = APPGRAYBLACKCOLOR
//            nameLable.text = self.dataArr[index] as? String
//            cell.addSubview(nameLable)
//            
//            let contentPlaceArr :NSArray = NSArray.init(array: [Local(str:"Enter the cloud ID"),Local(str:"Add a remark to the device"),Local(str:"Set an account for camera"),Local(str:"Set a password for camera")])
//            let contentLabel = UITextField.init()
//            contentLabel.textAlignment = NSTextAlignment.left
//            contentLabel.font = UIFont.systemFont(ofSize: NameLabelFont)
//            contentLabel.backgroundColor = UIColor.white
//            nameLable.textColor = UIColor.gray
//            if(index == 3){contentLabel.isSecureTextEntry = true}
//            contentLabel.borderStyle = UITextBorderStyle.none
//            contentLabel.placeholder = contentPlaceArr[index] as?  String
//            cell.addSubview(contentLabel)
//            contentLabel.tag = index
//            contentLabel.addTarget(self, action: #selector(avoidTheKeyboard), for: UIControlEvents.editingDidBegin)
//            self.contentArr.add(contentLabel)
//            
//            let showButton = UIButton.init(type: UIButtonType.custom)
//            showButton.setImage(imageArr[index] as? UIImage, for: UIControlState.normal)
//            showButton.backgroundColor = UIColor.white
//            showButton.tag = index
//            showButton.addTarget(self, action:#selector(clickAtcellImage), for:UIControlEvents.touchUpInside)
//            cell.addSubview(showButton)
//            
//            let lineViewSapce:CGFloat = 10.0
//            let SP = index < 3 ? lineViewSapce : 0
//            let lineView = UIView.init()
//            lineView.backgroundColor = APPLINECOLOR()
//            lineView.frame = CGRect.init(x: SP, y: Hight(aView: cell)-1, width: Width(aView: cell) - lineViewSapce, height: 1)
//            cell.addSubview(lineView)
//            
//            nameLable.translatesAutoresizingMaskIntoConstraints = false
//            contentLabel.translatesAutoresizingMaskIntoConstraints = false
//            showButton.translatesAutoresizingMaskIntoConstraints = false
//            
//            //namelabel 添加约束
//            cell.addConstraint(NSLayoutConstraint.init(item: nameLable, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 5))
//            cell.addConstraint(NSLayoutConstraint.init(item: nameLable, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: nameLable, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.width, multiplier: 0.25, constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: nameLable, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
//            
//            //contenLable 添加约束
//            cell.addConstraint(NSLayoutConstraint.init(item: contentLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: nameLable, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 5))
//            cell.addConstraint(NSLayoutConstraint.init(item: contentLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: contentLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: contentLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: showButton, attribute: NSLayoutAttribute.left, multiplier:1, constant: -5))
//
//            //showbutton 添加约束
//            cell.addConstraint(NSLayoutConstraint.init(item: showButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.height, multiplier: CGFloat(ImageToCellHeiScale), constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: showButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.height, multiplier: CGFloat(ImageToCellHeiScale), constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: showButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
//            cell.addConstraint(NSLayoutConstraint.init(item: showButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -5))
//            
//            headerView.addSubview(cell)
//        }
//        return headerView
//    }
//    
//    func creatTableFooterView() ->(UIView){
//        let footer = UIView.init()
//        footer.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20)
//        footer.backgroundColor = UIColor.clear
//        
//        let space:CGFloat = 10.0
//        let textLabel = UILabel.init(frame: CGRect.init(x:space , y: space, width: Width(aView: footer)  - 2.0*space, height: 0))
////        textLabel.text = Local(str:"Add the camera, you can set the camera account and password, if not set, the default is empty.") as String
//        textLabel.numberOfLines = 0
//        textLabel.textColor = APPGRAYBLACKCOLOR
//        textLabel.font = UIFont.systemFont(ofSize: 13)
//        textLabel.textAlignment = NSTextAlignment.left
//        footer.addSubview(textLabel)
//        textLabel.sizeToFit()
//        footer.isUserInteractionEnabled = false
//        return footer;
//    }
//    func avoidTheKeyboard(text:UITextField){
//        if text.tag-1 > 0{
//            self.myTableview.setContentOffset(CGPoint.init(x: 0, y: JDCellHei*CGFloat(text.tag-1)), animated: true)
//        }else{
//            self.myTableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
//        }
//    }
//
//    func clickAtcellImage(button:UIButton){
//        switch button.tag {
//        case 0:
//            // 扫描添加 云ID
//            
//            let QRVC = QRcodeSupportVC.init(block: { (aObject:AVMetadataMachineReadableCodeObject?) in
//                NSLog((aObject?.stringValue)!)
//                let textF = self.contentArr[button.tag] as! UITextField
//                textF.text = aObject?.stringValue
//            })
//            self.navigationController?.pushViewController(QRVC!, animated: true)
//            break
//        case 1:
//            // 清除内容
//            
//            break
//        case 2:
//            // 清除内容
//            
//            break
//        case 3:
//            //密码是否明文
//            let textF = self.contentArr[button.tag] as! UITextField
//            textF.isSecureTextEntry = !textF.isSecureTextEntry
//            if(textF.isSecureTextEntry){
//                button.setImage(imageWithName(name: "eyes_close"), for: UIControlState.normal)
//            }else{
//                button.setImage(imageWithName(name: "eyes_open"), for: UIControlState.normal)
//            }
//            break
//        default:
//            break
//        }
//    }
//    
//    func saveID(button:UIButton){
//        
//        let IdText = self.contentArr[0] as?UITextField
//        let remarkText = self.contentArr[1] as?UITextField
////        let pswText = self.contentArr[3] as?UITextField
////        let nameText = self.contentArr[2] as?UITextField
//        if IdText?.text?.characters.count == 0{
//            SVProgressHUD.showInfo(withStatus: Local(str: "Cloud ID can not be empty") as String!)
//            return
//        }
//        
//        let camerArr = (UserDefaults.standard.value(forKey: CamerAdrr) as? NSArray)
//        if camerArr != nil{
//            let count:Int = camerArr!.count
//            if count>0 {
//                for i:Int in 0 ..< count{
//                    let dic:NSDictionary = camerArr![i] as! NSDictionary
//                    if ((dic.value(forKey: "cloudID")as! NSString).isEqual(to: (IdText?.text)!)){
//                        SVProgressHUD.showInfo(withStatus: Local(str:"The device already exists"))
//                        return
//                    }
//                }
//            }
//        }
//
//        SVProgressHUD.show(withStatus:"")
//        let videoView:EseeNetLive = EseeNetLive.init(eseeNetLiveVideoWithFrame: CGRect.init())
//        videoView.setDeviceInfoWithDeviceID(IdText?.text, passwords: "", userName: "admin", channel: 0 , port: 0)
//        videoView.connect(withPlay: false, bitRate: SD, completion: { ( NetState:EseeNetState) in
//            print(NetState)
//            let camerDevice :JDCameraDevice = JDCameraDevice.init()
//            if NetState == EseeNetStateConnectSuccess || NetState == EseeNetStateLoginSuccess{
//                camerDevice.camerName = "admin"
//                camerDevice.camerPassword = ""
//                camerDevice.remark = remarkText?.text as NSString?
//                if (remarkText?.text?.characters.count)! == 0 {
//                    camerDevice.remark = Local(str: "Surveillance cameras") as NSString
//                }
//                camerDevice.cloudID = IdText?.text as NSString?
//                camerDevice.camerNetIsonline = true
////                if(videoView.currentImage)
////                camerDevice.currentImage = UIImagePNGRepresentation(videoView.currentImage) as NSData?
//                
//                //保存起来 页面返回
//                camerDevice.saveCamer()
//                SVProgressHUD.showSuccess(withStatus: Local(str: "accomplish") as String!)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: GetACamer), object: nil)
//            }else {
//         
//                SVProgressHUD.showError(withStatus:Local(str: "The connection failed. Please check the correctness of the cloud ID and make sure the device is connected to the network.") as String!)
//                camerDevice.camerNetIsonline = false
//
//            }
//        })
//    }
//    func goback()  {
//        self.navigationController!.popViewController(animated: true)
//    }
//
//}
//
////MARK -@protocol UITableViewDelegate
//extension AddCameraPage: UITableViewDelegate{
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//}
//
////MARK -@protocol UITableViewDataSource
//extension AddCameraPage: UITableViewDataSource{
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//}
//
//
//
//
