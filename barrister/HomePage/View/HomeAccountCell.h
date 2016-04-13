//
//  HomeAccountCell.h
//  barrister
//
//  Created by 徐书传 on 16/4/12.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HomeAccountCell : BaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                 IconNameStr:(NSString *)iconNameStr
                    titleStr:(NSString *)titleStr
                 subTitleStr:(NSString *)subTitleStr;
@end
