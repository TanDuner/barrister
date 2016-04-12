//
//  BarristerOrderModel.h
//  barrister
//
//  Created by 徐书传 on 16/4/6.
//  Copyright © 2016年 Xu. All rights reserved.
//


/**
 *  订单model 公共Model
 */

#import "BaseModel.h"


typedef NS_ENUM(NSInteger, BarristerOrderType)
{
    BarristerOrderTypeJSZX,
    BarristerOrderTypeYYZX,
};



@interface BarristerOrderModel : BaseModel

@property (nonatomic,strong) NSString *customerName;

@property (nonatomic,strong) NSString *orderId;

@property (nonatomic,assign) BarristerOrderType orderType;

//@property (nonatomic,strong) NSString *orderType;

@property (nonatomic,strong) NSString *caseType;

@property (nonatomic,strong) NSString *orderState;

@property (nonatomic,strong ) NSString *userId;

@property (nonatomic,strong) NSString *startTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSString *orderTime;

@property (nonatomic,strong) NSString *userHeder;



@end
