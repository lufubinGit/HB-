//
//  EquipmentTableViewCell.m
//  jadeApp2
//
//  Created by 卢赋斌 on 16/9/13.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "EquipmentTableViewCell.h"
#import "DeviceInfoModel.h"
#import "DataPointModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "JDAppGlobelTool.h"
@implementation EquipmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(DataPointModel *)model{
    _model = model;
    
    self.imageView.image = nil;
    self.deviceBrief.text = model.dataPointName;
    
    if(model.dataPointName){
        self.isOline.textColor = APPSAFEGREENCOLOR;
        self.isOline.text = @"Online";
    }else{
        self.isOline.textColor = APPMAINCOLOR;
        self.isOline.text = @"Offline";
    }
    if([model.dataPointName isEqualToString:@"setTimeSrnOn"]){
        self.isOline.text = @"Alarm duration";
        if(model.dataPointValue){
        
            self.deviceState.text = [NSString stringWithFormat:@"%@",model.dataPointValue];
        }else{
            self.deviceState.text = @"no signal";
        }
    }else if ([model.dataPointName isEqualToString:@"srnOn"]){
       
//        self.isOline.text = @"In alarm";
        if([model.dataPointValue boolValue]){
        
            self.deviceState.text = @"Yes";
        }else{
            self.deviceState.text = @"No";

        }
        
    }else if ([model.dataPointName isEqualToString:@"armState"]){
        
        self.isOline.text = @"currentState";
        if([model.dataPointValue intValue] == 0){
            
            self.deviceState.text = @"disarm";
        }else if([model.dataPointValue intValue] == 1){
            self.deviceState.text = @"armstay";
            
        }else if([model.dataPointValue intValue] == 2){
            self.deviceState.text = @"armaway";

        }

        
    }else if ([model.dataPointName isEqualToString:@"doorOpen"]){
        
        if([model.dataPointValue boolValue]){
            self.deviceState.text = @"open";
        }else{
            self.deviceState.text = @"close";
        }
        
    self.deviceImage.image = [UIImage imageNamed:@"5"];
        
    }else if ([model.dataPointName isEqualToString:@"pirGetMan"]){
        if([model.dataPointValue boolValue]){
            self.deviceState.text = @"Someone in";
        }else{
            self.deviceState.text = @"No body";
        }
        self.deviceImage.image = [UIImage imageNamed:@"2"];
    }else if ([model.dataPointName isEqualToString:@"isAlmg"]){
        if([model.dataPointValue boolValue]){
            self.deviceState.text = @"Yes";
        }else{
            self.deviceState.text = @"No";
        }
    }
    
    self.deviceImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",arc4random()%6+1]];
    
    

//    
//    if(model.dataPointName){
//        self.isOline.textColor = APPSAFEGREENCOLOR;
//        self.isOline.text = @"Online";
//    }else{
//        self.isOline.textColor = APPMAINCOLOR;
//        self.isOline.text = @"Offline";
//    }
//    
//    if(model.dataPointValue){
//    
//        self.deviceState.text = [NSString stringWithFormat:@"%@",model.dataPointValue];
//    }else{
//        self.deviceState.text = @"no signal";
//    }
//    
//    self.deviceImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",arc4random()%6+1]];
}

- (IBAction)switch:(id)sender {
    
    
}


@end
