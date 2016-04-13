//
//  SettingViewController.m
//  barrister
//
//  Created by 徐书传 on 16/4/11.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "SettingViewController.h"
#import "BaseDataSingleton.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@property (nonatomic,strong) UIButton *bottomBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self configView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma -mark ------Data----------

-(void)configData
{
    [self.items addObject:@"使用帮助"];
    [self.items addObject:@"关于我们"];
    [self.items addObject:@"意见反馈"];
    [self.items addObject:@"联系我们"];
}

-(void)configView
{
    self.title = @"设置";
    
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 60, SCREENWIDTH - 30, 44)];
    
    if ([BaseDataSingleton shareInstance].isAccountLogin) {
        [_bottomBtn setTitle:@"退出登录" forState:UIControlStateNormal];\
        _bottomBtn.backgroundColor = [UIColor whiteColor];
        [_bottomBtn setTitleColor:KColorGray3 forState:UIControlStateNormal];
    }
    else
    {
        [_bottomBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:kNavigationBarColor];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    _bottomBtn.layer.cornerRadius = 5.0f;
    _bottomBtn.layer.masksToBounds = YES;
    [_bottomBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView *footBackview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    [footBackview addSubview:_bottomBtn];
    self.tableView.tableFooterView = footBackview;
}


#pragma -mark -----UITableViewDelegate methods------


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"identifi";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.textLabel.textColor = KColorGray2;
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    return cell;
}

#pragma -mark -----Action-------

-(void)logoutAction:(UIButton *)button
{
    if ([BaseDataSingleton shareInstance].isAccountLogin) {
        [self.navigationController popViewControllerAnimated:YES];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate selectTabWithIndex:0];
    }
}

#pragma -mark ------Getter------

-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _bottomBtn;
}

@end
