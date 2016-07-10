//
//  HomeCaseSourceCell.h
//  barrister
//
//  Created by 徐书传 on 16/7/10.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HomeCaseListModel.h"
@interface HomeCaseSourceCell : BaseTableViewCell

@property (nonatomic,strong) HomeCaseListModel *model;
+(CGFloat) getCellHeightWithModel:(HomeCaseListModel *)model;
@end
