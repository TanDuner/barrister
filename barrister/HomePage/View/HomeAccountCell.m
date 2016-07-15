//
//  HomeAccountCell.m
//  barrister
//
//  Created by 徐书传 on 16/4/12.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeAccountCell.h"
#import "HomeAccountItemView.h"
#define ItemViewHeight 70

@interface HomeAccountCell ()

@property (nonatomic,strong) HomeAccountItemView *leftView;
@property (nonatomic,strong) HomeAccountItemView *rightView;
@property (nonatomic,strong) UIButton *tixianBtn;

@end



@implementation HomeAccountCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:[self getLineViewWithRect:RECT((SCREENWIDTH - .5)/2.0, 10, .5, ItemViewHeight - 20)]];
        [self addSubview:[self getLineViewWithRect:RECT(0, ItemViewHeight, SCREENWIDTH, .5)]];
        [self addSubview:self.tixianBtn];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


-(void)configData
{
    [self.leftView setSubTitleStr:[NSString stringWithFormat:@"%@",[BaseDataSingleton shareInstance].remainingBalance]];
    [self.rightView setSubTitleStr:[NSString stringWithFormat:@"%@",[BaseDataSingleton shareInstance].totalIncome]];

}


+(CGFloat)getCellHeight
{
    return ItemViewHeight + 15 + 35 + 15;
}

#pragma -mark -----Getter------

-(HomeAccountItemView *)leftView
{
    if (!_leftView) {
        _leftView = [[HomeAccountItemView alloc] initWithFrame:RECT(0, 0, (SCREENWIDTH - 1)/2.0, ItemViewHeight) iconName:@"yue.png" titleStr:@"余额" subTitleStr:@"-"];
        [_leftView.bottomBtn addTarget:self action:@selector(bottomBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftView;
}

-(HomeAccountItemView *)rightView
{
    if (!_rightView) {
        _rightView = [[HomeAccountItemView alloc] initWithFrame:RECT((SCREENWIDTH - 1)/2.0 + 1, 0, (SCREENWIDTH - 1)/2.0, ItemViewHeight) iconName:@"shouru.png" titleStr:@"总收入" subTitleStr:@"-"];
        [_rightView.bottomBtn addTarget:self action:@selector(bottomBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightView;
}

-(UIButton *)tixianBtn
{
    if (!_tixianBtn) {
        _tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tixianBtn setFrame:RECT(SCREENWIDTH/4.0, ItemViewHeight + 15, SCREENWIDTH/2.0, 35)];
        [_tixianBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_tixianBtn setBackgroundImage:[UIImage imageNamed:@"tixian.png"] forState:UIControlStateNormal];
        [_tixianBtn addTarget:self action:@selector(tixianAction:) forControlEvents:UIControlEventTouchUpInside];
        _tixianBtn.titleLabel.font = SystemFont(15.0f);
        _tixianBtn.layer.cornerRadius = 17.5f;
        _tixianBtn.layer.masksToBounds = YES;
    }
    return _tixianBtn;
}

-(void)tixianAction:(UIButton *)button
{
    if (self.ActionBlock) {
        self.ActionBlock(nil,self);
    }
}


-(void)bottomBtnClickAction
{
    if (self.ActionBlock) {
        self.ActionBlock(@"account",self);
    }
}

@end
