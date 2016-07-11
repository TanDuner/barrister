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
#import "AppointmentManager.h"

@interface AppointmentViewController ()

@property (nonatomic,strong) NinaPagerView *topSlideView;

@property (nonatomic,strong) NSMutableArray *VCArrays;

@property (nonatomic,strong) MeNetProxy *proxy;

@property (nonatomic,strong) NinaPagerView *ninaPagerView;

@property (nonatomic,strong) NSMutableArray *dateStrArray;

@end

@implementation AppointmentViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configView];
    
    //初始化数组
    [AppointmentManager shareInstance];
    
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
    
    [self initNavigationRightTextButton:@"确定" action:@selector(confirmAciton)];
}

#pragma -mark make Data


-(void)configData
{
    [self createTopSlideView];

    __weak typeof(*&self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode",[XuUtlity stringFromDate:[NSDate date] forDateFormatterStyle:DateFormatterDate],@"date", nil];
    [self.proxy getAppointDataWithParams:params Block:^(id returnData, BOOL success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            NSArray *array = [dict objectForKey:@"appointmentSettings"];
            if ([XuUtlity isValidArray:array]) {
                [strongSelf handleAppointmentDataWithArray:array];
            }
            else
            {
                [strongSelf handleAppointmentDataWithArray:@[]];
            }
        }
        else
        {
            [XuUItlity showFailedHint:@"获取设置信息失败" completionBlock:nil];
        }
    }];
}



-(void)handleAppointmentDataWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = (NSDictionary *)[array safeObjectAtIndex:i];
        
        AppointmentMoel *model = [[AppointmentMoel alloc] initWithDictionary:dict];
        
        for (int j = 0; j < [AppointmentManager shareInstance].modelArray.count; j ++) {
            AppointmentMoel *modelTemp = [[AppointmentManager shareInstance].modelArray safeObjectAtIndex:j];
            if ([modelTemp.date isEqualToString:model.date]) {
                [[AppointmentManager shareInstance].modelArray replaceObjectAtIndex:j withObject:model];
            }
        }
    }
    
    [self createTopSlideView];
}






-(void)createTopSlideView
{
    if ([AppointmentManager shareInstance].modelArray.count != 7) {
        return;
    }
    
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *titleArray  = [NSMutableArray arrayWithCapacity:7];
    
    for (int i = 0; i < [AppointmentManager shareInstance].modelArray.count; i ++) {
        
        AppointmentMoel *modelTemp = (AppointmentMoel *)[[AppointmentManager shareInstance].modelArray safeObjectAtIndex:i];
        AppointContentViewController *contentVC = [[AppointContentViewController alloc] init];
        contentVC.model = modelTemp;
        [titleArray addObject:modelTemp.date];
        [vcArray addObject:contentVC];
        
    }
    
    NSArray *colorArray = @[
                            kNavigationBarColor, /**< 选中的标题颜色 Title SelectColor  **/
                            KColorGray666, /**< 未选中的标题颜色  Title UnselectColor **/
                            kNavigationBarColor, /**< 下划线颜色 Underline Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];

    _ninaPagerView = [[NinaPagerView alloc] initWithTitles:titleArray WithVCs:vcArray WithColorArrays:colorArray];
    [self.view addSubview:_ninaPagerView];

}


#pragma -mark ---Aciton----
//提交预约数据
-(void)confirmAciton
{
    __weak typeof(*&self) weakSelf = self;
   NSMutableDictionary *params = [self appendParams];
    [XuUItlity showLoading:@"正在设置..."];
    [self.proxy setAppintDataWithParams:params Block:^(id returnData, BOOL success) {
        [XuUItlity hideLoading];
        if (success) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [XuUItlity showSucceedHint:@"设置成功" completionBlock:^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [XuUItlity showFailedHint:@"设置失败" completionBlock:nil];
        }
    }];
    
}


-(NSMutableDictionary *)appendParams
{
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    

    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 0; i < [AppointmentManager shareInstance].modelArray.count; i ++) {
        AppointmentMoel *model = (AppointmentMoel *)[[AppointmentManager shareInstance].modelArray safeObjectAtIndex:i];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model.date,@"date",model.settings,@"value", nil];
        
        [array addObject:dict];
    }
    
    NSString *str =  [[AppointmentManager shareInstance] objectToJsonStr:array];
    
    
    [returnDict setObject:str forKey:@"settings"];
    [returnDict setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [returnDict setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
    
    return returnDict;
    
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
