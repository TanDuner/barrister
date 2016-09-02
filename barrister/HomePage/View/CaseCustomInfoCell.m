//
//  CaseCustomInfoCell.m
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseCustomInfoCell.h"
#import "YYWebImage.h"

@interface CaseCustomInfoCell ()

@property (nonatomic,strong) UIView *topSepView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UILabel *customNamemLabel;

@property (nonatomic,strong) UILabel *customPhoneLabel;

@end

@implementation CaseCustomInfoCell

+(CGFloat)getHeightWithModel:(HomeCaseListModel *)model
{
    return 105 + 10 ;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.topSepView];

        [self addSubview:self.titleLabel];
        
        [self addSubview:[self getLineViewWithRect:RECT(0, 39.5 + 10, SCREENWIDTH, .5)]];
        
        [self addSubview:self.headImageView];
        
        [self addSubview:self.customNamemLabel];
        
        [self addSubview:self.customPhoneLabel];
        
        [self addSubview:self.callButton];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.topSepView setFrame:RECT(0, 0, SCREENWIDTH, 10)];
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"commom_default_head"]];
    self.customNamemLabel.text = self.model.contact;
    [_callButton setFrame:RECT(self.width - 40 - 10, 50 + (64 - 40)/2.0, 40, 40)];

    if ([self.model.status isEqualToString:STATUS_0_INIT]||[self.model.status isEqualToString:STATUS_1_PUBLISHED])
    {
        NSString *showPhoneStr = [NSString stringWithFormat:@"%@****%@",[self.model.contactPhone substringToIndex:3],[self.model.contactPhone substringFromIndex:7]];
        self.customPhoneLabel.text = showPhoneStr;
    }
    else{
        self.customPhoneLabel.text = self.model.contactPhone;
    }

    
}


#pragma -mark ----Getter---

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:RECT(10, 23, 200, 13)];
        _titleLabel.text = @"用户信息";
        _titleLabel.textColor = KColorGray222;
        _titleLabel.font = SystemFont(15.0f);
    }
    return _titleLabel;
}


-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:RECT(LeftPadding, 50 + 10, 45, 45)];
        _headImageView.layer.cornerRadius = 22.5f;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}


-(UIButton *)callButton
{
    if (!_callButton) {
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callButton setImage:[UIImage imageNamed:@"orderdetail_call"] forState:UIControlStateNormal];
    }
    
    return _callButton;
}

-(UILabel *)customNamemLabel
{
    if (!_customNamemLabel) {
        _customNamemLabel = [[UILabel alloc] initWithFrame:RECT(self.headImageView.x + self.headImageView.width + 15, 50 + 15, 200, 13)];
        _customNamemLabel.textColor = KColorGray333;
        _customNamemLabel.font = SystemFont(15.0f);
    }
    return _customNamemLabel;
}



-(UILabel *)customPhoneLabel
{
    if (!_customPhoneLabel) {
        _customPhoneLabel = [[UILabel alloc] initWithFrame:RECT(self.headImageView.x + self.headImageView.width + 15, self.customNamemLabel.y + self.customNamemLabel.height + 10, 200, 13)];
        _customPhoneLabel.textColor = KColorGray666;
        _customPhoneLabel.font = SystemFont(15.0f);
    }
    return _customPhoneLabel;
}


-(UIView *)topSepView
{
    if (!_topSepView) {
        _topSepView = [[UIView alloc] initWithFrame:RECT(0, 0, 0, 0)];
        _topSepView.backgroundColor = [UIColor colorWithString:@"#eeeeee" colorAlpha:1];
    }
    return _topSepView;
}


@end
