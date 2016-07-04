//
//  OrderDetailFinishCell.h
//  barrister
//
//  Created by 徐书传 on 16/7/3.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BarristerOrderDetailModel.h"
typedef void(^FinishOrderCellBlock)();

@interface OrderDetailFinishCell : BaseTableViewCell

@property (nonatomic,copy) FinishOrderCellBlock block;
@property (nonatomic,strong) BarristerOrderDetailModel *model;

+(CGFloat)getCellHeight;

@end
