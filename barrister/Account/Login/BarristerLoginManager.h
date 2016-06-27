//
//  BarristerLoginManager.h
//  barrister2c
//
//  Created by 徐书传 on 16/6/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface BarristerLoginManager : NSObject

@property (nonatomic,strong) BaseViewController *showController;

/**
 *  单利对象
 *
 *  @return
 */
+ (BarristerLoginManager *)shareManager;

-(void)showLoginViewControllerWithController:(BaseViewController *)showController;

/**
 *  消失登录界面 并且打开一个新的界面
 */

-(void)hideLoginViewController:(BaseViewController *)baseViewController isToPersonInfoVC:(BOOL)isToPersonInfoVC;

/**
 *  自动登录 从userDefault 里取
 */

-(void)userAutoLogin;

@end
