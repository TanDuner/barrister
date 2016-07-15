//
//  HomePageProxy.h
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseNetProxy.h"

@interface HomePageProxy : BaseNetProxy

/**
 *  获取banner
 *
 *  @param params 请求参数
 *  @param aBlock 返回处理Block
 */
-(void)getHomePageBannerWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock;

/**
 *  获取首页账户信息接口
 *
 *  @param params 请求参数
 *  @param aBlock 返回处理Block
 */

-(void)getHomePageAccountDataWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock;


/**
 *  设置接单状态接口
 *
 *  @param params
 *  @param aBlock
 */
-(void)setStatuWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock;


/**
 *  案源列表
 *
 *  @param params
 *  @param aBlock
 */
-(void)getCaseListWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock;


/**
 *  获取开关数据
 *
 *  @param params
 *  @param aBlock
 */

-(void)getHidePayDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock;

@end
