//
//  BarristerUserModel.h
//  barrister
//
//  Created by 徐书传 on 16/5/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

@interface BarristerUserModel : BaseModel

@property (nonatomic,strong) NSString *userId;//userid

/**
 *  验证码 也就是密码
 */
@property (nonatomic,strong) NSString *verifyCode;
/**
 *  昵称
 */
@property (nonatomic,strong) NSString *nickName;

/**
 *  性别 0 男  1 女
 */
@property (nonatomic,strong) NSString *gender;

/**
 *  姓名
 */
@property (nonatomic,strong) NSString *username;

/**
 *  头像地址
 */
@property (nonatomic,strong) NSString *headUrl;

/**
 *  手机
 */
@property (nonatomic,strong) NSString *mobile;

/**
 *  邮箱
 */
@property (nonatomic,strong) NSString *mail;

/**
 * 律师事务所
 */
@property (nonatomic,strong) NSString *lawOffice;

/**
 * 地区
 */
@property (nonatomic,strong) NSString *area;

/**
 * 执业证书编号
 */
@property (nonatomic,strong) NSString *certificateNo;

/**
 * 律师执业证书照片http链接
 */
@property (nonatomic,strong) NSString *certificateUrl;

/**
 *  身份证号
 */

@property (nonatomic,strong) NSString *cardNum;

/**
 *  身份证照片链接
 */

@property (nonatomic,strong) NSString *cardUrl;

/**
 *  工作年限
 */

@property (nonatomic,strong) NSString *workTime;

/**
 *  星级数量
 */

@property (nonatomic,strong) NSString *startCount;

/**
 *  历史完成订单数
 */

@property (nonatomic,strong) NSString *orderCount;

/**
 *  法律职业资格证书
 */

@property (nonatomic,strong) NSString *gnvqsUrl;

/**
 *  法律执业证书年检照片
 */

@property (nonatomic,strong) NSString *yearCheckUrl;

/**
 *  小节率
 */

@property (nonatomic,strong) NSString *summaryRate;

/**
 *  认证失败原因
 */

@property (nonatomic,strong) NSString *refuseCause;

@end
