//
//  CaseDetailBottomCell.m
//  barrister
//
//  Created by 徐书传 on 16/8/26.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseDetailBottomCell.h"
#import "UIImage+Additions.h"

@interface CaseDetailBottomCell ()

@property (nonatomic,strong) UIView *topSepView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *agreeBtn;


@end

@implementation CaseDetailBottomCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.topSepView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.agreeBtn];
    }
    return self;
}

+(CGFloat)getCellHeight
{
    return 10 + 10 + 15 + 10 + 40 + 10;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.cellType isEqualToString:@"0"]) {
        _tipLabel.text = [NSString stringWithFormat:@"提示:%@",@"代理这个案件需要支付50元代理费"];
        [self.agreeBtn setTitle:@"我要代理" forState:UIControlStateNormal];
    }
    else if ([self.cellType isEqualToString:@"1"])
    {
        _tipLabel.text = [NSString stringWithFormat:@"提示:%@",@"请更新案源进度，上传信息"];
        [self.agreeBtn setTitle:@"更新进度" forState:UIControlStateNormal];
    }
    else if ([self.cellType isEqualToString:@"2"])
    {
        _tipLabel.text = [NSString stringWithFormat:@"提示:%@",@"退回案源不会退回代理费用"];
        [self.agreeBtn setTitle:@"退回案源" forState:UIControlStateNormal];

    }
    
    

    
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
        _tipLabel.textColor = [UIColor cyanColor];
        _tipLabel.font = SystemFont(11.0f);
    }
    return _tipLabel;
}


-(UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setFrame:RECT(LeftPadding , CGRectGetMaxY(self.tipLabel.frame) + 10, SCREENWIDTH - LeftPadding *2, 40)];
        [_agreeBtn addTarget:self action:@selector(FinishOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn setBackgroundImage:[UIImage createImageWithColor:kNavigationBarColor] forState:UIControlStateNormal];
        _agreeBtn.layer.cornerRadius = 4.0f;
        _agreeBtn.layer.masksToBounds = YES;
    }
    return _agreeBtn;
}


-(void)FinishOrderAction
{
    if (self.block) {
        self.block();
    }
}


@end
