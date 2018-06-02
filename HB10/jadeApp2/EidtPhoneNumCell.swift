//
//  EidtPhoneNumCell.swift
//  jadeApp2
//
//  Created by JD on 2017/2/9.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

import UIKit

class EidtPhoneNumCell: UITableViewCell {
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var msnButton: UIButton!
    
    var clickedCallButtonAction:((Bool)->(Void))?
    var clickedMsnButtonAction:((Bool)->(Void))?
    

    public func clickCallButton() {
        
        self.callButton.isSelected = !self.callButton.isSelected
        clickedCallButtonAction!(self.callButton.isSelected)
    }
    public func clickMsnButton() {
        
        self.msnButton.isSelected = !self.msnButton.isSelected
        clickedMsnButtonAction!(self.msnButton.isSelected)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        callButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0.2*SCREEN_WIDTH/3.0, 0, -0.2*SCREEN_WIDTH/3.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(phone:PhoneNum) {
        phoneNum.text = phone.PhoneNum
        callButton.isSelected = phone.type2
        msnButton.isSelected = phone.type1
        callButton.addTarget(self, action: #selector(clickCallButton), for: UIControlEvents.touchUpInside)
        msnButton.addTarget(self, action: #selector(clickMsnButton), for: UIControlEvents.touchUpInside)
    }
}
