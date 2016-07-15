//
//  HomeAccountItemView.h
//  barrister
//
//  Created by 徐书传 on 16/4/12.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAccountItemView : UIView

@property (nonatomic,strong) UIButton *bottomBtn;

-(id)initWithFrame:(CGRect)frame
          iconName:(NSString *)iconName
          titleStr:(NSString *)titleStr
       subTitleStr:(NSString *)subTitleStr;


-(void)setSubTitleStr:(NSString *)subTitleStr;

@end
