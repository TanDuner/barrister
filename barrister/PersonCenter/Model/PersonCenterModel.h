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
    PersonCenterModelTypeZY,
    PersonCenterModelTypeDD,
    PersonCenterModelTypePJ,
    PersonCenterModelTypeSZ,
};

@interface PersonCenterModel : BaseModel

@property (nonatomic,strong) NSString *iconNameStr;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,assign) BOOL isShowArrow;
@property (nonatomic,assign) BOOL isAccountLogin;

@end
