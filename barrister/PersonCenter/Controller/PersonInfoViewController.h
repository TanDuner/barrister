//
//  PersonInfoViewController.h
//  barrister
//
//  Created by 徐书传 on 16/4/19.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PersonInfoViewController : BaseTableViewController

//页面来源 0 是从登录界面过来的 1是从个人中心点击进来的
@property (nonatomic,strong) NSString *fromType;

@end
