//
//  PriceSettingViewController.m
//  barrister
//
//  Created by 徐书传 on 16/9/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "PriceSettingViewController.h"
#import "XWMoneyTextField.h"
#import "UIButton+EnlargeEdge.h"
#import "BaseWebViewController.h"
#import "AccountProxy.h"

const NSInteger RowHeight = 44;

@interface PriceSettingViewController ()<XWMoneyTextFieldLimitDelegate>

@property (nonatomic,strong) XWMoneyTextField *imPriceTxd;
@property (nonatomic,strong) XWMoneyTextField *appointPriceTxd;
@property (nonatomic,strong) UIButton *checkButton;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,assign) BOOL isCheched;//是否勾选同意按钮

@property (nonatomic,strong) AccountProxy *proxy;


@end

@implementation PriceSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
    [self confiView];
}

-(void)confiView
{
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 10, SCREENHEIGHT - 30, 15)];
    tipLabel.font = SystemFont(14.0f);
    tipLabel.textColor = kFontColorNormal;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.text = [NSString stringWithFormat:@"即时咨询价格"];
    
    [self.view addSubview:tipLabel];
    
    
    self.imPriceTxd = [[XWMoneyTextField alloc] initWithFrame:RECT(LeftPadding, CGRectGetMaxY(tipLabel.frame) + 10, SCREENWIDTH - LeftPadding *2, RowHeight)];
    self.imPriceTxd.borderStyle = UITextBorderStyleNone;
    self.imPriceTxd.placeholder = @"请输入金额";
    self.imPriceTxd.backgroundColor = [UIColor whiteColor];
    self.imPriceTxd.keyboardType = UIKeyboardTypeDecimalPad;
    self.imPriceTxd.limit.delegate = self;
    self.imPriceTxd.limit.max = @"999999999999.99";
    
    [self.view addSubview:self.imPriceTxd];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:RECT(LeftPadding, CGRectGetMaxY(self.imPriceTxd.frame), SCREENWIDTH - 30, RowHeight)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"预约咨询价格";
    label1.textColor = kFontColorNormal;
    label1.font = SystemFont(14.0f);
    [self.view addSubview:label1];
    
    
    self.appointPriceTxd = [[XWMoneyTextField alloc] initWithFrame:RECT(LeftPadding, CGRectGetMaxY(label1.frame) + 10, SCREENWIDTH - LeftPadding *2, RowHeight)];
    self.appointPriceTxd.borderStyle = UITextBorderStyleNone;
    self.appointPriceTxd.placeholder = @"请输入金额";
    self.appointPriceTxd.backgroundColor = [UIColor whiteColor];
    self.appointPriceTxd.keyboardType = UIKeyboardTypeDecimalPad;
    self.appointPriceTxd.limit.delegate = self;
    self.appointPriceTxd.limit.max = @"999999999999.99";
    [self.view addSubview:self.appointPriceTxd];
    
    
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setFrame:RECT(LeftPadding, CGRectGetMaxY(self.appointPriceTxd.frame) + 20, 20, 20)];
    [self.checkButton setEnlargeEdgeWithTop:0 right:40 bottom:100 left:0];
    [self.checkButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(checkAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkButton];
    
    UILabel *xieyiLabel = [[UILabel alloc] initWithFrame:RECT(self.checkButton.x + self.checkButton.width + 15, self.checkButton.y, 200, 20)];
    xieyiLabel.userInteractionEnabled = YES;
    xieyiLabel.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toXieYiVC)];
    [xieyiLabel addGestureRecognizer:tap];
    xieyiLabel.textColor = kNavigationBarColor;
    xieyiLabel.text = @"我同意修改价格须知";
    xieyiLabel.font = SystemFont(14.0f);
    [self.view addSubview:xieyiLabel];
    
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:kNavigationBarColor];
    [self.submitButton.layer setCornerRadius:4.0f];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.titleLabel setFont:SystemFont(14.0f)];
    [self.submitButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(commitAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setFrame:RECT(15, CGRectGetMaxY(xieyiLabel.frame) + 20, SCREENWIDTH - 30, 45)];
    [self.view addSubview:self.submitButton];
}



#pragma -mark ----Custom ----Aciton --

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
    controller.showTitle = @"修改价格须知";
    controller.url = @"http://www.dls.com.cn/art/waplist.asp?id=673";
    [self.navigationController pushViewController:controller animated:YES];
}



-(void)commitAciton:(UIButton *)sender
{
    
    if (!self.isCheched) {
        [XuUItlity showFailedHint:@"请同意修改价格须知" completionBlock:nil];
        return;
    }
    __weak typeof(*&self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@",self.imPriceTxd.text] forKey:@"priceIM"];
    [params setObject:[NSString stringWithFormat:@"%@",self.appointPriceTxd.text] forKey:@"priceAppointment"];
    [self.proxy changePriceWithParams:params block:^(id returnData, BOOL success) {
        if (success) {
            
            [XuUItlity showSucceedHint:@"修改成功" completionBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else{
            [XuUItlity showFailedHint:@"修改失败" completionBlock:nil];
        }
    }];
}

- (void)valueChange:(id)sender
{
    
}

#pragma -mark ---Getter----

-(AccountProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[AccountProxy alloc] init];
    }
    return _proxy;
}

@end
