//
//  BarristerOrderDetailModel.m
//  barrister
//
//  Created by 徐书传 on 16/6/28.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerOrderDetailModel.h"

@implementation BarristerOrderDetailModel


-(void)handlePropretyWithDict:(NSDictionary *)dict
{
    if ([dict respondsToSelector:@selector(objectForKey:)]) {
        self.orderId = [dict objectForKey:@"id"];
        CGFloat height = [XuUtlity textHeightWithString:self.remarks withFont:SystemFont(14.0f) sizeWidth:SCREENWIDTH - 20 WithLineSpace:5];
        
        if (height <= 13) {
            height = 13;
        }
        self.markHeight = height;
        
        self.orderId = [dict objectForKey:@"id"];
    
    }

}

@end
