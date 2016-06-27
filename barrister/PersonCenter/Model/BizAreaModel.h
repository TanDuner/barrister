//
//  BizAreaModel.h
//  barrister
//
//  Created by 徐书传 on 16/6/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

//desc = "\U5408\U540c\U5ba1\U6838";
//icon = "<null>";
//id = 9;
//name = "\U5408\U540c\U5ba1\U6838";

@interface BizAreaModel : BaseModel

@property (nonatomic,strong) NSString *desc;

@property (nonatomic,strong) NSString *icon;

@property (nonatomic,strong) NSString *areaId;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) BOOL isSelected;

@end
