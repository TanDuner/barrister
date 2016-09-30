//
//  BaseDataSingleton.h
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarristerUserModel.h"

struct PhoneSate {
    BOOL isopensound;
    BOOL isopenvibrate;
};
typedef struct PhoneSate PhoneSate;



@interface BaseDataSingleton : NSObject

@property (nonatomic,assign) PhoneSate currentPhoneState;

@property (nonatomic,assign) NSString * loginState; //是否登录 //1 登录 0 未登录

//@property (nonatomic,strong) NSString *appointStatus;//预约状态 1 

@property (nonatomic,strong) NSString *orderQty;//订单数

@property (nonatomic,strong) NSString *remainingBalance;//余额

@property (nonatomic,strong) NSString *totalIncome;//总收入

@property (nonatomic,strong)BarristerUserModel *userModel; //用户

@property (nonatomic,strong) NSString *bankCardBindStatus;//绑定银行卡的状态

@property (nonatomic,strong) NSDictionary *bankCardDict;//银行卡的字典

@property (nonatomic,strong) NSString *status;//接单状态  

@property (nonatomic,assign) BOOL isClosePay;//支付开关



+ (instancetype)shareInstance;

/**
 *  设置登录状态
 *
 *  @param validCode
 */

-(void)setLoginStateWithValidCode:(NSString *)validCode Phone:(NSString *)phone;


/**
 *  注销 清空数据
 *
 *  @return
 */

-(void)logoOut;

-(BOOL) archive;

@end
