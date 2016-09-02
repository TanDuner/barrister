//
//  UpdateCaseViewController.m
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "UpdateCaseViewController.h"
#import "BorderTextFieldView.h"
#import "UIButton+EnlargeEdge.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CaseSourceProxy.h"
#import "XWMoneyTextField.h"

#define TextHeight 45

@interface UpdateCaseViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AJPhotoPickerProtocol,XWMoneyTextFieldLimitDelegate>

@property (nonatomic,strong) XWMoneyTextField *hetongjineTxt;
@property (nonatomic,strong) XWMoneyTextField *fenchengjineTxt;

@property (nonatomic,strong) UIButton *isHetonButton;

@property (nonatomic,strong) UIView *uploadHetongView;

@property (nonatomic,strong) UIImageView *uploadImageView;

@property (nonatomic,assign) BOOL isQianding;

@property (nonatomic,strong) UIImage *uploadTempImage;

@property (nonatomic,strong) CaseSourceProxy *proxy;

@end

@implementation UpdateCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationRightTextButton:@"更新" action:@selector(updateAciton) target:self];
    
    [self initView];
}

-(void)initView
{
    self.title = @"更新进度";
 

    
    _hetongjineTxt = [[XWMoneyTextField alloc] initWithFrame:RECT(0, 10, SCREENWIDTH, TextHeight)];
    _hetongjineTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _hetongjineTxt.backgroundColor = [UIColor whiteColor];
    _hetongjineTxt.textColor = kFormTextColor;
    _hetongjineTxt.limit.max = @"99999999999.99";
    _hetongjineTxt.limit.delegate = self;
    _hetongjineTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入合同金额" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    
    [self.view addSubview:_hetongjineTxt];
    
    _fenchengjineTxt = [[XWMoneyTextField alloc] initWithFrame:RECT(0, CGRectGetMaxY(_hetongjineTxt.frame) + 10, SCREENWIDTH, TextHeight)];
    _fenchengjineTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _fenchengjineTxt.backgroundColor = [UIColor whiteColor];
    _fenchengjineTxt.textColor = kFormTextColor;
    _fenchengjineTxt.limit.max = @"99999999999.99";
    _fenchengjineTxt.limit.delegate = self;
    _fenchengjineTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入平台分成金额" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    
    [self.view addSubview:_fenchengjineTxt];

    
    self.isHetonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.isHetonButton setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
    [self.isHetonButton setFrame:RECT(10, CGRectGetMaxY(_fenchengjineTxt.frame) + 10, 20, 20)];
    [self.isHetonButton setEnlargeEdge:15];
    [self.isHetonButton addTarget:self action:@selector(selectHetongAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.isHetonButton];
    
//    if ([self.model.status isEqualToString:STATUS_2_WAIT_UPDATE]||[self.model.status isEqualToString:STATUS_3_WAIT_CLEARING]) {
//        self.isQianding = YES;
//        [self.isHetonButton setImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
//    }
//    else{
        [self.isHetonButton setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
        self.isQianding = NO;
//    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(self.isHetonButton.x + 25, CGRectGetMaxY(_fenchengjineTxt.frame) + 12, 150, 12)];
    label.text = @"是否签订合同";
    label.font = SystemFont(13.0f);
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
    
    
    self.uploadHetongView = [[UIView alloc] initWithFrame:RECT(0, label.y + label.height + 10, SCREENWIDTH, 50)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadload)];
    [self.uploadHetongView addGestureRecognizer:tap1];
    self.uploadHetongView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:RECT(10, (self.uploadHetongView.height - 12)/2.0, 150, 12)];
    tipLabel.text = @"上传合同照片";
    tipLabel.textColor = KColorGray666;
    tipLabel.font = SystemFont(13.0f);
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.uploadHetongView addSubview:tipLabel];

    
    self.uploadImageView = [[UIImageView alloc] initWithFrame:RECT(SCREENWIDTH - 10 - 40, 5, 40, 40)];
    self.uploadImageView.backgroundColor = kNavigationBarColor;
    self.uploadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadload)];
    [self.uploadImageView addGestureRecognizer:tap];
    
    [self.uploadHetongView addSubview:self.uploadImageView];
    
    [self.view addSubview:self.uploadHetongView];
    
}

-(void)uploadload
{
    if (!self.isQianding) {
        return;
    }
    
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];

}


-(void)updateAciton
{
    if (!self.isQianding) {
        [XuUItlity showFailedHint:@"请勾选合同选项" completionBlock:nil];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (IS_EMPTY(self.hetongjineTxt.text)) {
        [XuUItlity showAlertHint:@"请输入合同金额" completionBlock:nil andView:self.view];
        return;
    }
    
    if (IS_EMPTY(self.fenchengjineTxt.text)) {
        [XuUItlity showAlertHint:@"请输入分成金额" completionBlock:nil andView:self.view];
        return;
    }
    [params setObject:self.hetongjineTxt.text forKey:@"contractMoney"];
    [params setObject:self.fenchengjineTxt.text forKey:@"percentagePayment"];
    [params setObject:self.isQianding?@"1":@"0" forKey:@"hasContract"];
    

    
    NSData *imageData = [XuUtlity p_compressImage:self.uploadTempImage];
    


    if (self.model.caseId) {
        [params setObject:self.model.caseId forKey:@"caseId"];
    }

    
    [XuUItlity showLoading:@"正在更新..."];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy updateCaseSourceWithParams:params imageData:imageData Block:^(id returnData, BOOL success) {
        if(success)
        {
            weakSelf.model.status = STATUS_3_WAIT_CLEARING;
            [XuUItlity showSucceedHint:@"更新成功" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else{
            [XuUItlity showFailedHint:@"更新失败" completionBlock:nil];
        }
    }];
    
}


#pragma mark - XWMoneyTextFieldLimitDelegate
- (void)valueChange:(id)sender{
    
    if ([sender isKindOfClass:[XWMoneyTextField class]]) {
        
        XWMoneyTextField *tf = (XWMoneyTextField *)sender;
        NSLog(@"XWMoneyTextField ChangedValue: %@",tf.text);
    }
}


#pragma -mark ---Photo Picker----

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count == 1) {
        ALAsset *asset = assets[0];
        self.uploadTempImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    
}


- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}

/**
 *  相机拍摄完成图片
 *
 *  @param picker
 *  @param image
 *  @param editingInfo
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
        self.uploadTempImage = image;
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}

-(void)setUploadTempImage:(UIImage *)uploadTempImage{
    _uploadTempImage = uploadTempImage;
    self.uploadImageView.image = _uploadTempImage;
}


#pragma -mark ------selectHetongAction----

-(void)selectHetongAction
{
    self.isQianding = !self.isQianding;
    if (self.isQianding) {
        [self.isHetonButton setImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];

    }
    else{
        [self.isHetonButton setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];

    }
}

#pragma -mark ---Getter----

-(CaseSourceProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[CaseSourceProxy alloc] init];
    }
    return _proxy;
}


@end
