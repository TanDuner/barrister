//
//  BaseNetProxy.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseNetProxy.h"
#define BaseDomainUrl @""

@implementation BaseNetProxy

-(NSString *)appendUrlWithString:(NSString *)urlString
{
    NSString *retString = [NSString stringWithFormat:@"%@%@",BaseDomainUrl,urlString];
    return retString;
}

@end
