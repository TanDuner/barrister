//
//  HomeCaseSourceCell.m
//  barrister
//
//  Created by 徐书传 on 16/7/10.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeCaseSourceCell.h"


@interface HomeCaseSourceCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *midLabel;
@property (nonatomic,strong) UILabel *descLabel;
@end

@implementation HomeCaseSourceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:self.titleLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.midLabel];
        [self addSubview:self.descLabel];
        
    }
    return self;
}


+(CGFloat) getCellHeightWithModel:(HomeCaseListModel *)model
{
    return LeftPadding + 12 + LeftPadding + 12 + LeftPadding + model.caseInfoHeight + LeftPadding;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel setFrame:RECT(LeftPadding, LeftPadding, 100, 12)];
    [self.dateLabel setFrame:RECT(SCREENWIDTH - LeftPadding  - 150, LeftPadding, 150, 12)];
    [self.midLabel setFrame:RECT(LeftPadding, CGRectGetMaxY(self.titleLabel.frame) + LeftPadding, SCREENWIDTH - LeftPadding *2, 12)];
    [self.descLabel setFrame:RECT(LeftPadding, CGRectGetMaxY(self.midLabel.frame) +LeftPadding, SCREENWIDTH - LeftPadding *2, self.model.caseInfoHeight)];
}

-(void)configData
{
    self.titleLabel.text = [NSString stringWithFormat:@"案源号:%@",self.model.caseId?self.model.caseId:@"无"];
    self.dateLabel.text = self.model.addTime;
    NSString *str = @"";
    if ([self.model.status isEqualToString:STATUS_0_INIT]) {
        str = @"等待审核";
    }
    else if ([self.model.status isEqualToString:STATUS_1_PUBLISHED])
    {
        str = @"可代理";
    }
    else if ([self.model.status isEqualToString:STATUS_2_WAIT_UPDATE])
    {
        str = @"代理中";
    }
    else if ([self.model.status isEqualToString:STATUS_3_WAIT_CLEARING])
    {
        str = @"等待结算";
    }
    else if ([self.model.status isEqualToString:STATUS_4_WAIT_CLEARED])
    {
        str = @"已结算";
    }
    else
    {
        str = @"未知";
    }
    
    NSString *showPhoneStr = [NSString stringWithFormat:@"%@****%@",[self.model.contactPhone substringToIndex:3],[self.model.contactPhone substringFromIndex:7]];
    
    self.midLabel.text = [NSString stringWithFormat:@"状态:%@  %@  %@",str?str:@"-",showPhoneStr,IS_NOT_EMPTY(self.model.area)?self.model.area:@""];
    self.descLabel.text = self.model.caseInfo;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [kSeparatorColor setStroke];
    
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [linePath stroke];
    
}


#pragma -mark ---Getter---

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = SystemFont(15.0f);
        _titleLabel.textColor  = KColorGray333;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}


-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = SystemFont(13.0f);
        _dateLabel.textColor  = KColorGray999;
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}


-(UILabel *)midLabel
{
    if (!_midLabel) {
        _midLabel = [[UILabel alloc] init];
        _midLabel.font = SystemFont(14.0f);
        _midLabel.textColor  = KColorGray666;
        _midLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _midLabel;
}

-(UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = SystemFont(14.0f);
        _descLabel.textColor  = KColorGray666;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}


@end
