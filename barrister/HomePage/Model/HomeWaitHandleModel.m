//
//  HomeWaitHandleModel.m
//  barrister
//
//  Created by 徐书传 on 16/6/28.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeWaitHandleModel.h"

@implementation HomeWaitHandleModel

-(id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super initWithDictionary:jsonObject]) {
    }
    return self;
}

-(void)handlePropretyWithDict:(NSDictionary *)jsonDict
{
    if ([jsonDict respondsToSelector:@selector(objectForKey:)]) {
        self.waitHandleId = [jsonDict objectForKey:@"id"];
    }

}

@end
