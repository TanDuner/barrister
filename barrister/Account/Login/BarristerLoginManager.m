//
//  BarristerLoginManager.m
//  barrister2c
//
//  Created by 徐书传 on 16/6/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerLoginManager.h"
#import "BaseNavigaitonController.h"
#import "BarristerLoginVC.h"
#import "PersonInfoViewController.h"
#import "LoginProxy.h"
#import "CommonMacros.h"

@interface BarristerLoginManager ()

@property (nonatomic,strong) LoginProxy *proxy;

@end


@implementation BarristerLoginManager


+ (BarristerLoginManager *)shareManager
{
    static BarristerLoginManager *staticManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        staticManager = [[self alloc] init];
    });
    
    return staticManager;
}

-(void)showLoginViewControllerWithController:(BaseViewController *)showController
{
    BarristerLoginVC *loginVC = [[BarristerLoginVC alloc] init];
    
    self.showController = showController;
    
    BaseNavigaitonController *navigationVC = [[BaseNavigaitonController alloc] initWithRootViewController:loginVC];
    
    [showController.navigationController presentViewController:navigationVC animated:YES completion:nil];

}


-(void)hideLoginViewController:(BaseViewController *)baseViewController isToPersonInfoVC:(BOOL)isToPersonInfoVC
{
    if ([baseViewController isKindOfClass:[BarristerLoginVC class]]) {
        [baseViewController dismissViewControllerAnimated:YES completion:^{
            if (isToPersonInfoVC) {
                PersonInfoViewController *personInfo = [[PersonInfoViewController alloc] init];
                BaseNavigaitonController  *nav = [[BaseNavigaitonController alloc] initWithRootViewController:personInfo];
                personInfo.fromType = @"0";
                [self.showController.navigationController presentViewController:nav animated:YES completion:nil];
            }
        }];
    }
}

-(void)userAutoLogin
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *verfyCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone",verfyCode,@"verifyCode", nil];
    [self.proxy loginWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            if (dict && [dict respondsToSelector:@selector(objectForKey:)]) {
                NSDictionary *userDict = [dict objectForKey:@"user"];
                if ([userDict respondsToSelector:@selector(objectForKey:)]) {
                    BarristerUserModel *user = [[BarristerUserModel alloc] initWithDictionary:userDict];
                    [BaseDataSingleton shareInstance].userModel = user;
                    [[BaseDataSingleton shareInstance] setLoginStateWithValidCode:user.verifyCode Phone:user.phone];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:nil];
                }

            }

        }
        else
        {
            [BaseDataSingleton shareInstance].userModel.verifyCode = nil;
            [BaseDataSingleton shareInstance].loginState = @"0";
            [BaseDataSingleton shareInstance].userModel = nil;
            [[BarristerLoginManager shareManager] showLoginViewControllerWithController:self.showController];
            
        }
    }];
}

#pragma -mark ---Getter---

-(LoginProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[LoginProxy alloc] init];
    }
    return _proxy;
}


@end
