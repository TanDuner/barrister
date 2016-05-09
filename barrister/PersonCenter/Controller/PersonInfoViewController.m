//
//  PersonInfoViewController.m
//  barrister
//
//  Created by 徐书传 on 16/4/19.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonCenterModel.h"

@interface PersonInfoViewController ()

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

#pragma -mark ---------Data--------

-(void)configData
{
    PersonCenterModel *model1 = [[PersonCenterModel alloc] init];
    model1.cellType = PersonCenterModelTypeTX;
    model1.titleStr = @"头像";
    
}

#pragma -mark ----------UI---------

-(void)configView
{

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
