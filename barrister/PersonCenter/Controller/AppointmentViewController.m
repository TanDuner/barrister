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
#import "AppointContentViewController.h"

@interface AppointmentViewController ()

@property (nonatomic,strong) NinaPagerView *topSlideView;

@property (nonatomic,strong) NSMutableArray *VCArrays;

@property (nonatomic,strong) MeNetProxy *proxy;

@property (nonatomic,strong) NinaPagerView *ninaPagerView;

@end

@implementation AppointmentViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configView];
    
    [self configData];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

#pragma -
#pragma -mark make UI


-(void)configView
{
    self.title = @"预约设置";
}

#pragma -mark make Data


-(void)configData
{
    [self createTopSlideView];

    [_proxy getAppointDataWithParams:nil Block:^(id returnData, BOOL success) {
        if (success) {
//            [self createTopSlideView];
            
        }
    }];
}

-(void)createTopSlideView
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"2016-05-01",@"2016-05-02",@"2016-05-03",@"2016-05-04",@"2016-05-05",@"2016-05-06",@"2016-05-07", nil];
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < titleArray.count; i ++) {
        AppointContentViewController *contentVC = [[AppointContentViewController alloc] init];
        [vcArray addObject:contentVC];
    }
    
    NSArray *colorArray = @[
                            [UIColor brownColor], /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor grayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            [UIColor redColor], /**< 下划线颜色 Underline Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];

    _ninaPagerView = [[NinaPagerView alloc] initWithTitles:titleArray WithVCs:vcArray WithColorArrays:colorArray];
    [self.view addSubview:_ninaPagerView];

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
