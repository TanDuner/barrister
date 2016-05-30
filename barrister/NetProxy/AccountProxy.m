//
//  AccountProxy.m
//  barrister
//
//  Created by 徐书传 on 16/5/30.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AccountProxy.h"

#define AccountDetialUrl @""

@implementation AccountProxy

-(void)getAccountDetailDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:AccountDetialUrl params:params success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,YES);
        }

    }];
}

@end
