//
//  BarristerRegisterVC.m
//  barrister
//
//  Created by 徐书传 on 16/3/24.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerRegisterVC.h"
#import "BorderTextFieldView.h"

#define RowHeight 44
#define LeftSpace 10
#define CleanBtnLessSpace 40
#define LeftViewWidth 60

@interface BarristerRegisterVC ()<UITextFieldDelegate>
{
    BorderTextFieldView *accountTextField;
    BorderTextFieldView *codeTextField;
    BorderTextFieldView *passwordTextField;
    UIButton *getCodeBtn;
    UIButton *registerBtn;
}
@end

@implementation BarristerRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createView
{
    [self createBaseView];
    [self createContentView];
}

/**
 *  创建非内容UI
 */
-(void)createBaseView
{
    self.title  = @"注册";
}

/**
 *  创建输入框部分的UI
 */
-(void)createContentView
{
    UIView *inputBgView = [[UIView alloc] initWithFrame:RECT(0, 15, SCREENWIDTH, RowHeight * 3 + 1)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"手机号";
    label1.font = [UIFont systemFontOfSize:14.0f];
    
    
    accountTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, 0, SCREENWIDTH - 100 - .5 - LeftSpace, RowHeight)];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.textColor = kFormTextColor;
    accountTextField.row = 1;
    accountTextField.cleanBtnOffset_x = accountTextField.width - CleanBtnLessSpace;
    accountTextField.delegate = self;
    accountTextField.textLeftOffset = LeftViewWidth + 20;
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    accountTextField.leftView = label1;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *verSepView = [self getLineViewWithFrame:RECT(accountTextField.width , 0, .5, RowHeight)];
    
    [inputBgView addSubview:verSepView];
    
    getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setFrame:RECT(SCREENWIDTH - 100, -1, 100, RowHeight + 2)];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [getCodeBtn setTitleColor:RGBCOLOR(165, 165, 165) forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *sepView1 = [self getLineViewWithFrame:RECT(0, accountTextField.height, SCREENWIDTH, .5)];

    UILabel *label2 = [[UILabel alloc] initWithFrame:RECT(LeftSpace, 0, LeftViewWidth, RowHeight)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"验证码";
    label2.font = [UIFont systemFontOfSize:14.0f];

    
    codeTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView1.y + sepView1.height, SCREENWIDTH - LeftSpace, RowHeight)];

    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.textColor = kFormTextColor;
    codeTextField.cleanBtnOffset_x = codeTextField.width - CleanBtnLessSpace;
    codeTextField.delegate = self;
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.leftView = label2;
    codeTextField.textLeftOffset = LeftViewWidth + 20;
    
    UIView *sepView2 = [self getLineViewWithFrame:RECT(0, codeTextField.height + codeTextField.y, SCREENWIDTH, .5)];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.text = @"密码";
    label3.font = [UIFont systemFontOfSize:14.0f];

    
    passwordTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView2.size.height + sepView2.y, SCREENWIDTH - LeftSpace, RowHeight)];
    passwordTextField.delegate = self;
    passwordTextField.cleanBtnOffset_x = passwordTextField.width - CleanBtnLessSpace;
    passwordTextField.textColor = kFormTextColor;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    passwordTextField.leftView = label3;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.textLeftOffset = LeftViewWidth + 20;
    
    [inputBgView addSubview:accountTextField];
    [inputBgView addSubview:getCodeBtn];

    [inputBgView addSubview:sepView1];
    [inputBgView addSubview:codeTextField];
    [inputBgView addSubview:sepView2];
    [inputBgView addSubview:passwordTextField];
    [self.view addSubview:inputBgView];
    
    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:kNavigationBarColor];
    [registerBtn.layer setCornerRadius:4.0f];
    [registerBtn.layer setMasksToBounds:YES];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [registerBtn setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAciton:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setFrame:RECT(15, RowHeight *3 + 10 + 48, SCREENWIDTH - 30, 45)];
    [self.view addSubview:registerBtn];


}


#pragma -mark ----UITextField Delegate methods -------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == accountTextField) {//手机号
        if (textField.text.length > 11)
        {
            return NO;
        }
        else
        {
            return [XuUtlity validateNumber:string];
        }
    }
    else if(textField == codeTextField)//验证码textField
    {
        if (textField.text.length > 4) {
            return NO;
        }
        else
        {
            return [XuUtlity validateNumber:string];
        }
    }
    else//密码的textField
    {
        if (textField.text.length > 10) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
}




#pragma -mark ----Action----

-(void)getCodeAction
{
    NSLog(@"获取验证码");
}

-(void)registerAciton:(UIButton *)button
{

}

@end
