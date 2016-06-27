//
//  BaseAppointmentModel.m
//  barrister2c
//
//  Created by 徐书传 on 16/6/24.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseAppointmentModel.h"

@implementation BaseAppointmentModel


+ (nonnull instancetype)shareInstance;
{
    static BaseAppointmentModel *dataSingleTon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSingleTon = [[self alloc] init];
    });
    
    return dataSingleTon;
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic;

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
