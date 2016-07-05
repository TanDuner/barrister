//
//  BaseNetProxy.h
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XuNetWorking.h"
#define CommonNetErrorTip @"网络错误,请稍后再试"

typedef void(^ServiceCallBlock)(id returnData, BOOL success);

@interface BaseNetProxy : NSObject

-(void)appendCommonParamsWithDict:(NSMutableDictionary *)params;


-(NSString *)appendUrlWithString:(NSString *)urlString;

-(BOOL)isCommonCorrectResultCodeWithResponse:(id)response;

@end
