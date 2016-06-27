//
//  BarristerUserModel.m
//  barrister
//
//  Created by 徐书传 on 16/5/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerUserModel.h"

@implementation BarristerUserModel

-(id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super initWithDictionary:jsonObject]) {
        [self handlePropretyWithDict:jsonObject];
    }
    return self;
}

-(void)handlePropretyWithDict:(NSDictionary *)jsoObject
{
    self.userId = [jsoObject objectForKey:@"id"];
    
}

@end
