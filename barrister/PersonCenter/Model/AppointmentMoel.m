//
//  AppointmentMoel.m
//  barrister
//
//  Created by 徐书传 on 16/6/30.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AppointmentMoel.h"

@implementation AppointmentMoel


-(void)setSettings:(NSString *)settings
{
    _settings = settings;
    self.settingArray = [NSMutableArray arrayWithArray:[_settings componentsSeparatedByString:@","]];
    
}


-(void)replaceStringWithArrayIndex:(NSInteger)index withStatus:(NSString *)status
{

    NSInteger location = index *2;

    NSRange range = NSMakeRange(location, 1);
    
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.settings];
    
    [str replaceCharactersInRange:range withString:status];
    
    
    self.settings = [NSString stringWithFormat:@"%@",str];
    
    
}

//-(void)arrayToSettingStr:(NSMutableArray *)settingAry
//{
//    
//    NSMutableString *str;
//    str replaceCharactersInRange:<#(NSRange)#> withString:<#(nonnull NSString *)#>
//    
//    
//    NSString *settingString = @"";
//    for (int i = 0; i < settingAry.count; i ++) {
//        NSString *str = [settingAry objectAtIndex:i];
//        settingString  = [NSString stringWithFormat:@"%@,%@",settingString,str];
//    }
//    if ([settingString hasSuffix:@","]) {
//        settingString = [settingString substringToIndex:settingString.length - 1];
//    }
//    self.settings = settingString;
//}
@end
