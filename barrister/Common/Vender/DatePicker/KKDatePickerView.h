//
//  KKDatePickerView.h
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDatePickerViewModel.h"

@class KKDatePickerView ;
typedef void(^SelectTimeBlock)(KKDatePickerViewModel *model,KKDatePickerView *picker);

@interface KKDatePickerView : UIView

@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic,copy) SelectTimeBlock block;

@property (nonatomic, strong)KKDatePickerViewModel *model ;
-(instancetype)initWithFrame:(CGRect)frame;
@end
