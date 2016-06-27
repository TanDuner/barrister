//
//  HomeWaitHandleModel.h
//  barrister
//
//  Created by 徐书传 on 16/6/28.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"

//
//caseType = "";
//clientPhone = 18515058521;
//date = "";
//id = 2;
//nickname = "";
//status = "order.status.waiting";
//type = APPOINTMENT;
//userIcon = "";

@interface HomeWaitHandleModel : BaseModel

@property (nonatomic,strong) NSString *caseType;

@property (nonatomic,strong) NSString *clientPhone;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *waitHandleId;

@property (nonatomic,strong) NSString *nickname;

@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) NSString *type; //即时资讯还是预约咨询

@property (nonatomic,strong) NSString *userIcon;
@end
