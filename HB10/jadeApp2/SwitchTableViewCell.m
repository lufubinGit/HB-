//
//  SwitchTableViewCell.m
//  jadeApp2
//
//  Created by JD on 2016/10/23.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SwitchTableViewCell.h"
#import "DataPointModel.h"

@implementation SwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setON:(id)sender {
    if(self.callBlock){
        self.callBlock(self.Aswitch.on);
    }
}

- (void)setModel:(DataPointModel *)model{
    self.name.text = model.dataPointName;
    self.Aswitch.on = [model.dataPointValue boolValue];
    if(![self.name.text isEqualToString:@"srnOn"]){
        self.Aswitch.enabled = NO;
    }
}



- (void)setCell:(NSDictionary *)dic{

    
}


@end
