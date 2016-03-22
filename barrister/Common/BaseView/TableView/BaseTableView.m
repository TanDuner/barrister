//
//  BaseTableView.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableView.h"

#import "MJRefresh.h"

#import "UIScrollView+MJRefresh.h"


@implementation BaseTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initBaseProprety];
        
        [self createRefreshControl];
    }
    return self;
}

-(void)initBaseProprety
{
    self.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

-(void)createRefreshControl
{
    MJRefreshNormalHeader *headerTemp = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadItems)];
    self.mj_header = headerTemp;
    
    MJRefreshAutoNormalFooter *footerTemp = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.mj_footer = footerTemp;
}

-(void)loadItems
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(circleTableViewDidTriggerRefresh:)]) {
        [self.refreshDelegate circleTableViewDidTriggerRefresh:nil];
    }
}

-(void)loadMoreData
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(circleTableViewDidLoadMoreData:)]) {
        [self.refreshDelegate circleTableViewDidLoadMoreData:nil];
    }
}


@end
