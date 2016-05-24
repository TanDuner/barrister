//
//  BarristerUserModel.h
//  barrister
//
//  Created by 徐书传 on 16/5/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

@interface BarristerUserModel : BaseModel

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *verifyCode;

@end
