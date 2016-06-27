//
//  BizAreaModel.m
//  barrister
//
//  Created by 徐书传 on 16/6/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BizAreaModel.h"

@implementation BizAreaModel

-(id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super initWithDictionary:jsonObject]) {
        if ([jsonObject respondsToSelector:@selector(objectForKey:)]) {
            self.areaId = [jsonObject objectForKey:@"id"];
        }

    }
    return self;
}

@end
