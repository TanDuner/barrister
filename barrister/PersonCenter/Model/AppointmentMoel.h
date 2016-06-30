//
//  AppointmentMoel.h
//  barrister
//
//  Created by 徐书传 on 16/6/30.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

@interface AppointmentMoel : BaseModel

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *settings;

@property (nonatomic,strong) NSMutableArray *settingArray;

-(void)replaceStringWithArrayIndex:(NSInteger)index withStatus:(NSString *)status;

@end
