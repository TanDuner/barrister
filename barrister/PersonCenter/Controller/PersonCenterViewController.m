//
//  PersonCenterViewController.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterCustomCell.h"
#import "PersonCenterAccountCell.h"
#import "PersonCenterModel.h"
#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "AppointmentViewController.h"
#import "MyAccountHomeViewController.h"
#import "MyMessageViewController.h"
#import "BarristerLoginManager.h"
#import "MyCaseListViewController.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccessAciton) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPayData) name:NOTIFICATION_PAYSWITCH_NOTIFICATION object:nil];

    [self configView];
    [self configData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:YES];
    [self configData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma -mark ------Data-------

-(void)reloadPayData
{
    if (self.items.count > 0) {
        [self.items removeAllObjects];
        [self configData];
    }

}

-(void)LoginSuccessAciton
{
    [self configData];
}


-(void)configData
{
    
    if (self.items.count > 0) {
        [self.items removeAllObjects];
    }
    
    PersonCenterModel *model1 = [[PersonCenterModel alloc] init];
    model1.titleStr = @"注册/登录";
    model1.cellType = PersonCenterModelTypeZH;
    model1.iconNameStr = @"zhanghao.png";
    model1.isShowArrow = NO;
    model1.isAccountLogin = [BaseDataSingleton shareInstance].loginState.integerValue == 1?YES:NO;
 
    [self.items addObject:model1];

    if (![BaseDataSingleton shareInstance].isClosePay) {
        PersonCenterModel *model2 = [[PersonCenterModel alloc] init];
        model2.titleStr = @"我的账户";
        model2.cellType = PersonCenterModelTypeZHU;
        model2.iconNameStr = @"Me_account";
        model2.isShowArrow = YES;
        model2.isAccountLogin = NO;
        [self.items addObject:model2];

    }
    

    
    PersonCenterModel *model3 = [[PersonCenterModel alloc] init];
    model3.titleStr = @"我的消息";
    model3.cellType = PersonCenterModelTypeXX;
    model3.iconNameStr = @"Me_message";
    model3.isShowArrow = YES;
    model3.isAccountLogin = NO;

    
    PersonCenterModel *model8 = [[PersonCenterModel alloc] init];
    model8.titleStr = @"我的案源";
    model8.cellType = PersonCenterModelTypeWDAY;
    model8.iconNameStr = @"xiaoxi.png";
    model8.isShowArrow = YES;
    model8.isAccountLogin = NO;

    
    
    PersonCenterModel *model4 = [[PersonCenterModel alloc] init];
    model4.titleStr = @"认证状态";
    if ([[BaseDataSingleton shareInstance].userModel.verifyStatus isEqualToString:AUTH_STATUS_UNAUTHERIZED]) {
        
        model4.subtitleStr = @"未认证";
    }
    else if ([[BaseDataSingleton shareInstance].userModel.verifyStatus isEqualToString:AUTH_STATUS_FAILED])
    {
        model4.subtitleStr = @"认证失败";
    
    }
    else if ([[BaseDataSingleton shareInstance].userModel.verifyStatus isEqualToString:AUTH_STATUS_SUCCESS])
    {
        model4.subtitleStr = @"已认证";
    }
    else if ([[BaseDataSingleton shareInstance].userModel.verifyStatus isEqualToString:AUTH_STATUS_VERIFYING])
    {
        model4.subtitleStr = @"审核中";
    }
    
    model4.cellType = PersonCenterModelTypeRZZT;
    model4.iconNameStr = @"Me_renzhen";
    model4.isShowArrow = NO;
    model4.isAccountLogin = NO;
    
    
    PersonCenterModel *model5 = [[PersonCenterModel alloc] init];
    model5.titleStr = @"接单设置";
    model5.cellType = PersonCenterModelTypeJDSZ;
    model5.iconNameStr = @"Me_jiedan";
    model5.isShowArrow = YES;
    model5.isAccountLogin = NO;

    
    PersonCenterModel *model6 = [[PersonCenterModel alloc] init];
    model6.titleStr = @"设置";
    model6.cellType = PersonCenterModelTypeSZ;
    model6.iconNameStr = @"Me_setting";
    model6.isShowArrow = YES;
    model6.isAccountLogin = NO;

    [self.items addObject:model3];
    [self.items addObject:model8];
    [self.items addObject:model4];
    [self.items addObject:model5];
    [self.items addObject:model6];
}

#pragma -mark --------UI--------

-(void)configView
{
    
}


#pragma -mark --------UITableView DataSource Methods----------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        if ([BaseDataSingleton shareInstance].isClosePay) {
            return 4;
        }
        return 5;
    }
    else
    {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        view.backgroundColor = kBaseViewBackgroundColor;
        return view;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 20;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"accountCell";
        PersonCenterAccountCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[PersonCenterAccountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        PersonCenterModel *model =  (PersonCenterModel *)[self.items safeObjectAtIndex:0];
        cell.model = model;
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"customCell";
        PersonCenterCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[PersonCenterCustomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }

        PersonCenterModel *model =  (PersonCenterModel *)[self.items safeObjectAtIndex:indexPath.section == 1?(indexPath.row + 1):(self.items.count - 1)];
        cell.model = model;
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [PersonCenterAccountCell getCellHeight];
    }
    else
    {
        return  [PersonCenterCustomCell getCellHeight];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (![[BaseDataSingleton shareInstance].loginState isEqualToString:@"1"]) {
        [[BarristerLoginManager shareManager] showLoginViewControllerWithController:self];
        return;
    }
    
        PersonCenterCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PersonCenterModel *model = (PersonCenterModel *)cell.model;
    
        switch (model.cellType) {
                
            case PersonCenterModelTypeZH:
            {
                PersonInfoViewController *personInfo = [[PersonInfoViewController alloc] init];
                personInfo.fromType = @"1";
                [self.navigationController pushViewController:personInfo animated:YES];

            }
                break;
            case PersonCenterModelTypeZHU:
            {
                MyAccountHomeViewController *accountVC = [[MyAccountHomeViewController alloc] init];
                [self.navigationController pushViewController:accountVC animated:YES];

            }
                break;
                case PersonCenterModelTypeXX:
            {
                MyMessageViewController *messageVC = [[MyMessageViewController alloc] init];
                [self.navigationController pushViewController:messageVC animated:YES];

            }
                break;
                case PersonCenterModelTypeJDSZ:
            {
                AppointmentViewController *appointVC = [[AppointmentViewController alloc] init];
                [self.navigationController pushViewController:appointVC animated:YES];

            }
                break;
                case PersonCenterModelTypeSZ:
            {
                SettingViewController *settingVC = [[SettingViewController alloc] init];
                [self.navigationController pushViewController:settingVC animated:YES];

            }
                break;
                
                case PersonCenterModelTypeWDAY:
            {
                MyCaseListViewController *caseList = [[MyCaseListViewController alloc] init];
                [self.navigationController pushViewController:caseList animated:YES];
            }
                break;
                default:
            {
            
            }
                break;
                
    }
}


@end
