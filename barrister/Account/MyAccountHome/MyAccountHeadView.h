//
//  MyAccountHeadView.h
//  barrister
//
//  Created by 徐书传 on 16/5/29.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AccountHeadViewHandleType)
{
    AccountHeadViewHandleTypeTX,//体现
    AccountHeadViewHandleTypeYHK,//银行卡
    AccountHeadViewHandleTypeSM,//说明
};

typedef void(^HeadViewHandleBlock)(AccountHeadViewHandleType type);

@interface MyAccountHeadView : UIView

@property (nonatomic,copy) HeadViewHandleBlock handleBlock;

@end
