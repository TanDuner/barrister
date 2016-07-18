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
    }
    return self;
}

-(void)handlePropretyWithDict:(NSDictionary *)jsoObject
{
    self.userId = [NSString stringWithFormat:@"%@",[jsoObject objectForKey:@"id"]];
    
    if (self.orderCount == 0) {
        self.stars = 5;
    }
    else
    {
        self.stars = self.startCount.floatValue/(self.orderCount.floatValue + 1);
    }

    if (self.stars > 5) {
        self.stars = 5;
    }
    
}

@end
