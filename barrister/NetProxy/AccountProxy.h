//
//  AccountProxy.h
//  barrister
//
//  Created by 徐书传 on 16/5/30.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseNetProxy.h"

@interface AccountProxy : BaseNetProxy
/**
 *  获取账户明细接口
 *
 *  @param params 请求参数
 *  @param aBlock 返回处理Block
 */

-(void)getAccountDetailDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock;

@end
