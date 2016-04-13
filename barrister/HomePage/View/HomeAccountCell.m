//
//  HomeAccountCell.m
//  barrister
//
//  Created by 徐书传 on 16/4/12.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeAccountCell.h"

@interface HomeAccountCell ()

@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) NSString *iconName;

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSString *subTitleStr;



@end



@implementation HomeAccountCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                 IconNameStr:(NSString *)iconNameStr
                    titleStr:(NSString *)titleStr
                 subTitleStr:(NSString *)subTitleStr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.bottomBtn];
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        self.iconName = iconNameStr;
        self.titleStr = titleStr;
        self.subTitleStr = subTitleStr;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


-(void)configData
{

}


#pragma -mark -----Getter------

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
    }
    return _subTitleLabel;
}

-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _bottomBtn;
}


-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end
