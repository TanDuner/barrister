//
//  MyBankCardController.m
//  barrister
//
//  Created by 徐书传 on 16/6/4.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "MyBankCardController.h"
#import "AddBankCardViewController.h"

@interface MyBankCardController ()

@property (nonatomic,strong) UIView *addBankCardView;

@property (nonatomic,strong) UIView *showBankCardView;

@property (nonatomic,strong) UIImageView *bankLogoImageView;

@property (nonatomic,strong) UILabel *bankNameLabel;

@end

@implementation MyBankCardController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self configView];
}

-(void)configView
{
    self.title  = @"我的银行卡";
    if ([[BaseDataSingleton shareInstance].bankCardBindStatus isEqualToString:@"0"]) {
        [self.view addSubview:self.addBankCardView];
    }
    else
    {
        [self.view addSubview:self.showBankCardView];
    }

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self judgeShowBankView];

}

-(void)judgeShowBankView
{
    if ([[BaseDataSingleton shareInstance].bankCardBindStatus isEqualToString:@"0"]) {
        [self.view addSubview:self.addBankCardView];
    }
    else
    {
        [self setBankCardDatas];
        [self.view addSubview:self.showBankCardView];
    }

}

-(void)setBankCardDatas
{
    
}



#pragma -mark ---Getter---

-(UIView *)showBankCardView
{
    if (!_showBankCardView) {
        _showBankCardView = [[UIView alloc] initWithFrame:RECT(10, 15, SCREENWIDTH - 20, 100)];
        _showBankCardView.backgroundColor = [UIColor whiteColor];
        _showBankCardView.userInteractionEnabled = YES;
        _showBankCardView.layer.cornerRadius = 5.0f;
        _showBankCardView.layer.masksToBounds = YES;
        
        _bankLogoImageView = [[UIImageView alloc] initWithFrame:RECT(LeftPadding, LeftPadding, 40, 40)];
        
        
//        _bankNameLabel = [UILabel alloc] initWithFrame:RECT(<#x#>, <#y#>, <#w#>, <#h#>)
    }
    return _showBankCardView;
}


-(UIView *)addBankCardView
{
    if (!_addBankCardView) {
        _addBankCardView = [[UIView alloc] initWithFrame:RECT(10, 15, SCREENWIDTH - 20, 100)];
        _addBankCardView.backgroundColor = [UIColor whiteColor];
        _addBankCardView.userInteractionEnabled = YES;
        _addBankCardView.layer.cornerRadius = 5.0f;
        _addBankCardView.layer.masksToBounds = YES;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addCardAction) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setImage:[UIImage imageNamed:@"addBankCard.png"] forState:UIControlStateNormal];
        [addBtn setFrame:RECT((SCREENWIDTH - 20 - 30)/2.0, (100 - 30)/2.0 - 15, 30, 30)];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:RECT(0, addBtn.y + addBtn.height, SCREENWIDTH - 20, 15)];
        tipLabel.text = @"添加银行卡";
        tipLabel.userInteractionEnabled = YES;
        tipLabel.font = SystemFont(14.0f);
        tipLabel.textColor = kFontColorNormal;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [_addBankCardView addSubview:tipLabel];
        [_addBankCardView addSubview:addBtn];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:RECT(0, 0, _addBankCardView.width, _addBankCardView.height)];
        [btn addTarget:self action:@selector(addCardAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_addBankCardView addSubview:btn];
        
        

    }
    return _addBankCardView;
}



-(void)addCardAction
{
    NSLog(@"点击添加银行卡");
    
    AddBankCardViewController *addVC = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];

}

@end
