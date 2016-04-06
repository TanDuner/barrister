//
//  LearnCenterCell.m
//  barrister
//
//  Created by 徐书传 on 16/4/6.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "LearnCenterCell.h"
#import "YYWebImage.h"

@interface LearnCenterCell ()

@property (nonatomic,strong) YYAnimatedImageView *leftImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitlelabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation LearnCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitlelabel];
        [self addSubview:self.timeLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.leftImageView setFrame:RECT(LeftPadding, LeftPadding + 5, 45, 45)];
    [self.titleLabel setFrame:RECT(self.leftImageView.x + self.leftImageView.width + 10, self.leftImageView.y, 150, 15)];
    [self.timeLabel setFrame:CGRectMake(SCREENWIDTH - 160, LeftPadding + 5, 150, 15)];
    [self.subTitlelabel setFrame:CGRectMake(self.titleLabel.x, self.titleLabel.y + self.titleLabel.height + 10, 250, 15)];
}


-(void)configData
{
    [super configData];
    
    if (self.model) {
        [self.leftImageView yy_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholder:[UIImage imageNamed:@"timeline_image_loading"]];
        self.titleLabel.text = self.model.learnTitle;
        self.subTitlelabel.text = self.model.learnSubtitle;
        self.timeLabel.text = [NSString stringWithFormat:@"%@",self.model.publishTime];
    }
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [kSeparatorColor setStroke];
    
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [linePath stroke];
    
}

#pragma -mark ------Getter----------


-(YYAnimatedImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[YYAnimatedImageView alloc] init];
//        [_leftImageView.layer setCornerRadius:22.5f];
//        [_leftImageView.layer setMasksToBounds:YES];
        
    }
    return _leftImageView;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kFontColorGray3;
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}


-(UILabel*)subTitlelabel
{
    if (!_subTitlelabel) {
        _subTitlelabel = [[UILabel alloc] init];
        _subTitlelabel.textColor = kFontColorGray1;
        _subTitlelabel.font = [UIFont systemFontOfSize:13.0f];
        _subTitlelabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitlelabel;
}



-(UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kFontColorGray1;
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}


@end
