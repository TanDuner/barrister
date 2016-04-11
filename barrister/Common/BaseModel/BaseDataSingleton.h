//
//  BaseDataSingleton.h
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

struct PhoneSate {
    BOOL isopensound;
    BOOL isopenvibrate;
};
typedef struct PhoneSate PhoneSate;


@interface BaseDataSingleton : NSObject

@property (nonatomic,assign) PhoneSate currentPhoneState;

@property (nonatomic,assign) BOOL isAccountLogin;

+ (instancetype)shareInstance;

@end
