//
//  CaseDetailInfoCell.h
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HomeCaseListModel.h"

@interface CaseDetailInfoCell : BaseTableViewCell

@property (nonatomic,strong) HomeCaseListModel *model;

+(CGFloat)getHeightWithModel:(HomeCaseListModel *)model;
@end
