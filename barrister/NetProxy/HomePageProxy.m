//
//  HomePageProxy.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomePageProxy.h"

#define HomePageBannerUrl @""

@implementation HomePageProxy

-(void)HomePageGetBannerDataWithParams:(NSDictionary *)dict
{
    [XuNetWorking getWithUrl:HomePageBannerUrl params:dict success:^(id response) {
        
    } fail:^(NSError *error) {
        
    }];
}
@end
