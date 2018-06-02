//
//  FeedBackViewController.m
//  jadeApp2
//
//  Created by JD on 2016/12/12.
//  Copyright © 2016年 JaDe Coupling sensor Technology Co., Ltd. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIView+Frame.h"
#import <MessageUI/MessageUI.h>
#import <Photos/Photos.h>
#import "SKPSMTPMessage.h"
#import "NSStream+SKPSMTPExtensions.h"
#import "NSData+Base64Additions.h"
#import "JDAppGlobelTool.h"


@interface FeedBackViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,SKPSMTPMessageDelegate>
@property (weak, nonatomic) IBOutlet UILabel *feedTitle;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (weak, nonatomic) IBOutlet UIImageView *fourImage;
@property (weak, nonatomic) IBOutlet UIImageView *threeimage;
@property (weak, nonatomic) IBOutlet UIImageView *TwoImage;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic,strong) NSMutableArray *imageVArr;
@property (nonatomic,strong) NSMutableArray *imageArr;

@end

@implementation FeedBackViewController
{

    int _timeCount;
    NSTimer *_timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self refrshimage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - initUI 
- (void)initUI{

    self.title = Local(@"Edit the feedback");
    self.feedTitle.text = Local(@"Enter the feedback in the text box");
    [self dismissKeyBEnable];
    [self.contentView setLayerWidth:0 color:nil cornerRadius:PublicCornerRadius BGColor:nil];
    self.tiplabel.text = Local(@"Click the \"+\" to add the image");
    [self.sendButton setLayerWidth:0 color:nil cornerRadius:22 BGColor:nil];
    self.sendButton.backgroundColor = APPMAINCOLOR;
    [self.sendButton setTitle:Local(@"OK") forState:UIControlStateNormal];
    self.imageVArr = [NSMutableArray arrayWithArray:@[_oneImage,_TwoImage,_threeimage,_fourImage]];
    _oneImage.tag = 1;
    _TwoImage.tag = 2;
    _threeimage.tag = 3;
    _fourImage.tag = 4;
    for (UIImageView *imagV in self.imageVArr) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addimage:)];
        imagV.userInteractionEnabled = YES;
        [imagV addGestureRecognizer:tap];
    }
    UIPanGestureRecognizer *Swip = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeyB)];
    [self.contentView addGestureRecognizer:Swip];
    
}

-(void)refrshimage{
    switch (self.imageArr.count) {
        case 0:
        {
            for (UIImageView *imageV in self.imageVArr) {
                if(imageV.tag == 1){
                    imageV.hidden = NO;
                    imageV.image = [UIImage imageNamed:@"FeedbackPlacehold"];
                }else{
                    imageV.hidden = YES;
                }
            }
        }
            break;
        case 1:
        {
            for (UIImageView *imageV in self.imageVArr) {
                if(imageV.tag == 2){
                    imageV.hidden = NO;
                    imageV.image = [UIImage imageNamed:@"FeedbackPlacehold"];
                }else if(imageV.tag == 1){
                    imageV.hidden = NO;
                    imageV.image = self.imageArr[imageV.tag-1];
                }else{
                    imageV.hidden = YES;
                }
            }
        }
            break;
        case 2:
        {
            for (UIImageView *imageV in self.imageVArr) {
                if(imageV.tag <= 3){
                    imageV.hidden = NO;
                    if(imageV.tag == 3){
                        imageV.image = [UIImage imageNamed:@"FeedbackPlacehold"];
                    }else{
                        imageV.image = self.imageArr[imageV.tag-1];
                    }
                }else{
                    imageV.hidden = YES;
                }
            }
        }
            break;
        case 3:
        {
            for (UIImageView *imageV in self.imageVArr) {
                imageV.hidden = NO;
                if(imageV.tag == 4){
                    imageV.image = [UIImage imageNamed:@"FeedbackPlacehold"];
                }else{
                    imageV.image = self.imageArr[imageV.tag-1];
                }
            }
        }
            break;
        case 4:
        {
            for (UIImageView *imageV in self.imageVArr) {
                imageV.hidden = NO;
                imageV.image = self.imageArr[imageV.tag-1];
            }
        }
            break;
        default:
            break;
    }
    
}

//弹窗 需要用户输入邮箱账号和邮箱密码
- (void)addUserInfo{

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:Local(@"Tips") message:Local(@"We need to use your mail to send information, we promise not to leak your mailbox information and to send the information encrypted. If you are using the QQ mailbox, please get your mailbox authorization code as a password to fill in the following password box.") preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = Local(@"Your E-mail");
        
    }];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = Local(@"You E-mail password");
    }];

    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
        UITextField *accout = alertVc.textFields.firstObject;
        UITextField *psw = alertVc.textFields.lastObject;
        [mutDic setObject:accout.text forKey:@"email"];
        [mutDic setObject:psw.text forKey:@"psw"];
        [mutDic setObject:[self getEmailSmtpWithEmail:accout.text] forKey:@"emailSmtp"];
        if(!accout.text.length||!psw.text.length){
            [SVProgressHUD showInfoWithStatus:Local(@"E-mail or password error")];
        }else{
            [self sendEmailActionWithInfo:mutDic];
            self.contentView.text = nil;
            [self.imageArr removeAllObjects];
            [self refrshimage];
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Cancle") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];

    }]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (NSString *)getEmailSmtpWithEmail:(NSString *)email{
    
    
    if([email containsString:@"@qq.com"]){
     return @"smtp.qq.com";
    }
    if([email containsString:@"@hotmail.com"]){
       return @"smtp.live.com";
    }
    if([email containsString:@"@outlook.com"]){
       return @"smtp-mail.outlook.com";
    }
    if([email containsString:@"@gmail.com"]){
        return  @"smtp.gmail.com";
    }
    if([email containsString:@"@foxmail.com"]){
        return  @"smtp.foxmail.com";
    }
    if([email containsString:@"@139.com"]){
        return  @"SMTP.139.com";
    }
    if([email containsString:@"@sina.com"]){
        return  @"smtp.sina.com";
    }
    if([email containsString:@"@yahoo"]){
        return  @"smtp.mail.yahoo.com";
    }else{
    
        return [NSString stringWithFormat:@"smtp.%@",[email componentsSeparatedByString:@"@"].lastObject];
    }
}

- (void)count:(NSTimer *)timer{
    _timer = timer;
    _timeCount ++;
    if(_timeCount == 30){
    
        [self messageFailed:nil error:nil];
        [_timer invalidate];
    }else if (_timeCount == 2){
        self.navigationController.view.userInteractionEnabled = YES;
          [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
          [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)sendEmailActionWithInfo:(NSDictionary *)info
{
    _timeCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    [SVProgressHUD showWithStatus:Local(@"Loading")];
    self.navigationController.view.userInteractionEnabled = NO;
    SKPSMTPMessage * mm=[[SKPSMTPMessage alloc] init];
    [mm setSubject:@"来自产品使用者的反馈"];
    [mm setToEmail:OfficialEmail];
    [mm setFromEmail:info[@"email"]];
    [mm setRelayHost:info[@"emailSmtp"]];
    [mm setRequiresAuth:YES];
    [mm setLogin:info[@"email"]];
    [mm setPass:info[@"psw"]];
    [mm setWantsSecure:YES];
     mm.delegate = self;
    
    NSDictionary *plain_text_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"text/plain\r\n\tcharset=UTF-8;\r\n\tformat=flowed", kSKPSMTPPartContentTypeKey,
                                     [self.contentView.text stringByAppendingString:@"\n"], kSKPSMTPPartMessageKey,
                                     @"quoted-printable", kSKPSMTPPartContentTransferEncodingKey,
                                     nil];
    //附件信息
    NSMutableArray *mutarr = [[NSMutableArray alloc]init];
    [mutarr addObject:plain_text_part];
    
    for (UIImage *image in self.imageArr) {
        NSData *data = UIImageJPEGRepresentation(image,0.5);
       
        NSDictionary *vcfPart =[NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.png\"",kSKPSMTPPartContentTypeKey,
                                @"attachment;\r\n\tfilename=\"feed.png\"",kSKPSMTPPartContentDispositionKey,
                                [data encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [mutarr addObject:vcfPart];
    }
    [mm setParts:mutarr];
    [mm send];
}

-(void)messageSuc{
    self.navigationController.view.userInteractionEnabled = YES;

    [_timer invalidate];
}

- (void)messageSent:(SKPSMTPMessage *)message{
    self.navigationController.view.userInteractionEnabled = YES;
    [_timer invalidate];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    self.navigationController.view.userInteractionEnabled = YES;
//    [SVProgressHUD showErrorWithStatus:Local(@"Send failed, check the mailbox and password is correct, or replace the mailbox to send.")];
    [_timer invalidate];
}



#pragma mark - EmailDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultCancelled){
        [SVProgressHUD showErrorWithStatus:Local(@"Cancle")];
    }else if (result == MFMailComposeResultSaved){
        [SVProgressHUD showSuccessWithStatus:Local(@"Save succeed")];
    }else if (result == MFMailComposeResultSent){
        [SVProgressHUD showSuccessWithStatus:Local(@"accomplish")];
        
    }else{
        [SVProgressHUD showErrorWithStatus:Local(@"Failed")];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addimage:(UITapGestureRecognizer *)tap{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:Local(@"Add picture from source") preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"The camera takes a picture") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
        //进入相机
        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus == AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        else{
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [alertVc dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:Local(@"Select a photo from the album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
        //进入相册
        //相册权限
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
            //无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else{
            
            //进入相册
            // 跳转到相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [alertVc dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }

    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消了相机的动作  不做任何的处理
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //现将图片添加进入数组 刷新下方的图片
    [self.imageArr addObject:image];
    [self refrshimage];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)sendButtonClick:(id)sender {
    
    [self addUserInfo];
}

- (NSMutableArray *)imageArr{

    if(!_imageArr){
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}


@end
