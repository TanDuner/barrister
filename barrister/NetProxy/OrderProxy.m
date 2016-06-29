//
//  OrderProxy.m
//  barrister
//
//  Created by 徐书传 on 16/5/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "OrderProxy.h"

#define GetOrderListUrl @"myOrderList.do"
#define OrderDetialUrl @"orderDetail.do"

@implementation OrderProxy
-(void)getOrderListWithParams:(NSDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:GetOrderListUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                NSArray *array = [response objectForKey:@"orders"];
                if ([XuUtlity isValidArray:array]) {
                    aBlock(array,YES);
                }
                else
                {
                    aBlock(@[],YES);
                }
                
            }

        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(CommonNetErrorTip,NO);
        }
    }];
}

/**
 *  获取订单详情
 *
 *  @param aParams <#aParams description#>
 *  @param aBlock  <#aBlock description#>
 */
-(void)getOrderDetailWithParams:(NSDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:OrderDetialUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                NSDictionary *dict = (NSDictionary *)response;
                NSDictionary *orderDetail = [dict objectForKey:@"orderDetail"];
                aBlock(orderDetail,YES);
            }
            else
            {
                aBlock(CommonNetErrorTip,NO);
            }
            
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(CommonNetErrorTip,NO);
        }
    }];
}

@end
