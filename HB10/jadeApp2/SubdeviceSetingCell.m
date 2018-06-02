//
//  SubdeviceSetingCell.m
//  jadeApp2
//
//  Created by JD on 2016/12/15.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SubdeviceSetingCell.h"

@implementation SubdeviceSetingCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)switchChanged:(id)sender {
    if(self.cBLock){
        self.cBLock(self.cellSwitch.on);
    }
}

@end
