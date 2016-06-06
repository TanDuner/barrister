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

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ---------Data--------

-(void)configData
{
    
    NSArray *titleArray = @[@"头像",@"姓名",@"手机",@"邮箱",@"地区",@"专长",@"律所",@"资质上传",@"工作年限",@"个人简介"];
    for (int i = 0; i < titleArray.count; i ++) {
        PersonCenterModel *model = [[PersonCenterModel alloc] init];
        model.titleStr = [titleArray objectAtIndex:i];
        if (i == 0) {
            model.cellType = PersonCenterModelTypeInfoTX;
        }
        else
        {
            model.cellType = PersonCenterModelTypeInfoCommon;
            model.subtitleStr = @"未填写";
        }
        
        model.isShowArrow = (i == 1)?NO:YES;

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
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
        {
            CityChooseViewController *cityVC = [[CityChooseViewController alloc] init];
            [self.navigationController pushViewController:cityVC animated:YES];
        }
            break;
        case 5:
            break;
        case 6:
            break;

        default:
            break;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
