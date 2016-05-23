//
//  TiXianViewControlleer.m
//  barrister
//
//  Created by 徐书传 on 16/5/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "TiXianViewControlleer.h"

@implementation TiXianViewControlleer

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
}
@end
