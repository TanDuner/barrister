//
//  CaseSourceDetailViewController.m
//  barrister
//
//  Created by 徐书传 on 16/8/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseSourceDetailViewController.h"
#import "CaseSourceProxy.h"
#import "CaseDetailBottomCell.h"
#import "CaseDetailInfoCell.h"
#import "CaseCustomInfoCell.h"
#import "UpdateCaseViewController.h"

@interface CaseSourceCellModel : NSObject

@property (nonatomic,strong) NSString *cellType;

@end

@implementation CaseSourceCellModel


@end




@interface CaseSourceDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *orderTableView;

@property (nonatomic,strong) CaseSourceProxy *proxy;

@property (nonatomic,strong) NSMutableArray *items;

@end

@implementation CaseSourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
    [self initData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


-(void)initData
{
    if (self.items) {
        [self.items removeAllObjects];
    }
    
    CaseSourceCellModel *model1 = [[CaseSourceCellModel alloc] init];
    model1.cellType = @"1";
    [self.items addObject:model1];

    
    CaseSourceCellModel *model2 = [[CaseSourceCellModel alloc] init];
    model2.cellType = @"2";
    [self.items addObject:model2];

    
    if ([self.model.status isEqualToString:STATUS_0_INIT]) {
        
    }
    else if ([self.model.status isEqualToString:STATUS_1_PUBLISHED])
    {
        CaseSourceCellModel *model3 = [[CaseSourceCellModel alloc] init];
        model3.cellType = @"3";
        [self.items addObject:model3];

    }
    else if ([self.model.status isEqualToString:STATUS_2_WAIT_UPDATE])
    {
        CaseSourceCellModel *model4 = [[CaseSourceCellModel alloc] init];
        model4.cellType = @"4";
        [self.items addObject:model4];
        
        CaseSourceCellModel *model5 = [[CaseSourceCellModel alloc] init];
        model5.cellType = @"5";
        [self.items addObject:model5];
    }
    else if ([self.model.status isEqualToString:STATUS_3_WAIT_CLEARING])
    {
        CaseSourceCellModel *model5 = [[CaseSourceCellModel alloc] init];
        model5.cellType = @"5";
        [self.items addObject:model5];

    }
    else if ([self.model.status isEqualToString:STATUS_4_WAIT_CLEARED])
    {
    
    }

    [self.orderTableView reloadData];
    
}


#pragma -mark ---------UI----------

-(void)configView
{
    self.title = @"案源详情";
    
    [self.view addSubview:self.orderTableView];
    
}

#pragma -mark ---Data---

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseSourceCellModel *model = (CaseSourceCellModel *)[self.items objectAtIndex:indexPath.row];
    if ([model.cellType isEqualToString:@"1"]) {
        return [CaseDetailInfoCell getHeightWithModel:self.model];
    }
    else if ([model.cellType isEqualToString:@"2"])
    {
        return [CaseCustomInfoCell getHeightWithModel:self.model];
    }
    else
    {
        return [CaseDetailBottomCell getCellHeight];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseSourceCellModel *model = (CaseSourceCellModel *)[self.items objectAtIndex:indexPath.row];
    
    if ([model.cellType isEqualToString:@"1"]) {
        CaseDetailInfoCell *cell = [[CaseDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.model = self.model;
        return cell;
    }
    else if ([model.cellType isEqualToString:@"2"])
    {
        CaseCustomInfoCell *cell = [[CaseCustomInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.model = self.model;
        return cell;
    }
    else if([model.cellType isEqualToString:@"3"])
    {
        
        __weak typeof(*&self) weakSelf = self;
        CaseDetailBottomCell *cell = [[CaseDetailBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.cellType = @"0";
        cell.block = ^()
        {
            [weakSelf cellActionWithType:@"0"];
        };
        return cell;
    }
    else if([model.cellType isEqualToString:@"4"])
    {
        __weak typeof(*&self) weakSelf = self;

        CaseDetailBottomCell *cell = [[CaseDetailBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.cellType = @"1";
        cell.block = ^()
        {
            [weakSelf cellActionWithType:@"1"];
        };
        return cell;
    }
    else if([model.cellType isEqualToString:@"5"])
    {
        __weak typeof(*&self) weakSelf = self;

        CaseDetailBottomCell *cell = [[CaseDetailBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.cellType = @"2";
        cell.block = ^()
        {
            [weakSelf cellActionWithType:@"2"];
        };
        return cell;
    }
    else
    {
        return [UITableViewCell new];
    }
}


-(void)cellActionWithType:(NSString *)type
{
    if ([type isEqualToString:@"0"]) {
        
        [XuUItlity showYesOrNoAlertView:@"确认" noText:@"取消" title:@"提示" mesage:@"确认代理这个案源吗，系统将扣除您50元" callback:^(NSInteger buttonIndex, NSString *inputString) {
            if (buttonIndex == 0) {
                NSLog(@"取消");
            }
            else
            {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.caseId,@"caseId", nil];
                __weak typeof(*&self) weakSelf = self;
                [self.proxy attachCaseSourceWithParams:params Block:^(id returnData, BOOL success) {
                    if (success) {
                        [XuUItlity showSucceedHint:@"代理成功" completionBlock:nil];
                        self.model.status = STATUS_2_WAIT_UPDATE;
                    }
                    else
                    {
                        NSString *resultCode = [returnData objectForKey:@"resultCode"];

                        if ([NSString stringWithFormat:@"%@",resultCode].integerValue == 3000) {
                            
                            [XuUItlity showFailedHint:@"余额不足50元 不能接单哦~" completionBlock:nil];
                            
                            return;
                        }
                        else
                        {
                            NSString *resultMsg = [returnData objectForKey:@"resultMsg"];
                            [XuUItlity showFailedHint:resultMsg?resultMsg:@"操作失败" completionBlock:nil];
                            return;
                        }
                    }

                    [weakSelf initData];
                }];

            }
        }];
        
    }
    else if ([type isEqualToString:@"1"])
    {
        UpdateCaseViewController *updateVC = [[UpdateCaseViewController alloc] init];
        updateVC.model = self.model;
        [self.navigationController pushViewController:updateVC animated:YES];
        
    }
    else if ([type isEqualToString:@"2"])
    {
        [XuUItlity showYesOrNoAlertView:@"确认" noText:@"取消" title:@"提示" mesage:@"确认退回案源吗，代理费用将不会退回" callback:^(NSInteger buttonIndex, NSString *inputString) {
            if (buttonIndex == 0) {
                
            }
            else{
            
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.caseId,@"caseId", nil];
                __weak typeof(*&self) weakSelf = self;
                [self.proxy backCaseSourceWithParams:params Block:^(id returnData, BOOL success) {
                    if (success) {
                        __weak typeof(*&self) weakSelf = self;
                        self.model.status = STATUS_0_INIT;
                        [XuUItlity showSucceedHint:@"退回成功" completionBlock:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                    else
                    {
                        [XuUItlity showFailedHint:@"操作失败" completionBlock:nil];
                    }
                    [weakSelf initData];
                }];
            }
        }];
    }

}

#pragma -mark ----Getter----

-(UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView  =[[UITableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT) style:UITableViewStylePlain];
        _orderTableView.delegate  = self;
        _orderTableView.dataSource  = self;
        _orderTableView.backgroundColor = kBaseViewBackgroundColor;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.tableFooterView = [UIView new];
    }
    return _orderTableView;
}

-(CaseSourceProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[CaseSourceProxy alloc] init];
        
    }
    return _proxy;
}

-(NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:5];
    }
    return _items;
}

@end
