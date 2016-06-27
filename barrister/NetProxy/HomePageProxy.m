//
//  HomePageProxy.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomePageProxy.h"

#define HomePageBannerUrl @"lunboAds.do"
#define HomePageAccountUrl @"userHome.do"

@implementation HomePageProxy

/**
 *  获取banner
 *
 *  @param params 请求参数
 *  @param aBlock 返回处理Block
 */

-(void)getHomePageBannerWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:HomePageBannerUrl params:params success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,YES);
        }
    }];
}


/**
 *  获取首页账户信息接口
 *
 *  @param params 请求参数
 *  @param aBlock 返回处理Block
 */

-(void)getHomePageAccountDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:HomePageAccountUrl params:params success:^(id response) {
        if ([response respondsToSelector:@selector(objectForKey:)]) {
            NSString *resultCode = [response objectForKey:@"resultCode"];

            if (aBlock) {
                if (resultCode.integerValue == 200) {
                    aBlock(response,YES);
                }
                else
                {
                    NSString *resultMsg = [response objectForKey:@"response"];
                    aBlock(resultMsg,NO);
                    
                }

            }

        }

    } fail:^(NSError *error) {
        
    }];
}

@end
