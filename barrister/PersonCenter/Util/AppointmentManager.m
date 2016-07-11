//
//  AppointmentManager.m
//  barrister
//
//  Created by 徐书传 on 16/6/30.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AppointmentManager.h"

@implementation AppointmentManager


+ (nonnull instancetype)shareInstance;
{
    static AppointmentManager *dataSingleTon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSingleTon = [[self alloc] init];
        [dataSingleTon initData];
    });
    
    return dataSingleTon;
}


-(void)initData
{
    NSMutableArray *dateStrArray = [self getDateStrArraySinceDate:[NSDate date]];
    NSMutableArray *settingStrArray  = [self getDateSettingStrArray];
    
    if (dateStrArray.count == settingStrArray.count) {
        for (int i = 0; i <dateStrArray.count; i ++) {
            NSString *dateStr  =[dateStrArray safeObjectAtIndex:i];
            NSString *settingStr = [settingStrArray safeObjectAtIndex:i];
            AppointmentMoel *model = [[AppointmentMoel alloc] init];
            model.date  = dateStr;
            model.settings = settingStr;
            [self.modelArray addObject:model];
        }
    }

}


-(NSMutableArray *)getDateStrArraySinceDate:(NSDate *)date
{
    NSMutableArray *retunrArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 7; i ++) {
        NSString *dateStr = [XuUtlity stringFromDate:date forDateFormatterStyle:DateFormatterDate];
        [retunrArray addObject:dateStr];
        date = [NSDate dateWithTimeInterval:86400 sinceDate:date];
    }
    
    return retunrArray;
}


-(NSMutableArray *)getDateSettingStrArray
{
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:7];
    for ( int i = 0; i < 7; i ++) {
        NSString *settingStr = @"";
        for (int j = 0; j < 36 ; j++) {
            settingStr = [settingStr stringByAppendingString:@",1"];
        }
        if ([settingStr hasPrefix:@","]) {
            settingStr = [settingStr substringFromIndex:1];
        }
        [returnArray addObject:settingStr];
    }
    return returnArray;
}




-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray arrayWithCapacity:7];
    }
    return _modelArray;
}

-(nullable NSString *)objectToJsonStr:(nullable id )object

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
