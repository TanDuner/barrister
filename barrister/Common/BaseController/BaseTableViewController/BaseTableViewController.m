//
//  BaseTableViewController.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface BaseTableViewController ()


@end

@implementation BaseTableViewController

-(instancetype)init
{
    if (self = [super init]) {
        self.items = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark ------Data-------

-(void)loadItems
{

}


#pragma -mark --------UI------------

-(void)configTableView
{
    self.tableView = [[BaseTableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)addRefreshHeader
{
    MJRefreshNormalHeader *headerTemp = [MJRefreshNormalHeader headerWithRefreshingTarget:self.tableView refreshingAction:@selector(loadItems)];
    self.tableView.mj_header = headerTemp;
    
}

-(void)addLoadMoreFooter
{
    MJRefreshAutoNormalFooter *footerTemp = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.tableView refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footerTemp;
}


#pragma -mark -----UITableView Delegate Methods-----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

#pragma 
#pragma -mark -----Custom Methods-----

- (void)scrollToFirstRow {
    if (self.tableView.contentOffset.y<0) {
        return;
    }
    
    
    if (self.items && self.items.count > 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma -mark -------RefreshAndLoadMore--------

-(void)circleTableViewDidTriggerRefresh:(id)object
{
    
}

-(void)circleTableViewDidLoadMoreData:(id)object
{

}
@end
