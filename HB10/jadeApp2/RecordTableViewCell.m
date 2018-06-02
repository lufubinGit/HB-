//
//  RecordTableViewCell.m
//  jadeApp2
//
//  Created by JD on 16/9/19.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "JDDeviceHistoryRecord.h"
#import "DeviceInfoModel.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecord:(JDDeviceHistoryRecord *)record{
   
    _record = record;
    int count = (int)record.content.count;
    self.event.text = @"";
    if(count == 1){
        self.event.text = record.content.firstObject;
    }else if(count == 2){
        
        self.event.font = [UIFont systemFontOfSize:14];
        self.event.numberOfLines = 2;
        self.event.text = [NSString stringWithFormat:@"%@\n%@",record.content.firstObject,record.content[1]];
    }else if(count == 3){
        
        self.event.font = [UIFont systemFontOfSize:13];
        self.event.numberOfLines = 3;
        self.event.text = [NSString stringWithFormat:@"%@\n%@\n%@",record.content.firstObject,record.content[1],record.content[2]];
    }else if (count == 0){
    
    }else{
        self.event.font = [UIFont systemFontOfSize:13];
        self.event.numberOfLines = 3;
        self.event.text = [NSString stringWithFormat:@"%@\n%@\n%@",record.content.firstObject,record.content[1],record.content[2]];
    }
    
    self.time.text = [record.recordDate substringToIndex:19];
    self.name.text = record.devceiName;
    self.iconImage.image = record.subDeviceIcon;
}

@end
