//
//  AppointmentViewController.m
//  barrister
//
//  Created by 徐书传 on 16/4/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AppointmentViewController.h"
#import "NinaPagerView.h"
#import "MeNetProxy.h"

@interface AppointmentViewController ()

@property (nonatomic,strong) NinaPagerView *topSlideView;

@property (nonatomic,strong) NSMutableArray *VCArrays;

@property (nonatomic,strong) MeNetProxy *proxy;

@end

@implementation AppointmentViewController
-(void)viewDidLoad{
    
    [super viewDidLoad];

    [self configData];

}

#pragma -
#pragma -mark make UI


-(void)configView
{
    
}

#pragma -mark make Data


-(void)configData
{
    [_proxy getAppointDataWithParams:nil Block:^(id returnData, BOOL success) {
        if (success) {
            [self createTopSlideView];
            
        }
    }];
}

-(void)createTopSlideView
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"2016-05-01",@"2016-05-02",@"2016-05-03",@"2016-05-04",@"2016-05-05", nil];
    
    for (NSString *str in titleArray) {
        
    }
}


#pragma -mark -----Getter-------

-(NSMutableArray *)VCArrays
{
    if (!_VCArrays) {
        _VCArrays = [NSMutableArray arrayWithCapacity:10];
    }
    return _VCArrays;
}

-(MeNetProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[MeNetProxy alloc] init];
    }
    return _proxy;
}

@end
