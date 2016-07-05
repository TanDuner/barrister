//
//  PersonInfoViewController.m
//  barrister
//
//  Created by 徐书传 on 16/4/19.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonCenterModel.h"
#import "PersonInfoCustomCell.h"
#import "CityChooseViewController.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ModifyInfoViewController.h"
#import "XuNetWorking.h"
#import "MeNetProxy.h"
#import "UploadQualificationViewController.h"
#import "GoodAtViewController.h"
#import "KKDatePickerView.h"
#import "BarristerUserModel.h"


@interface PersonInfoViewController ()<AJPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,strong) MeNetProxy *proxy;

@property (nonatomic,strong) KKDatePickerView *datePicker;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self configView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

#pragma -mark ----UI------

-(void)configView
{

    if ([self.fromType isEqualToString:@"1"]) {
        self.title = @"个人信息";
    }
    else
    {
        self.title = @"补充个人信息";
    }
    
    [self.view addSubview:self.datePicker];

    
    
}

-(void)addBackButton
{

    if ([self.fromType isEqualToString:@"1"]) {
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
        [backBtn setTitleColor:kButtonColor1Highlight forState:UIControlStateHighlighted];
        [backBtn.titleLabel setFont:SystemFont(16.0f)];
        [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon_hl"] forState:UIControlStateHighlighted];
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(2, -10, 0, 0)];
        [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -5, 0, 0)];
        
        UIBarButtonItem * backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBar;
        [self initNavigationRightTextButton:@"完成" action:@selector(FinishConfigData)];

    }
    else
    {
        
        self.navigationItem.leftBarButtonItem = nil;
        [self initNavigationRightTextButton:@"完成" action:@selector(FinishConfigDataCheck)];
    }
}

#pragma -mark --Aciton---

-(void)FinishConfigDataCheck
{
 
    if (self.items.count < 10) {
        [XuUItlity showFailedHint:@"信息错误" completionBlock:nil];
        return;
    }
    
    if (![BaseDataSingleton shareInstance].userModel.userIcon) {
        [XuUItlity showFailedHint:@"请上传头像" completionBlock:nil];
        return;
    }
    
    PersonCenterModel *nameModel = [self.items objectAtIndex:1];
    if (IS_EMPTY(nameModel.subtitleStr)) {
        [XuUItlity showFailedHint:@"请填入姓名" completionBlock:nil];
        return;
    }

    PersonCenterModel *areaModel = [self.items objectAtIndex:3];
    if (IS_EMPTY(areaModel.subtitleStr)) {
        [XuUItlity showFailedHint:@"请选择地区" completionBlock:nil];
        return;
    }
 
    PersonCenterModel *goodAtModel = [self.items objectAtIndex:5];
    if (IS_EMPTY(goodAtModel.subtitleStr)) {
        [XuUItlity showFailedHint:@"请填写擅长领域" completionBlock:nil];
        return;
    }
    
   
    PersonCenterModel *companyModel = [self.items objectAtIndex:6];
    if (IS_EMPTY(companyModel.subtitleStr)) {
        [XuUItlity showFailedHint:@"请填写律所" completionBlock:nil];
        return;
    }

    PersonCenterModel *zizhiModel = [self.items objectAtIndex:7];
    if (IS_EMPTY(zizhiModel.subtitleStr)) {
        [XuUItlity showFailedHint:@"请上传资质材料" completionBlock:nil];
        return;
    }
    
    PersonCenterModel *workyearsModel = [self.items objectAtIndex:8];
    if (IS_NOT_EMPTY(workyearsModel.subtitleStr)) {
        if (![workyearsModel.subtitleStr isEqualToString:@"未填写"]) {
            [XuUItlity showFailedHint:@"请选择工作时间" completionBlock:nil];
            return;
        }
    }
    
    [self FinishConfigData];
//    PersonCenterModel *introduceModel = [self.items objectAtIndex:9];
//    if (IS_NOT_EMPTY(introduceModel.subtitleStr)) {
//        if (![introduceModel.subtitleStr isEqualToString:@"未填写"]) {
//            [XuUItlity showFailedHint:@"请填写个人简介" completionBlock:nil];
//            return;
//        }
//    }
}

-(void)FinishConfigData
{
    if (self.items.count < 10) {
        [XuUItlity showFailedHint:@"信息错误" completionBlock:nil];
        return;
    }
    
    
    NSMutableDictionary *aParams = [NSMutableDictionary dictionary];
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];

    PersonCenterModel *nameModel = [self.items objectAtIndex:1];
    if (IS_NOT_EMPTY(nameModel.subtitleStr)) {
        if (![nameModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:nameModel.subtitleStr forKey:@"name"];
        }
    }
    
    PersonCenterModel *phoneModel = [self.items objectAtIndex:2];
    if (IS_NOT_EMPTY(phoneModel.subtitleStr)) {
        if (![phoneModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:phoneModel.subtitleStr forKey:@"phone"];
        }
    }
  
    PersonCenterModel *emailModel = [self.items objectAtIndex:3];
    if (IS_NOT_EMPTY(emailModel.subtitleStr)) {
        if (![emailModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:emailModel.subtitleStr forKey:@"email"];
        }
    }
    
    PersonCenterModel *areaModel = [self.items objectAtIndex:4];
    if (IS_NOT_EMPTY(areaModel.subtitleStr)) {
        if (![areaModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:areaModel.subtitleStr forKey:@"area"];
        }
    }
    
    PersonCenterModel *goodAtModel = [self.items objectAtIndex:5];
  
    if (goodAtModel.bizTypeIdStr.length > 0) {
        [aParams setObject:goodAtModel.bizTypeIdStr forKey:@"bizType"];
    }
    
    if (goodAtModel.bizAreaIdStr.length > 0) {
        [aParams setObject:goodAtModel.bizAreaIdStr forKey:@"bizArea"];
    }
    
    
    PersonCenterModel *companyModel = [self.items objectAtIndex:6];
    if (IS_NOT_EMPTY(companyModel.subtitleStr)) {
        if (![companyModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:companyModel.subtitleStr forKey:@"lawOffice"];
        }
    }
    
    
    PersonCenterModel *workyearsModel = [self.items objectAtIndex:8];
    if (IS_NOT_EMPTY(workyearsModel.subtitleStr)) {
        if (![workyearsModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:workyearsModel.subtitleStr forKey:@"employmentYears"];
        }
    }
    
    PersonCenterModel *intruduceModel = [self.items objectAtIndex:9];
    if (IS_NOT_EMPTY(intruduceModel.subtitleStr)) {
        if (![intruduceModel.subtitleStr isEqualToString:@"未填写"]) {
            [aParams setObject:intruduceModel.subtitleStr forKey:@"introduction"];
        }
    }
    
    //缺少极光推送的push id
    
    
    [XuUItlity showLoading:@"正在提交"];
    
    __weak typeof(*&self)weakSelf = self;
    [self.proxy updateUserInfoWithParams:aParams block:^(id returnData, BOOL success) {
        [XuUItlity hideLoading];
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            if (dict && [dict respondsToSelector:@selector(objectForKey:)]) {
                NSDictionary *userDict = [dict objectForKey:@"user"];
                BarristerUserModel *userModel = [[BarristerUserModel alloc] initWithDictionary:userDict];
                [BaseDataSingleton shareInstance].userModel = userModel;
                [weakSelf configData];
                if ([self.fromType isEqualToString:@"1"]) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }

        }
        else
        {
            
        }
    }];
}

#pragma -mark ---------Data--------

-(void)configData
{
    
    [self.items removeAllObjects];
    NSArray *titleArray = @[@"头像",@"姓名",@"手机",@"邮箱",@"地区",@"擅长",@"律所",@"资质上传",@"工作年限",@"个人简介"];
    for (int i = 0; i < titleArray.count; i ++) {
        PersonCenterModel *model = [[PersonCenterModel alloc] init];
        model.titleStr = [titleArray objectAtIndex:i];
     
        switch (i) {
            case 0:
            {
                model.cellType = PersonCenterModelTypeInfoTX;
                model.userIcon = [BaseDataSingleton shareInstance].userModel.userIcon;
            }
                break;
            case 1:
            {
                model.cellType = PersonCenterModelTypeInfoName;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.name?[BaseDataSingleton shareInstance].userModel.name:@"未填写";
            }
                break;
            case 2:
            {
                model.cellType = PersonCenterModelTypeInfoPhone;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.phone?[BaseDataSingleton shareInstance].userModel.phone:@"未填写";
            }
                break;
            case 3:
            {
                model.cellType = PersonCenterModelTypeInfoEmail;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.email?[BaseDataSingleton shareInstance].userModel.email:@"未填写";
            }
                break;
            case 4:
            {
                model.cellType = PersonCenterModelTypeInfoArea;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.area?[BaseDataSingleton shareInstance].userModel.area:@"未填写";
            }
                break;
            case 5:
            {
                model.cellType = PersonCenterModelTypeInfoGoodAt;
                if ([BaseDataSingleton shareInstance].userModel.bizAreaList.count > 0 ||[BaseDataSingleton shareInstance].userModel.bizTypeList.count > 0) {
                    model.subtitleStr = @"已完善";
                }
                else
                {
                    model.subtitleStr = @"未填写";
                }
            }
                break;
            case 6:
            {
                model.cellType = PersonCenterModelTypeInfoCompany;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.company ? [BaseDataSingleton shareInstance].userModel.company:@"未填写";
            }
                break;
            case 7:
            {
                model.cellType = PersonCenterModelTypeInfoZZSC;
                model.subtitleStr = @"";
            }
                break;
                case 8:
            {
                model.cellType = PersonCenterModelTypeInfoGZNX;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.workYears?[BaseDataSingleton shareInstance].userModel.workYears:@"未填写";
            }
                break;
            case 9:
            {
                model.cellType = PersonCenterModelTypeInfoIntroduce;
                model.subtitleStr = [BaseDataSingleton shareInstance].userModel.introduction ?[BaseDataSingleton shareInstance].userModel.introduction:@"未填写";
            }
                break;

            default:
                break;
        }
    
        model.isShowArrow = (i == 2)?NO:YES;

        [self.items addObject:model];
    }
}

#pragma -mark ----------UITableViewDataSource Methods---------


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCenterModel *model = (PersonCenterModel *)[self.items objectAtIndex:indexPath.row];
    
    return [PersonInfoCustomCell getCellHeightWithModel:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoCustomCell *cell = [[PersonInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    PersonCenterModel *modelTemp = (PersonCenterModel *)[self.items objectAtIndex:indexPath.row];
    cell.model = modelTemp;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.items.count <= indexPath.row) {
        return;
    }
    
    PersonCenterModel *modelTemp = [self.items objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups = YES;
            picker.delegate = self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return YES;
            }];
            
            [self presentViewController:picker animated:YES completion:nil];

        }
            break;
        case 1:
        case 3:
        case 6:
        case 9:
        {
            ModifyInfoViewController *modifyVC = [[ModifyInfoViewController alloc] initWithModel:modelTemp];
            modifyVC.modifyBlock = ^(PersonCenterModel *model)
            {
                [self.items replaceObjectAtIndex:indexPath.row withObject:model];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        case 4:
        {
            CityChooseViewController *cityVC = [[CityChooseViewController alloc] init];
            cityVC.cityInfo = ^(NSString *province,NSString *area)
            {
                modelTemp.subtitleStr = [NSString stringWithFormat:@"%@%@",province,area];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:cityVC animated:YES];
        }
            break;
        case 7:
        {
            UploadQualificationViewController *uploadVC = [[UploadQualificationViewController alloc] init];
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
            break;
        case 8:
        {
            
            [UIView animateWithDuration:.5 animations:^{
                [self.datePicker setFrame:RECT(0, SCREENHEIGHT - 320, SCREENWIDTH, 300)];
            }];

        }
            break;
        case 2:
        {
            return;
        }
            break;
        //擅长
        case 5:
        {
            GoodAtViewController *goodAtVC = [[GoodAtViewController alloc] init];
            goodAtVC.cellModel = modelTemp;
            [self.navigationController pushViewController:goodAtVC animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma -mark ---Photo Picker----

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    if (assets.count == 1) {
        ALAsset *asset = assets[0];
        self.headImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [self uploadHeadImage];
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
        self.headImage = image;
        [self uploadHeadImage];

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

-(void)uploadHeadImage
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [params setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    
    [self.proxy UploadHeadImageUrlWithImage:self.headImage params:params fileName:@"userIcon" Block:^(id returnData, BOOL success) {
        if (success) {
            [XuUItlity showSucceedHint:@"上传成功" completionBlock:nil];
            PersonCenterModel *model = (PersonCenterModel *)[self.items objectAtIndex:0];
            model.headImage = self.headImage;
            [self.tableView reloadData];

        }
        else
        {
            [XuUItlity showFailedHint:@"上传失败" completionBlock:nil];
        }
    }];
}

#pragma -mark ----getter----

-(MeNetProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[MeNetProxy alloc] init];
    }
    return _proxy;
}

-(KKDatePickerView *)datePicker
{
    if (!_datePicker) {
        __weak typeof(*&self)weakSelf = self;
         _datePicker = [[KKDatePickerView alloc] initWithFrame:RECT(0, 1000, SCREENWIDTH, 300)];
        _datePicker.block = ^(KKDatePickerViewModel *model, KKDatePickerView *picker)
        {
            if (model.year && model.moth && model.day) {
                if (weakSelf.items.count > 8) {
                PersonCenterModel *cellModel = (PersonCenterModel *)[weakSelf.items objectAtIndex:8];
                    if (cellModel.cellType == PersonCenterModelTypeInfoGZNX) {
                        cellModel.subtitleStr = [NSString stringWithFormat:@"%@-%@-%@",model.year,model.moth,model.day];
                    }
                    
                    [weakSelf.tableView reloadData];
                }

                
            }
            [picker setFrame:RECT(0, 1000, SCREENWIDTH, 300)];
            
        };
    }
    return _datePicker;
}

@end
