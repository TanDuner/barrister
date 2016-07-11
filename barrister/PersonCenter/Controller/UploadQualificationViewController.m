//
//  UploadQualificationViewController.m
//  barrister
//
//  Created by 徐书传 on 16/6/13.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "UploadQualificationViewController.h"
#import "UploadQualificaitonModel.h"
#import "UploadQualificationCell.h"
#import "AJPhotoPickerViewController.h"
#import "MeNetProxy.h"
#import <AVFoundation/AVFoundation.h>


@interface UploadQualificationViewController ()<UITableViewDataSource,UITableViewDelegate,AJPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) MeNetProxy *proxy;

@property (nonatomic,strong) UploadQualificaitonModel *uploadTempModel;

@property (nonatomic,assign) NSInteger uploadCount;

@end

@implementation UploadQualificationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    [self configData];
    
    self.uploadCount = 0;
    
}

#pragma -mark --Data--
-(void)configData
{
    self.items = [NSMutableArray arrayWithCapacity:5];
    UploadQualificaitonModel *model1 = [[UploadQualificaitonModel alloc] init];
    model1.title = @"法律职业资格证书";
    model1.uploadType = UploadTypeGnvqs;
    
    UploadQualificaitonModel *model2 = [[UploadQualificaitonModel alloc] init];
    model2.title = @"执业证书";
    model2.uploadType = UploadTypeCertificate;
    
    UploadQualificaitonModel *model3 = [[UploadQualificaitonModel alloc] init];
    model3.title = @"执业证书年检页";
    model3.uploadType = UploadTypeYear;
    
    UploadQualificaitonModel *model4 = [[UploadQualificaitonModel alloc] init];
    model4.title = @"身份证正面";
    model4.uploadType = UploadTypeCard;
    
    [self.items addObject:model1];
    [self.items addObject:model2];
    [self.items addObject:model3];
    [self.items addObject:model4];
}

#pragma -mark -----UI------

-(void)configView
{
    self.title = @"资质上传";
    
    [self initNavigationRightTextButton:@"确定" action:@selector(uploadAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

#pragma -mark -----UITableView Delegate Methods------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"identifiUpload";
    UploadQualificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UploadQualificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    if (self.items.count > indexPath.row) {
        UploadQualificaitonModel *modelTemp = [self.items safeObjectAtIndex:indexPath.row];
        cell.model = modelTemp;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.items.count > indexPath.row) {
        
        self.uploadTempModel = (UploadQualificaitonModel *)[self.items safeObjectAtIndex:indexPath.row];
        
        AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = YES;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        [self presentViewController:picker animated:YES completion:nil];

    }

    

}


- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count == 1) {
        ALAsset *asset = assets[0];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.uploadTempModel.uploadImage = image;
        self.uploadCount += 1;
        [self.tableView reloadData];
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
        self.uploadTempModel.uploadImage = image;
        self.uploadCount += 1;
        [self.tableView reloadData];
        
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

#pragma -mark ----UploadHeaderImage------


-(NSString *)getImageNameWithUploadModel:(UploadQualificaitonModel *)model
{
    
    NSString *imageName = @"";
    
    if (model.uploadType == UploadTypeGnvqs) {
        imageName = @"gnvqs";
    }
    else if (model.uploadType == UploadTypeCertificate)
    {
        imageName = @"certificate";
    }
    else if (model.uploadType == UploadTypeYear)
    {
        imageName = @"year";
    }
    else if (model.uploadType == UploadTypeCard)
    {
        imageName = @"card";
    }
    
    return imageName;
}


-(void)uploadAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [params setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    
    [XuUItlity showLoading:@"正在上传..."];

    for (int i = 0; i < self.items.count; i ++) {
        UploadQualificaitonModel *model = [self.items safeObjectAtIndex:i];
        [self uploadImageItem:model];
        
    }

}

-(void)uploadImageItem:(UploadQualificaitonModel *)model
{
    
    if (!model) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [params setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    
    __weak typeof(*& self) weakSelf = self;
    
    [self.proxy UploadAuthImageUrlWithImage:model.uploadImage params:params fileName:[self  getImageNameWithUploadModel:model] Block:^(id returnData, BOOL success) {
        self.uploadCount -= 1;
        if (success) {
            
        }
        else
        {
            [XuUItlity showFailedHint:@"上传失败" completionBlock:nil];
        }
        
        if (self.uploadCount == 0) {
            [XuUItlity hideLoading];
            [XuUItlity showSucceedHint:@"上传成功" completionBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }];
        }
    }];

}



#pragma -mark ---Getter----

-(MeNetProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[MeNetProxy alloc] init];
    }
    return _proxy;
}



@end
