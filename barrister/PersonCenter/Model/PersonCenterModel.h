//
//  PersonCenterModel.h
//  barrister
//
//  Created by 徐书传 on 16/3/29.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, PersonCenterModelType)
{
    PersonCenterModelTypeZH = 0,//账号
    PersonCenterModelTypeZHU = 1,//账户
    PersonCenterModelTypeXX = 2,//消息
    PersonCenterModelTypeRZZT = 3,//认证状态
    PersonCenterModelTypeJDSZ = 4,//接单设置
    PersonCenterModelTypeSZ = 5,//设置
    PersonCenterModelTypeInfoTX = 6,//个人信息界面 头像
    PersonCenterModelTypeInfoName = 7,//姓名
    PersonCenterModelTypeInfoPhone = 8,//手机
    PersonCenterModelTypeInfoEmail = 9,//邮箱
    PersonCenterModelTypeInfoArea = 10,//地区
    PersonCenterModelTypeInfoGoodAt = 11,//擅长领域
    PersonCenterModelTypeInfoCompany = 12,//律所
    PersonCenterModelTypeInfoZZSC = 13,//资质上传
    PersonCenterModelTypeInfoGZNX = 14,//工作年限
    PersonCenterModelTypeInfoIntroduce = 15,//个人简介
};

typedef void (^ModelActionBlock)(NSInteger PersonCenterModelType);

@interface PersonCenterModel : BaseModel

@property (nonatomic,strong) NSString *iconNameStr;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *subtitleStr;
@property (nonatomic,assign) BOOL isShowArrow;
@property (nonatomic,assign) BOOL isAccountLogin;
@property (nonatomic,strong) ModelActionBlock actionBlock;
@property (nonatomic,assign) PersonCenterModelType cellType;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSString *userIcon;


//领域id 拼接字符串
@property (nonatomic,strong) NSString *bizAreaIdStr;

//类型id 拼接字符串

@property (nonatomic,strong) NSString *bizTypeIdStr;


//擅长领域数组
@property (nonatomic,strong) NSMutableArray *bizAreaList;


//擅长类型数组
@property (nonatomic,strong) NSMutableArray *bizTypeList;


/**
 *  for 个人资料页面 头像回显
 */

@end
