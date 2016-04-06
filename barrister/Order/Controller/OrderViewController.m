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

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self loadItems];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ----UI------

-(void)configView
{

}

#pragma -mark -----Data------

-(void)loadItems
{
    /**
     造假数据
     
     - returns: <#return value description#>
     */
    
    BarristerOrderModel *model = [[BarristerOrderModel alloc] init];
    model.customerName = @"用户134****7654";
    model.userHeder = @"http://img4.duitang.com/uploads/item/201508/26/20150826212734_ST5BC.thumb.224_0.jpeg";
    model.startTime = @"2016/04/24 13:00";
    model.endTime = @"2016/03/24 14:00";
    model.orderType = @"债务纠纷";

    
    BarristerOrderModel *model1 = [[BarristerOrderModel alloc] init];
    model1.userHeder = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=327417392,2097894166&fm=116&gp=0.jpg";
    model1.customerName = @"用户158****0087";
    model1.startTime = @"2016/04/25 14:00";
    model1.endTime = @"2016/04/25 15:00";
    model1.orderType = @"财产纠纷";

    
    BarristerOrderModel *model2 = [[BarristerOrderModel alloc] init];
    model2.userHeder = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=731016823,2238050103&fm=116&gp=0.jpg";
    model2.customerName = @"用户186****7339";
    model2.startTime = @"2016/04/26 15:00";
    model2.endTime = @"2016/04/26 16:00";
    model2.orderType = @"民事案件";
    
    [self.items addObject:model];
    [self.items addObject:model1];
    [self.items addObject:model2];
    
    [self.tableView reloadData];
    
}


#pragma -mark -----UITableVIewDelegate Methods------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"orderCell";
    
    OrderViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[OrderViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    BarristerOrderModel *model =  (BarristerOrderModel *)[self.items objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
