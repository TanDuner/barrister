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
#import "VolumePlayHelper.h"

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


#import "CallHistoriesModel.h"

@interface OrderDetailCellModel : NSObject

@property (nonatomic) CallHistoriesModel *callModel;

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

-(id)initWithOrderId:(NSString  *)orderId;
{
    if (self  =[super init]) {
        self.orderId = orderId;
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[VolumePlayHelper PlayerHelper] audioPlayerStop];
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
    [XuUItlity showLoadingInView:self.view hintText:@"加载中..."];
    [self.proxy getOrderDetailWithParams:aParams Block:^(id returnData, BOOL success) {
        [XuUItlity hideLoading];
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


    if ([model.status isEqualToString:STATUS_DOING] && model.callRecordArray.count > 0) {
        OrderDetailCellModel *model4 = [[OrderDetailCellModel alloc] init];
        model4.showType = OrderDetailShowTypeOrderFinishOrder;
        [self.items addObject:model4];
    }

    
    OrderDetailCellModel *model5 = [[OrderDetailCellModel alloc] init];
    model5.showType = OrderDetailShowTypeOrderCustomInfo;
    [self.items addObject:model5];
    
    if ([XuUtlity isValidArray:model.callRecordArray]) {
        if (model.callRecordArray.count > 0) {
            
            for (int i = 0; i < model.callRecordArray.count; i ++) {
                
                CallHistoriesModel *modelTemp = [model.callRecordArray safeObjectAtIndex:i];
                modelTemp.index = i;
                OrderDetailCellModel *model6 = [[OrderDetailCellModel alloc] init];
                model6.showType = OrderDetailShowTypeOrderCallRecord;
                model6.callModel = modelTemp;
                [self.items addObject:model6];
                
            }
            
        }
        
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
        [XuUItlity showYesOrNoAlertView:@"确定" noText:@"取消" title:@"提示" mesage:@"确认同意请求吗" callback:^(NSInteger buttonIndex, NSString *inputString) {
            if (buttonIndex == 0) {
                
            }
            else
            {
                [weakSelf.proxy agreeCancelOrderWithParams:params Block:^(id returnData, BOOL success) {
                    if (success) {
                        [XuUItlity showSucceedHint:@"操作成功" completionBlock:nil];
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
    else
    {
        [XuUItlity showYesOrNoAlertView:@"确定" noText:@"取消" title:@"提示" mesage:@"确认拒绝请求吗" callback:^(NSInteger buttonIndex, NSString *inputString) {
            if (buttonIndex == 0) {
                
            }
            else
            {
                [weakSelf.proxy unAgreeCancelOrderWithParams:params Block:^(id returnData, BOOL success) {
                    if (success) {
                        [XuUItlity showSucceedHint:@"操作成功 请及时联系客户" completionBlock:nil];
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


-(void)handleFinishOrderAciton
{
    
    if (model.callRecordArray.count == 0) {
        [XuUItlity showAlertHint:@"您还没有与客户联系，不可以完成订单哦" completionBlock:nil andView:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak typeof(*&self) weakSelf = self;
    [params setObject:model.orderId forKey:@"orderId"];
    
    [XuUItlity showYesOrNoAlertView:@"确定" noText:@"取消" title:@"提示" mesage:@"确认完成订单吗" callback:^(NSInteger buttonIndex, NSString *inputString) {
        if (buttonIndex == 0) {
            
        }
        else
        {
            [weakSelf.proxy finishOrderWithParams:params Block:^(id returnData, BOOL success) {
                if (success) {
                    [XuUItlity showSucceedHint:@"操作成功，请及时对此订单做出总结" completionBlock:nil];
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


-(void)addFeedBack
{
    AddOrderFeedBackViewController *addFeedBackVC = [[AddOrderFeedBackViewController alloc] init];
    addFeedBackVC.orderId = model.orderId;
    [self.navigationController pushViewController:addFeedBackVC animated:YES];
}

-(void)callAction:(UIButton *)btn
{
    
    if ([model.status isEqualToString:STATUS_DONE]) {
        [self makeToast:@"已完成订单不可以再拨打电话了哦~" duration:1];
        return;
    }
    NSDate *startDate = [XuUtlity NSStringDateToNSDate:model.startTime forDateFormatterStyle:DateFormatterDateAndTime];
    double startNum = [startDate timeIntervalSince1970];
    
    double nowNum = [[NSDate date] timeIntervalSince1970];
    if (nowNum > startNum) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:model.orderId,@"orderId", nil];
        [self.proxy makeCallWithParams:params Block:^(id returnData, BOOL success) {
            if (success) {
                [XuUItlity showAlertHint:@"已拨通 等待回拨" completionBlock:nil andView:self.view];
            }
            else
            {
                [XuUItlity showFailedHint:@"拨打失败" completionBlock:nil];
            }
            
        }];

    }
    else
    {
        [XuUItlity showFailedHint:@"不在约定时间内" completionBlock:nil];
    }
    
}


#pragma -mark --------UITableView DataSource Methods------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCellModel *modeTemp = (OrderDetailCellModel *)[self.items safeObjectAtIndex:indexPath.row];
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
            [cellTemp.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
            cellTemp.model = model;
            cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTemp;

        }
            break;
        case 5:
        {
            OrderDetailCallRecordCell *cellTemp = [[OrderDetailCallRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cellTemp.model = modeTemp.callModel;
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

    OrderDetailCellModel *modelTemp = (OrderDetailCellModel *)[self.items safeObjectAtIndex:indexPath.row];
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
                return [OrderDetailCallRecordCell getHeightWithModel:modelTemp.callModel];
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
