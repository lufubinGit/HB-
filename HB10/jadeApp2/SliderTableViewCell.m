//
//  SliderTableViewCell.m
//  jadeApp2
//
//  Created by JD on 2016/10/23.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "SliderTableViewCell.h"
#import "DataPointModel.h"
@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Aslider:(id)sender {
    
    if(self.callBlock){
    
        self.callBlock(self.Aslider.value);
    }
    self.count.text = [NSString stringWithFormat:@"%.0d",(int)self.Aslider.value];
}

- (void)setModel:(DataPointModel *)model{

    self.name.text = model.dataPointName;
    self.Aslider.value = [model.dataPointValue integerValue];
    self.count.text = [NSString stringWithFormat:@"%d",(int)self.Aslider.value];
}


- (void)setCell:(NSDictionary *)dic{


    
}

@end
