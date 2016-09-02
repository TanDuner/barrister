//
//  CaseDetailBottomCell.h
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HomeCaseListModel.h"

typedef void(^CaseInfoHandleBlock)();


@interface CaseDetailBottomCell : BaseTableViewCell

+(CGFloat)getCellHeight;


@property (nonatomic,strong) HomeCaseListModel *model;

@property (nonatomic,copy) CaseInfoHandleBlock block;


@property (nonatomic,strong) NSString *cellType; //0 我要代理 1  更新进度 2  退回案源
@end
