//
//  HomeAccountItemView.m
//  barrister
//
//  Created by 徐书传 on 16/4/12.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeAccountItemView.h"
#import "UIImage+Additions.h"
#define ItemWidth  (SCREENWIDTH - 1)/2.0
#define LabelWidth ItemWidth/2.0

@interface HomeAccountItemView ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *subTitleStr;
@property (nonatomic,copy) NSString *iconNameStr;

@property (nonatomic,strong) UIImageView *bottomImageView;
@end

@implementation HomeAccountItemView

-(id)initWithFrame:(CGRect)frame
          iconName:(NSString *)iconName
          titleStr:(NSString *)titleStr
       subTitleStr:(NSString *)subTitleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bottomBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.iconImageView];
        
        self.titleStr  = titleStr;
        self.subTitleStr = subTitleStr;
        self.iconNameStr = iconName;


    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bottomBtn setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.titleLabel setFrame:RECT(LabelWidth, 20, LabelWidth, 15)];
    [self.subTitleLabel setFrame:RECT(self.titleLabel.x, self.titleLabel.y + self.titleLabel.height + 5, LabelWidth, 12)];
    [self.iconImageView setFrame:RECT((LabelWidth - 35)/2.0, 20, 35, 35)];
    self.subTitleLabel.backgroundColor = [UIColor redColor];
    [self configData];

}

-(void)configData
{
    self.titleLabel.text  = self.titleStr;
    self.subTitleLabel.text = self.subTitleStr;
    self.iconImageView.image = [UIImage imageNamed:self.iconNameStr];

}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = SystemFont(14.0f);
        _titleLabel.textColor = KColorGray222;
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = SystemFont(12.0f);
        _subTitleLabel.textColor = KColorGray666;
        
    }
    return _subTitleLabel;
}

-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setFrame:CGRectMake(0, 0, ItemWidth, 70)];
        [_bottomBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn setBackgroundImage:[UIImage createImageWithColor:RGBCOLOR(233, 233, 233)] forState:UIControlStateHighlighted];

    }
    return _bottomBtn;
}


-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

#pragma -mark ----clickAction

-(void)clickAction:(UIButton *)btn
{
    
}

-(void)setSubTitleStr:(NSString *)subTitleStr
{
    self.subTitleLabel.text = subTitleStr;
}

@end
