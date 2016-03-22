//
//  BaseTabbarController.h
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabbarController : UITabBarController

- (void)selectViewController:(UIViewController *)viewController;

- (void)setPromptNum:(NSInteger)num onTabbarItem:(NSInteger)index;
- (void)selectTab:(NSInteger)index;
- (void)selectButtonAtIndex:(NSUInteger)index;

- (void) hideTabBar:(BOOL) hidden;

@end
