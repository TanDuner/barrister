//
//  OrderDetailCancelCell.m
//  barrister
//
//  Created by 徐书传 on 16/7/3.
//  Copyright © 2016年 Xu. All rights reserved.
//

/**
 *  10
 *  10
 *  15
 *  10
 *  40
 *  10
 */

#import "OrderDetailCancelCell.h"
#import "UIImage+Additions.h"

@interface OrderDetailCancelCell ()


@property (nonatomic,strong) UIView *topSepView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *unAgreeBtn;
@property (nonatomic,strong) UIButton *agreeBtn;
@end

@implementation OrderDetailCancelCell

+(CGFloat)getCellHeight
{
    return 10 + 10 + 15 + 10 + 40 + 10;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.topSepView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.unAgreeBtn];
        [self addSubview:self.agreeBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

#pragma -mark ----Getter-----

-(UIView *)topSepView
{
    if (!_topSepView) {
        _topSepView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 10)];
        _topSepView.backgroundColor = [UIColor colorWithString:@"#eeeeee" colorAlpha:1];
        
    }
    return _topSepView;
}

-(UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, CGRectGetMaxY(self.topSepView.frame) + 10, SCREENWIDTH, 15)];
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.font = SystemFont(11.0f);
        _tipLabel.text = @"客户方发起取消订单需求，请及时处理";
    }
    return _tipLabel;
}

-(UIButton *)unAgreeBtn
{
    if (!_unAgreeBtn) {
        _unAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unAgreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [_unAgreeBtn setBackgroundImage:[UIImage createImageWithColor:kNavigationBarColor] forState:UIControlStateNormal];
        [_unAgreeBtn setFrame:RECT(LeftPadding, CGRectGetMaxY(self.tipLabel.frame) + 10, (SCREENWIDTH - 30)/2.0, 40)];
        _unAgreeBtn.layer.cornerRadius = 4.0f;
        [_unAgreeBtn addTarget:self action:@selector(unAgreeAction) forControlEvents:UIControlEventTouchUpInside];
        _unAgreeBtn.layer.masksToBounds = YES;
    }
    return _unAgreeBtn;
}

-(void)unAgreeAction
{
    if (self.block) {
        self.block(@"不同意");
    }
}

-(UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[UIImage createImageWithColor:kNavigationBarColor] forState:UIControlStateNormal];
        [_agreeBtn setFrame:RECT(LeftPadding + (SCREENWIDTH - 30)/2.0 + 10, CGRectGetMaxY(self.tipLabel.frame) + 10, (SCREENWIDTH - 30)/2.0, 40)];
        [_agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.backgroundColor = kNavigationBarColor;
        _agreeBtn.layer.cornerRadius = 4.0f;
        _agreeBtn.layer.masksToBounds = YES;
    }
    return _agreeBtn;
}

-(void)agreeAction
{
    if (self.block) {
        self.block(@"同意");
    }
}
@end
