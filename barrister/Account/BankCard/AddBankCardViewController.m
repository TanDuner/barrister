//
//  AddBankCardViewController.m
//  barrister
//
//  Created by 徐书传 on 16/6/4.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BorderTextFieldView.h"

#define RowHeight 44
#define LeftSpace 10
#define CleanBtnLessSpace 40
#define LeftViewWidth 60

@interface AddBankCardViewController ()<UITextFieldDelegate>

{
    UIView *inputBgView;
}

@property (nonatomic,strong) BorderTextFieldView *nameTextField;
@property (nonatomic,strong) BorderTextFieldView *bankNameTextField;
@property (nonatomic,strong) BorderTextFieldView *openBankNameTextField;
@property (nonatomic,strong) BorderTextFieldView *phoneTextField;
@property (nonatomic,strong) BorderTextFieldView *bankCardNumTextField;

@property (nonatomic,strong) UITextField *responderTextField;//当前焦点的textField

@property (nonatomic,strong) UIButton *confirmButton;

@end

@implementation AddBankCardViewController

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    };
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
}


#pragma -mark ---UI-----

-(void)configView
{
    inputBgView = [[UIView alloc] initWithFrame:RECT(0, 15, SCREENWIDTH, RowHeight * 5 + 1)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"姓名";
    label1.font = SystemFont(14.0f);
    
    
    _nameTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, 0, SCREENWIDTH - 100 - .5 - LeftSpace, RowHeight)];
    _nameTextField.keyboardType = UIKeyboardTypeNumberPad;
    _nameTextField.textColor = kFormTextColor;
    _nameTextField.row = 1;
    _nameTextField.cleanBtnOffset_x = _nameTextField.width - CleanBtnLessSpace;
    _nameTextField.delegate = self;
    _nameTextField.textLeftOffset = LeftViewWidth + 20;
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    _nameTextField.leftView = label1;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *sepView1 = [self getLineViewWithFrame:RECT(0, _nameTextField.height, SCREENWIDTH, .5)];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:RECT(LeftSpace, 0, LeftViewWidth, RowHeight)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"银行类型";
    label2.font = SystemFont(14.0f);
    
    
    _bankNameTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView1.y + sepView1.height, SCREENWIDTH - LeftSpace, RowHeight)];
    
    _bankNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bankNameTextField.textColor = kFormTextColor;
    _bankNameTextField.cleanBtnOffset_x = _bankNameTextField.width - CleanBtnLessSpace;
    _bankNameTextField.delegate = self;
    _bankNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行类型" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    _bankNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _bankNameTextField.leftView = label2;
    _bankNameTextField.textLeftOffset = LeftViewWidth + 20;
    
    UIView *sepView2 = [self getLineViewWithFrame:RECT(0, _bankNameTextField.height + _bankNameTextField.y, SCREENWIDTH, .5)];

    
    UILabel *label3 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.text = @"开户行";
    label3.font = SystemFont(14.0f);
    
    
    _openBankNameTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView2.size.height + sepView2.y, SCREENWIDTH - LeftSpace, RowHeight)];
    _openBankNameTextField.delegate = self;
    _openBankNameTextField.cleanBtnOffset_x = _openBankNameTextField.width - CleanBtnLessSpace;
    _openBankNameTextField.textColor = kFormTextColor;
    _openBankNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入开户行" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    _openBankNameTextField.leftView = label3;
    _openBankNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _openBankNameTextField.textLeftOffset = LeftViewWidth + 20;
    
    UIView *sepView3 = [self getLineViewWithFrame:RECT(0, _openBankNameTextField.height + _openBankNameTextField.y, SCREENWIDTH, .5)];

    
    UILabel *label4 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.text = @"手机号";
    label4.font = SystemFont(14.0f);


    _phoneTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView3.size.height + sepView3.y, SCREENWIDTH - LeftSpace, RowHeight)];
    _phoneTextField.delegate = self;
    _phoneTextField.cleanBtnOffset_x = _phoneTextField.width - CleanBtnLessSpace;
    _phoneTextField.textColor = kFormTextColor;
    _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    _phoneTextField.leftView = label4;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.textLeftOffset = LeftViewWidth + 20;

    
    UIView *sepView4 = [self getLineViewWithFrame:RECT(0, _phoneTextField.height + _phoneTextField.y, SCREENWIDTH, .5)];
    

    UILabel *label5 = [[UILabel alloc] initWithFrame:RECT(0, 0, LeftViewWidth, RowHeight)];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.text = @"卡号";
    label5.font = SystemFont(14.0f);
    
    
    _bankCardNumTextField = [[BorderTextFieldView alloc] initWithFrame:RECT(LeftSpace, sepView4.size.height + sepView4.y, SCREENWIDTH - LeftSpace, RowHeight)];
    _bankCardNumTextField.delegate = self;
    _bankCardNumTextField.cleanBtnOffset_x = _bankCardNumTextField.width - CleanBtnLessSpace;
    _bankCardNumTextField.textColor = kFormTextColor;
    _bankCardNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入卡号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(199, 199, 205)}];
    _bankCardNumTextField.leftView = label5;
    _bankCardNumTextField.leftViewMode = UITextFieldViewModeAlways;
    _bankCardNumTextField.textLeftOffset = LeftViewWidth + 20;
    
    [inputBgView addSubview:_nameTextField];
    [inputBgView addSubview:sepView1];

    [inputBgView addSubview:_bankNameTextField];
    [inputBgView addSubview:sepView2];

    [inputBgView addSubview:_openBankNameTextField];
    [inputBgView addSubview:sepView3];

    [inputBgView addSubview:_phoneTextField];
    [inputBgView addSubview:sepView4];

    [inputBgView addSubview:_bankCardNumTextField];
    
    [self.view addSubview:inputBgView];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:kNavigationBarColor];
    [_confirmButton.layer setCornerRadius:4.0f];
    [_confirmButton.layer setMasksToBounds:YES];
    [_confirmButton.titleLabel setFont:SystemFont(14.0f)];
    [_confirmButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setFrame:RECT(15, RowHeight *5 + 10 + 48, SCREENWIDTH - 30, 45)];
    [self.view addSubview:_confirmButton];

}

-(void)confirmAction:(UIButton *)btn
{
    
}


#pragma -mark ----UITextField Methods-----

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.responderTextField = textField;
    return YES;
}



-(void)keyBoardChangeFrame:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect responderRect = [self.view convertRect:self.responderTextField.frame fromView:inputBgView];
    
    CGFloat detalHeight = responderRect.origin.y + responderRect.size.height - kbSize.height;
    
    if (detalHeight > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setFrame:CGRectMake(0, -detalHeight, SCREENWIDTH, SCREENHEIGHT)];
        }];
    }
    
   
    
}



@end
