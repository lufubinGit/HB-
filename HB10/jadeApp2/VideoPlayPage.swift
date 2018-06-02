////
////  VideoPlayPage.swift
////  jadeApp2
////
////  Created by JD on 2017/1/9.
////  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
////
//
//import Foundation
//
//fileprivate let allCount = 4
//fileprivate let space:CGFloat = 10.0
//
//public class RealtimePlayPage: BaseViewController{
// 
//    var showButton:CamerDeviceShowButton! = nil
//    var CamerDevice : JDCameraDevice? = nil
//    var camerArr : NSMutableArray? = nil
//    var currentEsee : JDCameraDevice! = nil
//    var headCenter : CGPoint? = nil
//    var buttonArr : NSMutableArray? = nil
//    
//    
//    lazy var mytableView :UITableView = {
//        let mytableView : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HIGHT), style: UITableViewStyle.plain)
//        mytableView.tableHeaderView = self.addEseeView()
//        mytableView.tableFooterView = self.addControlView(tableView: mytableView)
//        return mytableView
//    }()
//    
//    lazy var eseeArr :NSMutableArray = {
//        var eseeArr = NSMutableArray.init()
//        return eseeArr
//    }()
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        self.currentEsee = JDCameraDevice.init()
//        self.initUI()
//    }
//    
//    override public func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        SVProgressHUD.setBackgroundColor(UIColor.init(white: 1.0, alpha: 0.9))
//        SVProgressHUD.setForegroundColor(UIColor.black)
//        self.title = self.CamerDevice?.remark as String?
//    }
//    
//    override public func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        SVProgressHUD.setBackgroundColor(UIColor.init(white: 0, alpha: 0.7))
//        SVProgressHUD.setForegroundColor(UIColor.white)
//    }
//    
//    func initUI(){
//        self.view.backgroundColor = APPBACKGROUNDCOLOR
//        let rightNavButton = UIButton.init(type: UIButtonType.custom)
//        rightNavButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
//        let image:UIImage = imageWithName(name: "public_more")
//        rightNavButton.setImage(image.withColor(UIColor.white), for: UIControlState.normal)
//        rightNavButton.setImage(image.withColor(UIColor.init(white: 1.0, alpha: 0.3)), for: UIControlState.highlighted)
//        rightNavButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavButton)
//        self.view.addSubview(self.mytableView)
//    }
//    
//    //设置按钮被点击 - 右上角
//    func rightButtonClick(){
//        let suspens = SuspensionView.init()
//        let  setAction  = SuspensionAction.init(iamge: imageWithName(name: "public_setting"), title: Local(str: "Modify remarks")) { (action) in
//            //进入设置界面
//            let page = ModifyCamerInfo.init()
//            page.camerDevcie = self.CamerDevice
//            self.navigationController?.pushViewController(page, animated: true)
//        }
//        let  deleteAction  = SuspensionAction.init(iamge: imageWithName(name: "gateway_delete"), title: Local(str: "delete device")) { (action) in
//            self.navigationController!.popViewController(animated: true)
//            self.showButton.deleteCamer()
//
//        }
//        suspens.addSuspension(with:setAction)
//        suspens.addSuspension(with:deleteAction)
//        suspens.show(with: SuspensionViewType.viewleftTopType)
//    }
//    
//    
//    // 添加视频
//    func addEseeView() -> UIView{
//        
//        let tipsHei :CGFloat = 30
//        let heiOrWidth:CGFloat = SCREEN_WIDTH/2.0 - 1.5*space
//        let heardView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH+tipsHei))
//
//        camerArr = NSMutableArray.init()
//        let BgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HIGHT))
//        BgView.backgroundColor = UIColor.clear
//        BgView.isUserInteractionEnabled = true
//        heardView.addSubview(BgView)
//        self.headCenter = BgView.center
//        //添加视频
//        for i in 0..<allCount {
//            let videoView:EseeNetLive = EseeNetLive(eseeNetLiveVideoWithFrame:(CGRect(
//                x:space*CGFloat(i%2+1) + CGFloat(i%2) * heiOrWidth,
//                y: space*CGFloat(i/2+1) + CGFloat(i/2) * heiOrWidth,
//                width: heiOrWidth,
//                height: heiOrWidth)))
//             let camer = JDCameraDevice.init()
//            camer.esee = videoView
//            camerArr!.add(camer)
//            videoView.setDeviceInfoWithDeviceID(CamerDevice?.cloudID as String!, passwords: CamerDevice?.camerPassword as String!, userName: CamerDevice?.camerName as String!, channel: Int32(i), port: 0)
//            videoView.connect(withPlay: true, bitRate: SD, completion: { ( NetState:EseeNetState) in
//                if NetState == EseeNetStateDisconnect{
//                    NSLog("断开了")
//                }else if NetState == EseeNetStateLogining{
//                    
//                    NSLog("登陆中")
//                }
//            })
//            videoView.tag = i+1000
//            videoView.allowScale = true
//            BgView.addSubview(videoView)
//            //添加手势
//            videoView.isUserInteractionEnabled = true
//            let singleTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectorVideo))
//            singleTap.numberOfTapsRequired = 1
//            
//            let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(scaleVideo))
//            doubleTap.numberOfTapsRequired = 2
//            singleTap.require(toFail: doubleTap)
//            videoView.addGestureRecognizer(singleTap)
//            videoView.addGestureRecognizer(doubleTap)
//        }
//        
//        //添加提示文字
//        let tips = UILabel.init(frame: CGRect.init(x: space, y:SCREEN_WIDTH , width: SCREEN_WIDTH - 2*space, height: 0))
//        tips.text = Local(str: "Click to select or double-click to enlarge a video for control.")
//        tips.textAlignment = NSTextAlignment.left
//        tips.numberOfLines = 0
//        tips.font = UIFont.systemFont(ofSize: 12)
//        tips.textColor = APPGRAYBLACKCOLOR
//        tips.sizeToFit()
//        heardView.addSubview(tips)
//        //添加横线
//        let linview = UIView.init(frame: CGRect.init(x: -space, y: tipsHei-1, width: SCREEN_WIDTH, height: 1))
//        linview.backgroundColor = APPLINECOLOR()
//        tips.addSubview(linview)
//        return heardView
//    }
//    
//    //添加控制台
//    func addControlView(tableView:UITableView) -> UIView {
//        let controlCount: Int  = 4
//        let buttonHei = SCREEN_HIGHT/12.0
//        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: buttonHei))
//        footerView.backgroundColor = UIColor.white
//        self.buttonArr = NSMutableArray.init()
//
//        for i in 0..<controlCount {
//            let controlButton = UIButton.init(type: UIButtonType.custom)
//            controlButton.frame = CGRect.init(x: CGFloat(i)*SCREEN_WIDTH*0.25, y: 0, width: SCREEN_WIDTH*0.25, height: Hight(aView: footerView))
//            let imageArr: NSArray = ["videoplay_jietu_normal","videoplay_luxiang_normal","videoplay_slient","videoplay_SD"]
//            controlButton.setImage(imageWithName(name: imageArr[i] as! NSString), for: UIControlState.normal)
//            switch i {
//            case 0:
//                
//                controlButton.setImage(imageWithName(name: "videoplay_jietu_HL"), for: UIControlState.highlighted)
//                break
//            case 1:
//                controlButton.setImage(imageWithName(name: "videoplay_luxiang_HL"), for: UIControlState.highlighted)
//                controlButton.setImage(imageWithName(name: "videoplay_luxiang_selector"), for: UIControlState.selected)
//
//                break
//            case 2:
//                controlButton.setImage(imageWithName(name: "videoplay_voice"), for: UIControlState.selected)
//                break
//            case 3:
//                controlButton.setImage(imageWithName(name: "videoplay_HD"), for: UIControlState.selected)
//                break
//            default: break
//            }
//            controlButton.tag = i+100
//            controlButton.addTarget(self, action: #selector(clickControlButton), for: UIControlEvents.touchUpInside)
//            self.buttonArr?.add(controlButton)
//            footerView.addSubview(controlButton)
//            
//            let titleArr: NSArray = [Local(str:"Screenshots"),Local(str:"Record"),Local(str:"Voice"),Local(str:"Bitrate")]
//            let titleHei:CGFloat = 20
//            
//            let title = UILabel.init(frame: CGRect.init(x: CGFloat(i)*SCREEN_WIDTH*0.25, y: buttonHei, width: SCREEN_WIDTH*0.25, height: titleHei))
//            title.text = titleArr[i] as? String
//            title.font = UIFont.systemFont(ofSize: 12)
//            title.textAlignment = NSTextAlignment.center
//            title.textColor = APPGRAYBLACKCOLOR
//            title.backgroundColor = UIColor.white
//            footerView.addSubview(title)
//            
//            let linView = UIView.init(frame:CGRect.init(x: SCREEN_WIDTH/4.0 * CGFloat(i), y: space, width: 1, height: buttonHei - space + titleHei ))
//            linView.backgroundColor = APPLINECOLOR()
//            footerView.addSubview(linView)
//            
//        }
//        return footerView
//    }
//    
//    func clickControlButton(button:UIButton) {
//        
//        if self.currentEsee?.esee == nil{
//            SVProgressHUD .showInfo(withStatus: Local(str: "You need to select a video to operate."))
//            return
//        }
//        if ((self.currentEsee?.esee?.connectState) != nil) {
//        }
//        switch button.tag - 100 {
//        case 0:
//            //截图
//            self.currentEsee?.esee.captureImage("JADE Gateway pictures", completion: { (result:Int32) in
//                switch result {
//                case 0:
//                    SVProgressHUD .showSuccess(withStatus: Local(str: "accomplish"))
//                    break
//                case 1:
//                    SVProgressHUD .showInfo(withStatus: Local(str: "This camera has no picture."))
//
//                    break
//                case 2:
//                    SVProgressHUD .showInfo(withStatus: Local(str: "No album access."))
//
//                    break
//                case 3:
//                    SVProgressHUD .showInfo(withStatus: Local(str: "The album name is not set."))
//
//                    break
//                default:
//                    SVProgressHUD .showError(withStatus: Local(str: "Failed"))
//
//                    break
//                }
//            })
//            break
//        case 1:
//            //开始录制
//            button.isSelected = !button.isSelected
//            if button.isSelected == true{
//                self.currentEsee?.esee.beginRecord()
//                self.currentEsee?.recording = true
//            }else{
//                self.currentEsee?.recording = false
//                self.currentEsee?.esee.endRecordAndSave("JADE Gateway Videos", completion: { (result:Int32) in
//                    switch result {
//                    case 0:
//                        SVProgressHUD .showSuccess(withStatus: Local(str: "accomplish"))
//                        break
//                    case 1:
//                        SVProgressHUD .showInfo(withStatus: Local(str: "This camera has no video."))
//                        break
//                    case 2:
//                        SVProgressHUD .showInfo(withStatus: Local(str: "No album access."))
//                        break
//                    case 3:
//                        SVProgressHUD .showInfo(withStatus: Local(str: "The album name is not set."))
//                        break
//                    default:
//                        SVProgressHUD .showError(withStatus: Local(str: "Failed"))
//                        break
//                    }
//            })
//            }
//            
//            
//            break
//        case 2:
//            //开启声音
//            button.isSelected = !button.isSelected
//            if button.isSelected == true{
//                self.currentEsee?.esee.audioOpen()
//                self.currentEsee?.voice = true
//            }else{
//                self.currentEsee?.esee.audioClose()
//                self.currentEsee?.voice = false
//
//            }
//            
//            break
//        case 3:
//            //是否使用高清
//            button.isSelected = !button.isSelected
//            if button.isSelected == true{
//                self.currentEsee?.esee.changeBitrate(HD)
//            }else{
//                self.currentEsee?.esee.changeBitrate(SD)
//            }
//            
//            
//            break
//        default:
//            break
//        }
//
//    }
//   
//    func selectorVideo(tap:UITapGestureRecognizer) {
//        let eseeView:JDCameraDevice =  self.camerArr![(tap.view?.tag)!-1000] as! JDCameraDevice
//        
//        if self.currentEsee.esee != nil{
//            self.currentEsee?.esee.videoSelect = false
//        }
//        eseeView.esee.videoSelect = true
//        self.currentEsee = eseeView
//        for i in 0..<Int32((self.buttonArr?.count)!){
//            let but:UIButton =  self.buttonArr![Int(i)] as! UIButton
//            switch i {
//            case 0:
//                
//                break
//            case 1:
//                but.isSelected = self.currentEsee.recording
//                break
//            case 2:
//                
//                but.isSelected = self.currentEsee.voice
//                break
//            case 3:
//                if self.currentEsee?.esee.bitRate == HD{
//                    but.isSelected = true
//                }else{
//                    but.isSelected = false
//                }
//                break
//            default:
//                break
//            }
//            
//        }
//        
//    }
//    
//    func scaleVideo(double:UITapGestureRecognizer) {
//        
//        let eseeView:JDCameraDevice =  self.camerArr![(double.view?.tag)!-1000] as! JDCameraDevice
//        if self.currentEsee?.esee != nil{
//            self.currentEsee?.esee.videoSelect = false
//        }
//        eseeView.esee.videoSelect = true
//        self.currentEsee = eseeView
//            eseeView.esee.superview?.bringSubview(toFront: eseeView.esee)
//            UIView.animate(withDuration: 0.3) {
//                let heiOrWidth:CGFloat = SCREEN_WIDTH/2.0 - 1.5*space
//                if CenterX(aView: eseeView.esee) != SCREEN_WIDTH*0.5{
//                    let scale :CGFloat = CGFloat(SCREEN_WIDTH*0.5+5)/CGFloat(SCREEN_WIDTH*0.25)
//                    eseeView.esee.transform = CGAffineTransform(scaleX: scale, y: scale)
//                    eseeView.esee.center = CGPoint.init(x:CenterX(aView: self.view), y: 1.5*space + heiOrWidth)
//                }else{
//                    
//                    eseeView.esee.transform = CGAffineTransform.identity
//                    let tag = eseeView.esee.tag-1000
//                    let y:CGFloat = space*CGFloat(Int(tag)/Int(2)+1) + (CGFloat(Int(tag)/Int(2))+0.5) * heiOrWidth
//                    let x:CGFloat = space*CGFloat(Int(tag)%2+1) + CGFloat(CGFloat(Int(tag)%2)+0.5) * heiOrWidth
//                    eseeView.esee.center = CGPoint.init(x:x, y: y)
//                }
//            }
//    }
//    func endPlay(){
//        for camer:JDCameraDevice in (self.camerArr as? [JDCameraDevice])!{
//            camer.esee.stop()
//        }
//    }
//    deinit {
//        self.endPlay()
//    }
//
//    
//}
//
//// MARK - modyfy setting
//
//fileprivate let cellHei:CGFloat = 50
//
//class ModifyCamerInfo : BaseViewController{
//    
//    var camerDevcie:JDCameraDevice!
//    var textF : UITextField!
//    
//    
//    lazy var mytableView :UITableView = {
//        let mytableView : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HIGHT), style: UITableViewStyle.plain)
//        mytableView.backgroundColor = UIColor.clear
//        mytableView.tableHeaderView = self.creatTableHeadView()
//        mytableView.tableFooterView = UIView.init()
//        return mytableView
//    }()
//    
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        self.initUI()
//    }
//    
//    func initUI(){
//        self.view.backgroundColor = APPBACKGROUNDCOLOR
//        self.view.addSubview(self.mytableView)
//        self.dismissKeyBEnable = true
//        self.view.isUserInteractionEnabled = true
//        let button:UIButton = UIButton.init(type: UIButtonType.custom)
//        button.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
//        button.setTitle(Local(str: "Save"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(save), for: UIControlEvents.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
//    }
//
//    func creatTableHeadView() -> UIView{
//        let headView = UIView.init(frame: CGRect.init(x: 0, y: space, width: SCREEN_WIDTH, height: cellHei))
//        headView.backgroundColor = UIColor.white
//        let nameArr:NSArray = [self.camerDevcie.remark ?? "",self.camerDevcie.camerName ?? "",self.camerDevcie.camerPassword ?? ""]
//        let placeholdArr:NSArray = [Local(str: "Remark"),Local(str: "Device Accout"),Local(str: "Device Password")]
//        for i in 0..<1 {
//            self.textF = UITextField.init(frame: CGRect.init(x: space, y: 0 + CGFloat(i)*cellHei , width: SCREEN_WIDTH, height: cellHei))
//            textF.textColor = APPGRAYBLACKCOLOR
//            textF.font = UIFont.systemFont(ofSize: 15)
//            textF.backgroundColor = UIColor.white
//            textF.text = nameArr[i] as? String
//            textF.placeholder = placeholdArr[i] as? String
//            headView.addSubview(textF)
//        }
//        return headView
//    }
//    
//    func save(){
//        if (textF.text?.characters.count)! > 0{
//            self.camerDevcie.remark = textF.text as NSString?
//            self.camerDevcie.saveCamer()
//            SVProgressHUD.showSuccess(withStatus: Local(str: "accomplish"))
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: GetACamer), object: nil)
//            
//        }else{
//            SVProgressHUD.showInfo(withStatus: Local(str: "Can not save because the content is empty"))
//        }
//    }
//
//}
//
//
//
//
//
//
//
