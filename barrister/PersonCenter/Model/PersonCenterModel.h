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
    PersonCenterModelTypeZH,
    PersonCenterModelTypeZHU,
    PersonCenterModelTypeXX,
    PersonCenterModelTypeRZZT,
    PersonCenterModelTypeJDSZ,
    PersonCenterModelTypeSZ,
    PersonCenterModelTypeTX,
    
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

/**
 *  for 个人资料页面 头像回显
 */
@property (nonatomic,strong)
@end
