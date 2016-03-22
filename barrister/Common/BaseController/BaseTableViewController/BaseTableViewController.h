//
//  BaseTableViewController.h
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"

@interface BaseTableViewController : BaseViewController

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) BaseTableView *tableView;

@end
