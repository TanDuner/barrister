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
    
    UIButton *wechatBtn;
    UIButton *QQBtn;
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
//    accountTextField.backgroundColor = [UIColor lightGrayColor];
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
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 200 , SCREENWIDTH, 150)];
    
    UIView *sepView1 = [self getLineViewWithFrame:RECT(0, 5, (SCREENWIDTH - 100)/2, .5)];
    UIView *sepView2 = [self getLineViewWithFrame:RECT((SCREENWIDTH - 100)/2 + 100, 5, (SCREENWIDTH - 100)/2, .5)];
    
    [bottomView addSubview:sepView1];
    [bottomView addSubview:sepView2];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH - 100)/2, 0, 100, 10)];
    tipLabel.textColor = RGBCOLOR(155, 155, 155);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:13.0f];
    tipLabel.text = @"其他登录方式";
    [bottomView addSubview:tipLabel];
    
    wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"login3rd_icon_weixin"] forState:UIControlStateNormal];
    [wechatBtn setFrame:RECT((SCREENWIDTH/2 - 51)/2, bottomView.height - 60 - 51, 51, 51)];
    wechatBtn.titleEdgeInsets = UIEdgeInsetsMake(85, 0, 0, 0);
    [wechatBtn setTitleColor:RGBCOLOR(155, 155, 155) forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    wechatBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    
    QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [QQBtn setTitle:@"微信" forState:UIControlStateNormal];
    [QQBtn setFrame:RECT((SCREENWIDTH/2 - 51)/2 + SCREENWIDTH/2, bottomView.height - 60 - 51, 51, 51)];
    [QQBtn setTitleColor:RGBCOLOR(155, 155, 155) forState:UIControlStateNormal];
    QQBtn.titleEdgeInsets = UIEdgeInsetsMake(85, 0, 0, 0);
    [QQBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    QQBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [QQBtn setBackgroundImage:[UIImage imageNamed:@"login3rd_icon_qq"] forState:UIControlStateNormal];
    
    [bottomView addSubview:wechatBtn];
    [bottomView addSubview:QQBtn];
    
    [self.view addSubview:bottomView];
}

#pragma -mark ------TextField Delegate Methods--------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == accountTextField) {
        if (textField.text.length > 11)
        {
            return NO;
        }
        else
        {
            return [self validateNumber:string];
        }
    }
    else
    {
        return YES;
        
    }

}



- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}



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

-(void)thirdLoginAction:(UIButton *)btn
{
    
}

@end
