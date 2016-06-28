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
//    [self configView];
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
 
    [self requestMyAccountData];
    
    [self requestAccountDetailData];
    
}

-(void)requestMyAccountData
{
    __weak typeof(*&self) weakSelf = self;
    NSMutableDictionary *aParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode", nil];
     [self.proxy getMyAccountDataWithParams:aParams Block:^(id returnData, BOOL success) {
         if (success) {
             NSDictionary *dict = (NSDictionary *)returnData;
             if ([dict respondsToSelector:@selector(objectForKey:)]) {
                 [weakSelf handleMyAccountDataWithDict:dict];
             }

         }
         else
         {
             NSString *errorTip = (NSString *)returnData;
             [XuUItlity showFailedHint:errorTip completionBlock:nil];
         }
     }];
}


-(void)handleMyAccountDataWithDict:(NSDictionary *)dict
{
    
}


-(void)requestAccountDetailData
{
    __weak typeof(*&self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [params setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    [params setObject:[NSString stringWithFormat:@"%ld",self.detailTableView.pageSize] forKey:@"pageSize"];
    [params setObject:[NSString stringWithFormat:@"%ld",self.detailTableView.pageNum] forKey:@"page"];
    [self.proxy getAccountDetailDataWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            NSArray *detailArray = [dict objectForKey:@"items"];
            if ([XuUtlity isValidArray:detailArray]) {
                [weakSelf handleAccountDetailDataWithArray:detailArray];
            }
            else
            {
                [weakSelf handleAccountDetailDataWithArray:@[]];
            }
            
         
        }
        else
        {
            [XuUItlity showFailedHint:@"明细加载失败" completionBlock:nil];
        }
    }];
    
}

-(void)handleAccountDetailDataWithArray:(NSArray *)array
{
    if (self.detailTableView.pageNum == 1) {
        [self.detailArray removeAllObjects];
        [self.detailTableView endRefreshing];
    }
    else
    {
        if (array.count < self.detailTableView.pageSize) {
            [self.detailTableView endLoadMoreWithNoMoreData:YES];
        }
        else
        {
            [self.detailTableView endLoadMoreWithNoMoreData:NO];
        }
    }
    
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array objectAtIndex:i];
        MyAccountDetailModel *detailModel = [[MyAccountDetailModel alloc] initWithDictionary:dict];
        [self.detailArray addObject:detailModel];
    }
   
    [self.detailTableView reloadData];
    
    
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
