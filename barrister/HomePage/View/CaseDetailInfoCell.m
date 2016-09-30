//
//  CaseDetailInfoCell.m
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseDetailInfoCell.h"

@interface CaseDetailInfoCell ()
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *orderNoLabel;
@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *orderTimeLabel;
@property (nonatomic,strong) UILabel *orderPriceLabel;

@property (nonatomic,strong) UILabel *markLabel;

@end

@implementation CaseDetailInfoCell

+(CGFloat)getHeightWithModel:(HomeCaseListModel *)model
{
    return   135 + model.caseInfoHeight;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        
        [self addSubview:[self getLineViewWithRect:RECT(0, 39.5, SCREENWIDTH, .5)]];
        
        [self addSubview:self.orderNoLabel];
        [self addSubview:self.orderTimeLabel];
        [self addSubview:self.orderPriceLabel];
        
        [self addSubview:[self getLineViewWithRect:RECT(LeftPadding, self.orderPriceLabel.y + self.orderPriceLabel.height + 9.5, SCREENWIDTH - 10, .5)]];
        
        [self addSubview:self.markLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.orderNoLabel.text = [NSString stringWithFormat:@"案源号：%@",self.model.caseId?self.model.caseId:@"无"];

    self.orderTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",self.model.addTime?self.model.addTime:@"无"];
    
    self.orderPriceLabel.text = [NSString stringWithFormat:@"代理押金：%@",@"¥ 50.0"];
    
    
    self.markLabel.text = [NSString stringWithFormat:@"备注:%@",self.model.caseInfo];
    
    [self.markLabel setFrame:RECT(LeftPadding, self.orderPriceLabel.y + self.orderPriceLabel.height + 15, SCREENWIDTH - 20, self.model.caseDetailInfoHeight)];
}

#pragma -mark ----Getter---

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:RECT(10, 13, 200, 13)];
        _titleLabel.text = @"订单信息";
        _titleLabel.textColor = KColorGray222;
        _titleLabel.font = SystemFont(15.0f);
    }
    return _titleLabel;
}



-(UILabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, self.orderPriceLabel.y + self.orderPriceLabel.height + 15, SCREENWIDTH - 20, self.model.caseInfoHeight)];
        _markLabel.textAlignment = NSTextAlignmentLeft;
        _markLabel.numberOfLines = 0;
        _markLabel.textColor = KColorGray666;
        _markLabel.font = SystemFont(14.0f);
    }
    return _markLabel;
}


-(UILabel *)orderNoLabel
{
    if (!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 10 + 13 + 1 + self.titleLabel.y + self.titleLabel.height, SCREENWIDTH - 20, 13)];
        _orderNoLabel.textAlignment = NSTextAlignmentLeft;
        _orderNoLabel.textColor = KColorGray666;
        _orderNoLabel.text = [NSString stringWithFormat:@"案源号："];
        _orderNoLabel.font = SystemFont(14.0f);
    }
    return _orderNoLabel;
}

-(UILabel *)orderPriceLabel
{
    if (!_orderPriceLabel) {
        _orderPriceLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, self.orderTimeLabel.y + self.orderTimeLabel.height + 13, SCREENWIDTH - 20, 13)];
        _orderPriceLabel.textColor = KColorGray666;
        _orderPriceLabel.textAlignment = NSTextAlignmentLeft;
        _orderPriceLabel.text = [NSString stringWithFormat:@"代理押金："];
        _orderPriceLabel.font = SystemFont(14.0f);
    }
    return _orderPriceLabel;
}

-(UILabel *)orderTimeLabel
{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, self.orderNoLabel.y + self.orderNoLabel.height + 13, SCREENWIDTH - 20, 13)];
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        _orderTimeLabel.textColor = KColorGray666;
        _orderTimeLabel.text = [NSString stringWithFormat:@"发布时间："];
        _orderTimeLabel.font = SystemFont(14.0f);
    }
    return _orderTimeLabel;
}



@end
