//
//  BarristerLoginVC.m
//  barrister
//
//  Created by 徐书传 on 16/3/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BarristerLoginVC.h"
#import "BorderTextFieldView.h"
#import "TFSButton.h"
#import "LoginProxy.h"
#import "BarristerUserModel.h"
#import "BarristerLoginManager.h"
#import "UIButton+EnlargeEdge.h"
#import "BaseWebViewController.h"

const float MidViewHeight = 190 / 2.0;

@interface BarristerLoginVC ()<UITextFieldDelegate>
{
    UIButton *loginBtn;
    BorderTextFieldView *accountTextField;
    BorderTextFieldView *passwordTextField;
    
    UIButton *getValidCodeBtn;
}

@property (nonatomic,assign) BOOL isCheched;

@property (nonatomic,strong)TFSButton *validBtn;

@property (nonatomic,strong) LoginProxy *proxy;

@property (nonatomic,strong) UIButton *checkButton;


@end



@implementation BarristerLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self initData];
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


#pragma -mark ------Data-----
-(void)initData
{
    self.proxy = [[LoginProxy alloc] init];
}


#pragma -mark ----UI-------

-(void)createView
{
    [self createBaseView];
    
    [self createMidView];
    
    
    [self addBackButton];
}

-(void)addBackButton
{
    return;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [backBtn setTitleColor:kButtonColor1Highlight forState:UIControlStateHighlighted];
    [backBtn.titleLabel setFont:SystemFont(16.0f)];
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon_hl"] forState:UIControlStateHighlighted];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(2, -10, 0, 0)];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, -5, 0, 0)];
    
    UIBarButtonItem * backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBar;

}

-(void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createBaseView
{
    
    self.navigationItem.title = @"登录";
    
    self.isCheched = YES;
}

-(void)createMidView
{
    UIView *inputBgView = [[UIView alloc] initWithFrame:RECT(0, 15, SCREENWIDTH, MidViewHeight)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    
    accountTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, (MidViewHeight - 0.5)/2.0)];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.textColor = kFormTextColor;
    accountTextField.cleanBtnOffset_x = accountTextField.width - 100;
    accountTextField.delegate = self;
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    
    
    UIView *sepView = [self getLineViewWithFrame:RECT(0, accountTextField.height, SCREENWIDTH, .5)];
    
    passwordTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(0, sepView.size.height + sepView.y, SCREENWIDTH - 100, (MidViewHeight - 0.5)/2.0)];
    passwordTextField.delegate = self;
    passwordTextField.textColor = kFormTextColor;
    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    passwordTextField.cleanBtnOffset_x = passwordTextField.width - 100;
    
    [inputBgView addSubview:accountTextField];
    [inputBgView addSubview:sepView];
    [inputBgView addSubview:passwordTextField];
    
    [self.view addSubview:inputBgView];
    
    
    
    self.validBtn  = [[TFSButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 100, inputBgView.height - passwordTextField.height, 100, passwordTextField.height)];
    [self.validBtn addTarget:self action:@selector(requestValidCode:) forControlEvents:UIControlEventTouchUpInside];

    
    [inputBgView addSubview:self.validBtn];

    
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setFrame:RECT(15, inputBgView.y + inputBgView.height + 20, 20, 20)];
    [self.checkButton setEnlargeEdgeWithTop:0 right:40 bottom:100 left:0];
    [self.checkButton setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(checkAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkButton];
    
    UILabel *xieyiLabel = [[UILabel alloc] initWithFrame:RECT(self.checkButton.x + self.checkButton.width + 15, self.checkButton.y, 200, 20)];
    xieyiLabel.userInteractionEnabled = YES;
    xieyiLabel.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toXieYiVC)];
    [xieyiLabel addGestureRecognizer:tap];
    xieyiLabel.textColor = kNavigationBarColor;
    xieyiLabel.text = @"我同意大律师注册协议";
    xieyiLabel.font = SystemFont(14.0f);
    [self.view addSubview:xieyiLabel];
    
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:kNavigationBarColor];
    [loginBtn.layer setCornerRadius:4.0f];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.titleLabel setFont:SystemFont(14.0)];
    [loginBtn setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:RECT(15, inputBgView.y + inputBgView.height + 70, SCREENWIDTH - 30, 45)];
    [self.view addSubview:loginBtn];
    
}

-(void)checkAciton:(UIButton *)checkAciton
{
    self.isCheched = !self.isCheched;
    if (self.isCheched) {
        [self.checkButton setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    }
}

-(void)toXieYiVC
{
    BaseWebViewController *controller = [[BaseWebViewController alloc] init];
    controller.showTitle = @"注册协议";
    controller.url = @"http://www.dls.com.cn/art/waplist.asp?id=675";
    [self.navigationController pushViewController:controller animated:YES];
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
            return [XuUtlity validateNumber:string];
        }
    }
    else
    {
        return YES;
        
    }

}






#pragma -mark ---------Action--------




-(void)loginAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (accountTextField.text.length == 0 ) {
        [XuUItlity showFailedHint:@"请输入手机号" completionBlock:nil];
        return;
    }
    else if(passwordTextField.text.length == 0)
    {
        [XuUItlity showFailedHint:@"请输入验证码" completionBlock:nil];
        return;
    }
    
    if (!self.isCheched) {
        [XuUItlity showFailedHint:@"请同意大律师注册协议" completionBlock:nil];
        return;
    }
    if ([XuUtlity validateMobile:accountTextField.text]) {
        __weak typeof(*&self) weakSelf = self;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:accountTextField.text,@"phone",passwordTextField.text,@"verifyCode", nil];
        [XuUItlity showLoading:@"正在登录"];
        [self.proxy loginWithParams:params Block:^(id returnData, BOOL success) {
            [XuUItlity hideLoading];
            if (success) {
                NSDictionary *dict = (NSDictionary *)returnData;
                NSDictionary *userDict = [dict objectForKey:@"user"];
                BarristerUserModel *user = [[BarristerUserModel alloc] initWithDictionary:userDict];
                [BaseDataSingleton shareInstance].userModel = user;
                [[BaseDataSingleton shareInstance] setLoginStateWithValidCode:user.verifyCode Phone:user.phone];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:nil];

                [XuUItlity showSucceedHint:@"登录成功" completionBlock:^{
                    if ([user.verifyStatus isEqualToString:@"verify.status.unautherized"] ) {
                        [[BarristerLoginManager shareManager] hideLoginViewController:self isToPersonInfoVC:YES];                        
                    }
                    else
                    {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];

                    }

                }];
                
            }
            else
            {
                
                [BaseDataSingleton shareInstance].userModel.verifyCode = nil;
                [BaseDataSingleton shareInstance].loginState = @"0";
                [BaseDataSingleton shareInstance].userModel = nil;
                [XuUItlity showFailedHint:@"登录失败" completionBlock:nil];
            }
        }];

    }
    else
    {
        [XuUItlity showFailedHint:@"手机号不合法" completionBlock:nil];
    }
}

-(void)requestValidCode:(TFSButton *)btn
{
    if ([XuUtlity validateMobile:accountTextField.text]) {
        [btn clickSelfBtn:btn];
        
        if (accountTextField) {
            [accountTextField resignFirstResponder];            
        }

        
        [XuUItlity showLoading:@"正在发送验证码..."];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:accountTextField.text,@"phone", nil];
        [self.proxy getValidCodeWithParams:params Block:^(id returnData, BOOL success) {
            [XuUItlity hideLoading];
            if (success) {
                [XuUItlity showSucceedHint:@"验证码已发送" completionBlock:nil];
            }
            else
            {
                [XuUItlity showFailedHint:@"发送失败" completionBlock:nil];
            
            }
        }];
    }
    else
    {
        [XuUItlity showFailedHint:@"请输入合法手机号" completionBlock:nil];
    }
}




@end
