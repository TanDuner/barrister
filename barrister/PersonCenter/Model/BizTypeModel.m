//
//  BizTypeModel.m
//  barrister
//
//  Created by 徐书传 on 16/6/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BizTypeModel.h"

@implementation BizTypeModel

-(id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super initWithDictionary:jsonObject]) {
        if ([jsonObject respondsToSelector:@selector(objectForKey:)]) {
            self.typeId = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"id"]];
        }
        
    }
    return self;
}

@end
