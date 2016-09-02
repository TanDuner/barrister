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
#define ChangeStatusUrl @"changeIMStatus.do"
#define CaseSourceUrl @"caseList.do"
#define SwitchUrl @"getLatestVersion.do"


#define MyCaseListUrl @"myCaseList.do"

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

-(void)getHomePageAccountDataWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];
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


/**
 *  设置接单状态接口
 *
 *  @param params
 *  @param aBlock
 */
-(void)setStatuWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];
    [XuNetWorking postWithUrl:ChangeStatusUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            aBlock(response,YES);
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }
    } fail:^(NSError *error) {
        aBlock(CommonNetErrorTip,NO);
    }];
}


/**
 *  案源列表
 *
 *  @param params
 *  @param aBlock
 */
-(void)getCaseListWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];
    [XuNetWorking postWithUrl:CaseSourceUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            aBlock(response,YES);
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }
    } fail:^(NSError *error) {
        aBlock(CommonNetErrorTip,YES);
    }];
}



/**
 *  获取开关数据
 *
 *  @param params
 *  @param aBlock
 */

-(void)getHidePayDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:SwitchUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            aBlock(response,YES);
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }
    } fail:^(NSError *error) {
        aBlock(CommonNetErrorTip,NO);
    }];
    
    
}



/**
 *  获取我的案源列表
 *
 *  @param params
 *  @param aBlock
 */
-(void)getMyCaseListWithParams:(NSMutableDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];
    [XuNetWorking postWithUrl:MyCaseListUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            aBlock(response,YES);
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }
    } fail:^(NSError *error) {
        aBlock(CommonNetErrorTip,YES);
    }];
}


@end
