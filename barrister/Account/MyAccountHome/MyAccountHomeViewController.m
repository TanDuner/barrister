//
//  MyAccountHomeViewController.m
//  barrister
//
//  Created by 徐书传 on 16/5/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "MyAccountHomeViewController.h"
#import "MyAccountHeadView.h"
#import "MyAccountDetailCell.h"
#import "MyAccountDetailModel.h"
#import "XuNetWorking.h"
#import "AccountProxy.h"
#import "MyAccountDetailModel.h"
#import "RefreshTableView.h"
#import "MyBankCardController.h"
#import "TiXianViewControlleer.h"

#define HeadViewHeight 115

@interface MyAccountHomeViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>

/**
 *  顶部headView
 */
@property (nonatomic,strong) MyAccountHeadView *headView;

@property (nonatomic,strong) RefreshTableView *detailTableView;

/**
 *  明细的数组
 */
@property (nonatomic,strong) NSMutableArray *detailArray;

@property (nonatomic,strong) AccountProxy *proxy;

@end

@implementation MyAccountHomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    [self configData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
    self.detailTableView.delegate = self;

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//用于去除导航栏的底线，也就是周围的边线

}




#pragma -mark ----UI----

-(void)configView
{
    [self initTableView];
    self.title = @"我的账户";
}


/**
 *  tableView
 */
- (void)initTableView
{
    
    [self.view addSubview:self.detailTableView];
    [XuUItlity clearTableViewEmptyCellWithTableView:self.detailTableView];


}


-(void)configTableView
{
    
}


#pragma -mark ------Data----------
-(void)configData
{
    
    MyAccountDetailModel *model1 = [[MyAccountDetailModel alloc] init];
    model1.titleStr = @"2014443043053";
    model1.dateStr = @"2016-05-25";
    model1.handleType = 0;
    model1.numStr = @"140";
    
    MyAccountDetailModel *model2 = [[MyAccountDetailModel alloc] init];
    model2.titleStr = @"2014443043053";
    model2.dateStr = @"2016-05-25";
    model2.handleType = 0;
    model2.numStr = @"30";
    
    MyAccountDetailModel *model3 = [[MyAccountDetailModel alloc] init];
    model3.titleStr = @"提现";
    model3.dateStr = @"2016-05-28";
    model3.handleType = 1;
    model3.numStr = @"1000";
    
    MyAccountDetailModel *model4 = [[MyAccountDetailModel alloc] init];
    model4.titleStr = @"2014443043053";
    model4.dateStr = @"2016-05-15";
    model4.handleType = 0;
    model4.numStr = @"200";
    
    [self.detailArray addObject:model1];
    [self.detailArray addObject:model2];
    [self.detailArray addObject:model3];
    [self.detailArray addObject:model4];
    
    [self.detailTableView reloadData];
    
    [self.proxy getAccountDetailDataWithParams:nil Block:^(id returnData, BOOL success) {
        if (success) {
            
        }
    }];
}

#pragma -mark ----UITableView DataSource-----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyAccountDetailCell getCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"identifi";
    MyAccountDetailCell *cell = (MyAccountDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[MyAccountDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyAccountDetailModel *model = [self.detailArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark ----Refresh Delegate Methods-----

-(void)circleTableViewDidTriggerRefresh:(RefreshTableView *)tableView
{
     [self configData];
}

-(void)circleTableViewDidLoadMoreData:(RefreshTableView *)tableView
{
    [self configData];
}


#pragma -mark ---Getter----

-(MyAccountHeadView *)headView
{
    if (!_headView) {
        __weak typeof(*&self) weakSelf = self;
        _headView = [[MyAccountHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HeadViewHeight)];
        _headView.handleBlock = ^(NSInteger type)
        {
            [weakSelf handleHeadViewAcitonWithType:type];
        };
    }
    return _headView;
}

-(UITableView *)detailTableView
{
    if (!_detailTableView) {
        _detailTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT) style:UITableViewStylePlain];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.tableHeaderView = self.headView;
        _detailTableView.refreshDelegate = self;
        _detailTableView.backgroundColor = [UIColor clearColor];
        _detailTableView.backgroundView = nil;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.showsVerticalScrollIndicator = NO;

    }
    return _detailTableView;
}

-(NSMutableArray *)detailArray
{
    if (!_detailArray) {
        _detailArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _detailArray;
}

-(AccountProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[AccountProxy alloc] init];
    }
    return _proxy;
}

-(void)handleHeadViewAcitonWithType:(AccountHeadViewHandleType)type
{
    switch (type) {
        case AccountHeadViewHandleTypeSM:
        {
        
        }
            break;
        case AccountHeadViewHandleTypeTX:
        {
            TiXianViewControlleer *tixian = [[TiXianViewControlleer alloc] init];
            [self.navigationController pushViewController:tixian animated:YES];
        }
            break;
        case AccountHeadViewHandleTypeYHK:
        {
            MyBankCardController *myBankVC = [[MyBankCardController alloc] init];
            [self.navigationController pushViewController:myBankVC animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
