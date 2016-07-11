//
//  BarristerOrderModel.m
//  barrister
//
//  Created by 徐书传 on 16/4/6.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerOrderModel.h"

@implementation BarristerOrderModel

-(id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super initWithDictionary:jsonObject]) {
    }
    return self;
}

-(void)handlePropretyWithDict:(NSDictionary *)jsonObject
{
    if ([jsonObject respondsToSelector:@selector(objectForKey:)]) {
        
        self.orderId = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"id"]];
        if (!self.nickname) {
            self.nickname = [NSString stringWithFormat:@"用户：%@",self.clientPhone];
        }
    }
}

@end
