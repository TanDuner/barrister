//
//  CaseSourceViewController.m
//  barrister
//
//  Created by 徐书传 on 16/7/10.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseSourceViewController.h"
#import "RefreshTableView.h"
#import "HomePageProxy.h"
#import "HomeCaseListModel.h"
#import "HomeCaseSourceCell.h"
#import "CaseSourceDetailViewController.h"
#import "NeedHelpViewController.h"


@interface CaseSourceViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>
@property (nonatomic,strong) RefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) HomePageProxy *proxy;

@end

@implementation CaseSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self configView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
    [self configData];

}

-(void)configView
{
    self.title = @"案源列表";
    [self.view addSubview:self.tableView];
//    [self initNavigationRightTextButton:@"发布案源" action:@selector(addCaseSource) target:self];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addCaseSource) forControlEvents:UIControlEventTouchUpInside];
//    [addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addBtn setFrame:RECT((SCREENWIDTH - 20 - 30)/2.0, (100 - 30)/2.0 - 15, 25, 25)];


    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)addCaseSource
{
    NeedHelpViewController *needVC = [[NeedHelpViewController alloc] init];
    [self.navigationController pushViewController:needVC animated:YES];

}


-(void)configData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.tableView.pageSize],@"pageSize",[NSString stringWithFormat:@"%ld",self.tableView.pageNum],@"page", nil];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy getCaseListWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            NSArray *array = (NSArray *)[dict objectForKey:@"cases"];
            if ([XuUtlity isValidArray:array]) {
                [weakSelf handleSourceListWithArray:array];
            }
            else
            {
                [weakSelf handleSourceListWithArray:@[]];
            }

        }
        else
        {
            
        }
    }];

   
}

-(void)circleTableViewDidTriggerRefresh:(RefreshTableView *)tableView
{
    [self configData];
}

-(void)circleTableViewDidLoadMoreData:(RefreshTableView *)tableView
{
    [self configData];
}



-(void)handleSourceListWithArray:(NSArray *)array
{
   
    __weak typeof(*&self) weakSelf = self;
    [self handleTableRefreshOrLoadMoreWithTableView:self.tableView array:array aBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.items removeAllObjects];

    }];
    
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = (NSDictionary *)[array safeObjectAtIndex:i];
        HomeCaseListModel *model = [[HomeCaseListModel alloc] initWithDictionary:dict];
        [self.items addObject:model];
    }
    
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.items.count > indexPath.row) {
        HomeCaseListModel *model = (HomeCaseListModel *)[self.items safeObjectAtIndex:indexPath.row];
        return [HomeCaseSourceCell getCellHeightWithModel:model];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identif = @"HomeCaseSourceCell";
    HomeCaseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HomeCaseSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.items.count > indexPath.row) {
        HomeCaseListModel *model = (HomeCaseListModel *)[self.items safeObjectAtIndex:indexPath.row];
        cell.model = model;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BaseDataSingleton shareInstance].isClosePay) {
        return;
    }
    if (self.items.count > indexPath.row) {
        HomeCaseListModel *model = (HomeCaseListModel *)[self.items objectAtIndex:indexPath.row];
        CaseSourceDetailViewController *detailVC = [[CaseSourceDetailViewController alloc] init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

}


#pragma -mark ---Getter-----
-(NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:5];
    }
    return _items;
}

-(RefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[RefreshTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUSBAR_HIGHT) style:UITableViewStylePlain];
        [_tableView setFootLoadMoreControl];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshDelegate = self;
    }
    return _tableView;
}

-(HomePageProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[HomePageProxy alloc] init];
    }
    return _proxy;
}

@end
