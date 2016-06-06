//
//  OrderViewController.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "OrderViewController.h"
#import "BarristerOrderModel.h"
#import "OrderViewCell.h"
#import "OrderDetailViewController.h"
#import "RefreshTableView.h"
#import "OrderProxy.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>

@property (nonatomic,strong) RefreshTableView *leftTableView;
@property (nonatomic,strong) RefreshTableView *rightTableView;

@property (nonatomic,strong) NSMutableArray *leftItems;
@property (nonatomic,strong) NSMutableArray *rightItems;

@property (nonatomic,strong) OrderProxy *proxy;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self initData];
    [self loadLeftItems];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:YES];
}

#pragma -mark ----UI------

-(void)configView
{
    [self configNavigationView];
    [self configTableView];
    
}

-(void)configNavigationView
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"电话咨询",@"预约咨询"]];
    
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.tintColor = [UIColor whiteColor];
    
    [segmentControl setFrame:RECT(0, 0, 160, 30)];
    
    segmentControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = segmentControl;
}

-(void)configTableView
{
    _leftTableView = [[RefreshTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    [_leftTableView setFootLoadMoreControl];
    _leftTableView.backgroundColor = KColorGray1;
    _leftTableView.refreshDelegate = self;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    
    _rightTableView = [[RefreshTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    [_rightTableView setFootLoadMoreControl];
    _rightTableView.backgroundColor = KColorGray2;
    _rightTableView.refreshDelegate = self;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    
    [self.view addSubview:_rightTableView];
    [self.view addSubview:_leftTableView];
}

#pragma -mark -----Data------

-(void)initData
{
    _leftItems = [NSMutableArray arrayWithCapacity:1];
    _rightItems = [NSMutableArray arrayWithCapacity:1];
}

-(void)loadLeftItems
{
    /**
     造假数据
     - returns:
     */
    
    //    userId,verifyCode,page,pageSize,type(IM即时,APPOINTMENT预约)

    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode",[NSString stringWithFormat:@"%ld",_leftTableView.pageNum],@"page",[NSString stringWithFormat:@"%ld",_leftTableView.pageSize],@"pageSize",@"IM",@"type", nil];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy getOrderListWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSArray *array = (NSArray *)returnData;
            [weakSelf wrapLeftOrderDataWithArray:array];
        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败..." completionBlock:nil];
        }
    }];
    
    
}

-(void )wrapLeftOrderDataWithArray:(NSArray *)array
{
    if (_leftTableView.pageNum == 1 && _leftItems.count > 0) {
        [self.leftTableView endRefreshing];
        [_leftItems removeAllObjects];
        
    }else{
        [self.leftTableView endLoadMoreWithNoMoreData:NO];
    }
    
    
    BarristerOrderModel *model = [[BarristerOrderModel alloc] init];
    model.customerName = @"用户134****7654";
    model.userHeder = @"http://img4.duitang.com/uploads/item/201508/26/20150826212734_ST5BC.thumb.224_0.jpeg";
    model.caseType = @"债务纠纷";
    model.orderTime = @"2016-04-09 15:00:00";
    model.orderType = BarristerOrderTypeJSZX;
    
    BarristerOrderModel *model1 = [[BarristerOrderModel alloc] init];
    model1.userHeder = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=327417392,2097894166&fm=116&gp=0.jpg";
    model1.customerName = @"用户158****0087";
    model1.orderTime = @"2016-04-10 13:17:24";
    model1.caseType = @"财产纠纷";
    model1.orderType = BarristerOrderTypeJSZX;
    
    BarristerOrderModel *model2 = [[BarristerOrderModel alloc] init];
    model2.userHeder = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=731016823,2238050103&fm=116&gp=0.jpg";
    model2.customerName = @"用户186****7339";
    model2.orderTime = @"2016-04-12 10:39:50";
    model2.caseType = @"民事案件";
    model2.orderType = BarristerOrderTypeJSZX;
    
    [self.leftItems addObject:model];
    [self.leftItems addObject:model1];
    [self.leftItems addObject:model2];
    
    [self.leftTableView reloadData];

}


-(void)loadRightItems
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode",[NSString stringWithFormat:@"%ld",_rightTableView.pageNum],@"page",[NSString stringWithFormat:@"%ld",_rightTableView.pageSize],@"pageSize",@"APPOINTMENT",@"type", nil];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy getOrderListWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSArray *array = (NSArray *)returnData;
            [weakSelf wrapRightOrderDataWithArray:array];
            
        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败..." completionBlock:nil];
        }
    }];

}


-(void)wrapRightOrderDataWithArray:(NSArray *)array
{
    if (_rightTableView.pageNum == 1 && _rightItems.count > 0) {
        [_rightTableView endRefreshing];
        [_rightItems removeAllObjects];
        
    }else{
        [_rightTableView endLoadMoreWithNoMoreData:NO];
    }
    
    
    BarristerOrderModel *model4 = [[BarristerOrderModel alloc] init];
    model4.customerName = @"用户134****7654";
    model4.userHeder = @"http://img4.duitang.com/uploads/item/201508/26/20150826212734_ST5BC.thumb.224_0.jpeg";
    model4.startTime = @"2016/04/24 13:00";
    model4.endTime = @"2016/03/24 14:00";
    model4.caseType = @"债务纠纷";
    model4.orderType = BarristerOrderTypeYYZX;
    
    BarristerOrderModel *model5 = [[BarristerOrderModel alloc] init];
    model5.userHeder = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=327417392,2097894166&fm=116&gp=0.jpg";
    model5.customerName = @"用户158****0087";
    model5.startTime = @"2016/04/25 14:00";
    model5.endTime = @"2016/04/25 15:00";
    model5.caseType = @"财产纠纷";
    model5.orderType = BarristerOrderTypeYYZX;
    
    BarristerOrderModel *model6 = [[BarristerOrderModel alloc] init];
    model6.userHeder = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=731016823,2238050103&fm=116&gp=0.jpg";
    model6.customerName = @"用户186****7339";
    model6.startTime = @"2016/04/26 15:00";
    model6.endTime = @"2016/04/26 16:00";
    model6.caseType = @"民事案件";
    model6.orderType = BarristerOrderTypeYYZX;
    
    [self.rightItems addObject:model4];
    [self.rightItems addObject:model5];
    [self.rightItems addObject:model6];
    
    
    [self.rightTableView reloadData];

}



#pragma -mark -----UITableVIewDelegate Methods------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"orderCell";
    
    OrderViewCell *cell = [self.leftTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[OrderViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (tableView == _leftTableView) {
        BarristerOrderModel *model =  (BarristerOrderModel *)[self.leftItems objectAtIndex:indexPath.row];
        cell.model = model;
    }
    else
    {
        BarristerOrderModel *model =  (BarristerOrderModel *)[self.rightItems objectAtIndex:indexPath.row];
        cell.model = model;
    }

    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return self.leftItems.count;
    }
    else
    {
        return self.rightItems.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma -mark -----Aciton------

-(void)segmentAction:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        if (_leftItems.count == 0) {
            [self loadLeftItems];
        }
        [self.view bringSubviewToFront:_leftTableView];
    }
    else if (segmentControl.selectedSegmentIndex == 1)
    {
        if (_rightItems.count == 0) {
            [self loadRightItems];
        }
        [self.view bringSubviewToFront:_rightTableView];
    }
    else{
    }
}


#pragma -mark -----Refresh&Loadmore methods--------

-(void)circleTableViewDidTriggerRefresh:(RefreshTableView *)tableView
{
    if (tableView == _leftTableView) {
        [self loadLeftItems];
    }
    else
    {
        [self loadRightItems];
    }

}

-(void)circleTableViewDidLoadMoreData:(RefreshTableView *)tableView
{
    if (tableView == _leftTableView) {
        [self loadLeftItems];
    }
    else
    {
        [self loadRightItems];
    }
    
}


#pragma -mark -----Getter------
-(OrderProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[OrderProxy alloc] init];
    }
    return _proxy;
}


@end
