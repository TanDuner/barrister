//
//  OrderDetailViewController.m
//  barrister
//
//  Created by 徐书传 on 16/4/11.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailOrderCell.h"
#import "OrderDetailCustomInfoCell.h"
#import "OrderDetailCallRecordCell.h"
#import "OrderProxy.h"
#import "BarristerOrderDetailModel.h"
#import "OrderDetailFinishCell.h"
#import "OrderDetailCancelCell.h"
#import "OrderDetailMarkCell.h"
#import "AddOrderFeedBackViewController.h"

/**
 * 用于显示Detail的类型
 */

typedef NS_ENUM(NSInteger,OrderDetailShowType)
{
    OrderDetailShowTypeOrderInfo,
    OrderDetailShowTypeOrderMark,
    OrderDetailShowTypeOrderCancelOrder,
    OrderDetailShowTypeOrderFinishOrder,
    OrderDetailShowTypeOrderCustomInfo,
    OrderDetailShowTypeOrderCallRecord,
};



@interface OrderDetailCellModel : NSObject

@property (nonatomic,assign) OrderDetailShowType showType;

@end

@implementation OrderDetailCellModel


@end






@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BarristerOrderDetailModel *model;
}

@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSString *orderId;

@end


 ////////////// ////////////// ////////////// ////订单详情////////// ////////////// //////////////

@interface OrderDetailViewController ()

@property (nonatomic,strong) OrderProxy *proxy;

@end


@implementation OrderDetailViewController

-(id)initWithModel:(BarristerOrderModel *)orderModel
{
    if (self  =[super init]) {
        self.orderId = orderModel.orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self initData];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

#pragma -mark ---------UI----------

-(void)configView
{
    self.title = @"订单详情";
    
    [self.view addSubview:self.orderTableView];
    
}

#pragma -mark -------Data----------

-(void)initData
{
    self.items = [NSMutableArray arrayWithCapacity:1];
    NSMutableDictionary *aParams = [NSMutableDictionary dictionary];
    if (self.orderId.length != 0) {
        [aParams setObject:self.orderId forKey:@"orderId"];
    }
    else
    {
        //没有订单id 进入详情
        [XuUItlity showFailedHint:@"数据异常" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    
    __weak typeof(*&self) weakSelf = self;
    [self.proxy getOrderDetailWithParams:aParams Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            model = [[BarristerOrderDetailModel alloc] initWithDictionary:dict];
        
            [weakSelf configData];
        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败" completionBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    
}

-(void)configData
{
    OrderDetailCellModel *model1 = [[OrderDetailCellModel alloc] init];
    model1.showType = OrderDetailShowTypeOrderInfo;
    [self.items addObject:model1];

    OrderDetailCellModel *model2 = [[OrderDetailCellModel alloc] init];
    model2.showType = OrderDetailShowTypeOrderMark;
    [self.items addObject:model2];

    if ([model.status isEqualToString:STATUS_REQUESTCANCEL]) {
        OrderDetailCellModel *model3 = [[OrderDetailCellModel alloc] init];
        model3.showType = OrderDetailShowTypeOrderCancelOrder;
        [self.items addObject:model3];
    }


    if ([model.status isEqualToString:STATUS_DOING]) {
        OrderDetailCellModel *model4 = [[OrderDetailCellModel alloc] init];
        model4.showType = OrderDetailShowTypeOrderFinishOrder;
        [self.items addObject:model4];
    }

    
    OrderDetailCellModel *model5 = [[OrderDetailCellModel alloc] init];
    model5.showType = OrderDetailShowTypeOrderCustomInfo;
    [self.items addObject:model5];
    
    if (model.callRecordArray.count > 0) {
        OrderDetailCellModel *model6 = [[OrderDetailCellModel alloc] init];
        model6.showType = OrderDetailShowTypeOrderCallRecord;
        [self.items addObject:model6];
        
    }

    
    [self.orderTableView reloadData];
    
    if ([model.status isEqualToString:STATUS_DONE]) {
        [self initNavigationRightTextButton:@"总结" action:@selector(addFeedBack)];
    }



}


#pragma -mark -------Aciton------

-(void)handleCancelOrderWithBtnType:(NSString *)btnType
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak typeof(*&self) weakSelf = self;
    [params setObject:model.orderId forKey:@"orderId"];
    if ([btnType isEqualToString:@"同意"]) {
        [self.proxy agreeCancelOrderWithParams:params Block:^(id returnData, BOOL success) {
            if (success) {
                [XuUItlity showSucceedHint:@"取消成功" completionBlock:nil];
            }
            else
            {
                [XuUItlity showFailedHint:@"取消失败" completionBlock:nil];
            }
            
            [weakSelf initData];
            
        }];
    }
    else
    {
        [self.proxy unAgreeCancelOrderWithParams:params Block:^(id returnData, BOOL success) {
            if (success) {
                [XuUItlity showSucceedHint:@"拒绝成功" completionBlock:nil];
            }
            else
            {
                [XuUItlity showFailedHint:@"拒绝失败" completionBlock:nil];
            }
            [weakSelf initData];
        }];
    }

}


-(void)handleFinishOrderAciton
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak typeof(*&self) weakSelf = self;
    [params setObject:model.orderId forKey:@"orderId"];
    
    [self.proxy agreeCancelOrderWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            [XuUItlity showSucceedHint:@"取消成功" completionBlock:nil];
        }
        else
        {
            [XuUItlity showFailedHint:@"取消失败" completionBlock:nil];
        }
        
        [weakSelf initData];
        
    }];
}


-(void)addFeedBack
{
    AddOrderFeedBackViewController *addFeedBackVC = [[AddOrderFeedBackViewController alloc] init];
    addFeedBackVC.orderId = model.orderId;
    [self.navigationController pushViewController:addFeedBackVC animated:YES];
}


#pragma -mark --------UITableView DataSource Methods------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCellModel *modeTemp = (OrderDetailCellModel *)[self.items objectAtIndex:indexPath.row];
    __weak typeof(*&self) weakSelf = self;

    switch (modeTemp.showType) {
        case 0:
        {
           OrderDetailOrderCell * cellTemp = [[OrderDetailOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            cellTemp.model = model;
            return cellTemp;
        }
            break;
            
        case 1:
        {
            OrderDetailMarkCell *cellTemp = [[OrderDetailMarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.model = model;
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTemp;
        }
            break;
        case 2:
        {
            OrderDetailCancelCell *cellTemp = [[OrderDetailCancelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.block = ^(NSString *btnType)
            {
                [weakSelf handleCancelOrderWithBtnType:btnType];
            };
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            cellTemp.model = model;
            return cellTemp;
        }
            break;
        case 3:
        {
            OrderDetailFinishCell *cellTemp = [[OrderDetailFinishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.block = ^()
            {
                [weakSelf handleFinishOrderAciton];
            };
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            cellTemp.model = model;
            return cellTemp;
        }
            break;

        case 4:
        {
            OrderDetailCustomInfoCell * cellTemp = [[OrderDetailCustomInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.model = model;
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTemp;

        }
            break;
        case 5:
        {
            OrderDetailCallRecordCell *cellTemp = [[OrderDetailCallRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.model = model;
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTemp;
        }

            break;
            
        default:
        {
            return [UITableViewCell new];
        }
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    OrderDetailCellModel *modelTemp = (OrderDetailCellModel *)[self.items objectAtIndex:indexPath.row];
    switch (modelTemp.showType) {
        case OrderDetailShowTypeOrderInfo:
        {
            return [OrderDetailOrderCell getHeightWithModel:model];
        }
            break;
        case OrderDetailShowTypeOrderMark:
        {
            return [OrderDetailMarkCell getCellHeightWithModel:model];
        }
            break;
        case OrderDetailShowTypeOrderCancelOrder:
        {
            if ([model.status isEqualToString:STATUS_REQUESTCANCEL]) {
                return [OrderDetailCancelCell getCellHeight];
            }
            else
            {
                return 0;
            }
        }
            break;
        case OrderDetailShowTypeOrderFinishOrder:
        {
            if ([model.status isEqualToString:STATUS_DOING]) {
                return [OrderDetailFinishCell getCellHeight];
            }
            else
            {
                return 0;
            }
        }
            break;
        case OrderDetailShowTypeOrderCustomInfo:
        {
            return [OrderDetailCustomInfoCell getHeightWithModel:model];
        }
        case OrderDetailShowTypeOrderCallRecord:
        {
            if (model.callRecordArray.count > 0) {
                return [OrderDetailCallRecordCell getHeightWithModel:model];
            }
            else
            {
                return 0;
            }
        }
            
        default:
        {
            return 0;
        }
            break;
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

-(OrderProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[OrderProxy alloc] init];
        
    }
    return _proxy;
}

@end
