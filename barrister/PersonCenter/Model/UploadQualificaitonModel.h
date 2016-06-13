//
//  UploadQualificaitonModel.h
//  barrister
//
//  Created by 徐书传 on 16/6/13.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger,UploadType)
{
    UploadTypeGnvqs,//法律职业资格证书
    UploadTypeCertificate,//执业证书
    UploadTypeYear,//年检页
    UploadTypeCard,//身份证
    
};

@interface UploadQualificaitonModel : BaseModel

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIImage *uploadImage;
@property (nonatomic,assign) UploadType uploadType;
@property (nonatomic,strong) NSString *imageUrlString;

@end
