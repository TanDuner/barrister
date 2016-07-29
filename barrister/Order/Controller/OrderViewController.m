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

@property (nonatomic,assign) BOOL isShowLeft;

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
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"即时咨询",@"预约咨询"]];
    
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.tintColor = [UIColor whiteColor];
    
    [segmentControl setFrame:RECT(0, 0, 160, 30)];
    
    segmentControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = segmentControl;
}

-(void)configTableView
{
    _leftTableView = [[RefreshTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT ) style:UITableViewStylePlain];
    [_leftTableView setFootLoadMoreControl];
    _leftTableView.pageSize = 10;
    _leftTableView.backgroundColor = kBaseViewBackgroundColor;
    _leftTableView.refreshDelegate = self;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    
    _rightTableView = [[RefreshTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT) style:UITableViewStylePlain];
    [_rightTableView setFootLoadMoreControl];
    _rightTableView.backgroundColor = kBaseViewBackgroundColor;
    _rightTableView.refreshDelegate = self;
    _rightTableView.pageSize = 10;
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
    self.isShowLeft = YES;
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
            if ([XuUtlity isValidArray:array]) {
                [weakSelf wrapLeftOrderDataWithArray:array];
            }
            else
            {
                [weakSelf wrapLeftOrderDataWithArray:@[]];
            }

        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败..." completionBlock:nil];
        }
    }];
    
    
}

-(void )wrapLeftOrderDataWithArray:(NSArray *)array
{
    
    __weak typeof(*&self) weakSelf = self;
    [self handleTableRefreshOrLoadMoreWithTableView:self.leftTableView array:array aBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.leftItems removeAllObjects];
    }];
    
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array safeObjectAtIndex:i];
        BarristerOrderModel *model = [[BarristerOrderModel alloc] initWithDictionary:dict];
        [self.leftItems addObject:model];
    }
    [self.leftTableView reloadData];

    
}


-(void)loadRightItems
{
//    userId,verifyCode,page,pageSize,type
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode",[NSString stringWithFormat:@"%ld",_rightTableView.pageNum],@"page",[NSString stringWithFormat:@"%ld",_rightTableView.pageSize],@"pageSize",APPOINTMENT,@"type", nil];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy getOrderListWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSArray *array = (NSArray *)returnData;
            if ([XuUtlity isValidArray:array]) {
                [weakSelf wrapRightOrderDataWithArray:array];
            }
            else
            {
                [weakSelf wrapRightOrderDataWithArray:@[]];
            }

            
        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败" completionBlock:nil];
        }
    }];

}


-(void)wrapRightOrderDataWithArray:(NSArray *)array
{

    
    __weak typeof(*&self) weakSelf = self;
    [self handleTableRefreshOrLoadMoreWithTableView:self.rightTableView array:array aBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.rightItems removeAllObjects];
    }];
    
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array safeObjectAtIndex:i];
        BarristerOrderModel *model = [[BarristerOrderModel alloc] initWithDictionary:dict];
        [self.rightItems addObject:model];
    }
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
        BarristerOrderModel *model =  (BarristerOrderModel *)[self.leftItems safeObjectAtIndex:indexPath.row];
        cell.model = model;
    }
    else
    {
        BarristerOrderModel *model =  (BarristerOrderModel *)[self.rightItems safeObjectAtIndex:indexPath.row];
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
    if (self.isShowLeft) {
        BarristerOrderModel *model = [self.leftItems safeObjectAtIndex:indexPath.row];
        OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] initWithOrderId:model.orderId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        BarristerOrderModel *model = [self.rightItems safeObjectAtIndex:indexPath.row];
        OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] initWithOrderId:model.orderId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }

    
}

#pragma -mark -----Aciton------

-(void)segmentAction:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        self.isShowLeft = YES;
        if (_leftItems.count == 0) {
            [self loadLeftItems];
        }
        [self.view bringSubviewToFront:_leftTableView];
    }
    else if (segmentControl.selectedSegmentIndex == 1)
    {
        self.isShowLeft = NO;
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
