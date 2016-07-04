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
#define AddXiaoJieUrl @"addOrderFeedback.do"
#define AgreeCancelOrderUrl @"agreeOrderCancel.do"
#define unAgreeCancelOrderUrl @"disagreeOrderCancel.do"
#define FinishOrderUrl @"finishOrder.do"

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


/**
 *  律师填写小节
 *
 *  @param aParams <#aParams description#>
 *  @param aBlock  <#aBlock description#>
 */
-(void)addXiaoJieWithParams:(NSDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:AddXiaoJieUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
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


/**
 *  同意取消订单
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)agreeCancelOrderWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:AgreeCancelOrderUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
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


/**
 *  不同意取消订单
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)unAgreeCancelOrderWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock
{

    [XuNetWorking postWithUrl:unAgreeCancelOrderUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
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



/**
 *  完成订单
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)finishOrderWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:unAgreeCancelOrderUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
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
