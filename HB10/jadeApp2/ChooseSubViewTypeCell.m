//
//  ChooseSubViewType.m
//  jadeApp2
//
//  Created by JD on 2017/3/6.
//  Copyright © 2017年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "ChooseSubViewTypeCell.h"
#import "JDAppGlobelTool.h"

@implementation ChooseSubViewTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(ZoneType)type{
    
    switch (type) {
        case MotionSensorType:{
            self.icon.image = RepalceImage(@"Device_getaway_hongwai");
            self.script.text = Local(@"Human body sensing");
        }break;
        case MagnetometerType:{
            self.icon.image = RepalceImage(@"Device_getaway_menci");
            self.script.text = Local(@"Magnetometer");
        }break;
        case FireSensorType:{
            self.icon.image = RepalceImage(@"Devcie_gateway_yangan");
            self.script.text = Local(@"Fire alarm sensor");
        }break;
        case WaterSensorType:{
            self.icon.image = RepalceImage(@"Device_getaway_water");
            self.script.text = Local(@"Marine Sensor");
        }break;
        case GasSensorType:{
            self.icon.image = RepalceImage(@"Devcie_gateway_qigan");
            self.script.text = Local(@"Gas sensing");
        }break;
        case RemoterContorlType:{
            self.icon.image = RepalceImage(@"Device_getaway_remot");
            self.script.text = Local(@"Remote control");
        }break;
        case DoorRingType:{
            self.icon.image = RepalceImage(@"Device_getaway_Doorbell");
            self.script.text = Local(@"Doorbell");
        }break;
        case CameraType:{
            self.icon.image = RepalceImage(@"Devcie_Camer_onlin");
            self.script.text = Local(@"Camera");
        }break;
        case PGMType:{
            self.icon.image = RepalceImage(@"Device_getaway_PGM");
            self.script.text = Local(@"PGM");
        }break;
        case AlarmType:{
            self.icon.image = RepalceImage(@"Device_getaway_Siren");
            self.script.text = Local(@"Siren");
        }break;
        case SoSType:{
            self.icon.image = RepalceImage(@"Device_getaway_SoS");
            self.script.text = Local(@"SoS");
        }break;
        case UndownType:{
            self.icon.image = RepalceImage(@"Device_getaway_online");
            self.script.text = Local(@"Add slave device");
        }break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
