//
//  PersonCenterAccountCell.h
//  barrister
//
//  Created by 徐书传 on 16/3/29.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYImage.h"

@interface PersonCenterAccountCell : UITableViewCell

@property (nonatomic,strong) YYAnimatedImageView *headerImageView;

@property (nonatomic,strong) UILabel *unLoginTipLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@end
