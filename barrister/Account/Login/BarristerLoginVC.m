//
//  BarristerLoginVC.m
//  barrister
//
//  Created by 徐书传 on 16/3/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerLoginVC.h"
#import "BorderTextFieldView.h"


const float MidViewHeight = 175.0 / 2.0;

@interface BarristerLoginVC ()<UITextFieldDelegate>
{
    UIButton *loginBtn;
    UIButton *forgetBtn;
    BorderTextFieldView *accountTextField;
    BorderTextFieldView *passwordTextField;
}

@end



@implementation BarristerLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}



#pragma -mark ----UI-------

-(void)createView
{
    [self createBaseView];
    
    [self createMidView];
    
    [self createBottomView];
    
}

-(void)createBaseView
{
    
    self.navigationItem.title = @"登录";
        
    [self initNavigationRightTextButton:@"注册" action:@selector(toRegisterAction:)];
    
}

-(void)createMidView
{
    UIView *inputBgView = [[UIView alloc] initWithFrame:RECT(0, 15, SCREENWIDTH, 175.0/2.0)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    
    accountTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, (MidViewHeight - 0.5)/2.0)];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.placeholder = @"请输入手机号";
    accountTextField.textColor = kFormTextColor;
    accountTextField.cleanBtnOffset_x = accountTextField.width - 100;
    accountTextField.delegate = self;
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    
    
    UIView *sepView = [self getLineViewWithFrame:RECT(0, accountTextField.height, SCREENWIDTH, .5)];
    
    passwordTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(0, sepView.size.height + sepView.y, SCREENWIDTH, (MidViewHeight - 0.5)/2.0)];
    passwordTextField.delegate = self;
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = kFormTextColor;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];

    passwordTextField.cleanBtnOffset_x = passwordTextField.width - 100;
    
    [inputBgView addSubview:accountTextField];
    [inputBgView addSubview:sepView];
    [inputBgView addSubview:passwordTextField];
    
    [self.view addSubview:inputBgView];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:kNavigationBarColor];
    [loginBtn.layer setCornerRadius:4.0f];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [loginBtn setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:RECT(15, inputBgView.y + inputBgView.height + 48, SCREENWIDTH - 30, 45)];
    [self.view addSubview:loginBtn];
    
    forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [forgetBtn addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [forgetBtn setFrame:RECT(SCREENWIDTH - 40 - 100, loginBtn.y + loginBtn.height + 10, 100, 25)];
    [self.view addSubview:forgetBtn];
}

-(void)createBottomView
{

}

#pragma -mark ------TextField Delegate Methods--------


#pragma -mark ---------Action--------

-(void)toRegisterAction:(id)sender
{
    
}


-(void)loginAction:(UIButton *)button
{

}

-(void)forgetPwdAction:(UIButton *)button
{
    
}

@end
