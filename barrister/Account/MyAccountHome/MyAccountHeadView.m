//
//  MyAccountHeadView.m
//  barrister
//
//  Created by 徐书传 on 16/5/29.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "MyAccountHeadView.h"

@interface MyAccountHeadView ()

@property (nonatomic,strong) UILabel *totalIncomeLabel;
@property (nonatomic,strong) UIButton *tixianButton;
@property (nonatomic,strong) UIButton *yinhangkaButton;
@end


@implementation MyAccountHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kNavigationBarColor;
        
        UILabel *totalTipLabel = [[UILabel alloc] initWithFrame:RECT((SCREENWIDTH - 100)/2.0, self.height - 110 + 10, 100, 13)];
        totalTipLabel.text = @"总收入(元)";
        totalTipLabel.textColor = [UIColor whiteColor];
        totalTipLabel.textAlignment  = NSTextAlignmentCenter;
        totalTipLabel.font = SystemFont(17.0f);
        
        [self addSubview:totalTipLabel];


        UILabel *explainLabel = [[UILabel alloc] initWithFrame:RECT(SCREENWIDTH - 48, totalTipLabel.y - 1, 15, 15)];
        explainLabel.text = @"?";
        explainLabel.textAlignment = NSTextAlignmentCenter;
        explainLabel.font = SystemFont(13.0f);
        [explainLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(explainAction)]];
        explainLabel.backgroundColor = [UIColor whiteColor];
        explainLabel.textColor = kNavigationBarColor;
        explainLabel.layer.cornerRadius = 7.5;
        explainLabel.layer.masksToBounds = YES;
        [self addSubview:explainLabel];

        self.totalIncomeLabel = [[UILabel alloc] initWithFrame:RECT((SCREENWIDTH - 100)/2.0, self.height - 110  + 10 + 25, 100, 13)];
        self.totalIncomeLabel.textColor = RGBCOLOR(168, 188, 214);
        self.totalIncomeLabel.textAlignment = NSTextAlignmentCenter;
        self.totalIncomeLabel.font = SystemFont(17.0f);
        
        [self addSubview:self.totalIncomeLabel];

        
        self.tixianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tixianButton setTitle:@"提现" forState:UIControlStateNormal];
        [self.tixianButton setFrame:RECT(0, self.height - 40, (SCREENWIDTH - 0.5)/2.0, 40)];
        self.tixianButton.titleLabel.font = SystemFont(14.0);
        [self.tixianButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.tixianButton setImage:[UIImage imageNamed:@"my-account_cash.png"] forState:UIControlStateNormal];
        [self.tixianButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.tixianButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tixianButton];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:RECT((SCREENWIDTH - .5)/2.0, self.height - 30, .5, 20)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        
        self.yinhangkaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.yinhangkaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.yinhangkaButton setFrame:RECT((SCREENWIDTH - 0.5)/2.0 + .5, self.height - 40, (SCREENWIDTH - 0.5)/2.0, 40)];
        self.yinhangkaButton.titleLabel.font = SystemFont(14.0);
        [self.yinhangkaButton setTitle:@"银行卡" forState:UIControlStateNormal];
        [self.yinhangkaButton setImage:[UIImage imageNamed:@"my-account_card.png"] forState:UIControlStateNormal];
        [self.yinhangkaButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yinhangkaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self addSubview:self.yinhangkaButton];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.totalIncomeLabel.text = [NSString stringWithFormat:@"%@",[BaseDataSingleton shareInstance].totalIncome];

}


-(void)explainAction
{
    if (self.handleBlock) {
        self.handleBlock(AccountHeadViewHandleTypeSM);
    }
}

-(void)buttonAction:(UIButton *)button
{
    if (self.handleBlock) {
        NSInteger type = -1;
        if (button == self.tixianButton) {
            type = AccountHeadViewHandleTypeTX;
        }
        else if (button == self.yinhangkaButton)
        {
            type = AccountHeadViewHandleTypeYHK;
        }
        if (type != -1) {
            self.handleBlock (type);                
        }

    }
   
}


@end