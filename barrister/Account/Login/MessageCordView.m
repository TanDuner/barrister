//
//  MessageCordView.m
//  MessageCord
//
//  Created by 吴开奇 on 16/4/14.
//  Copyright © 2016年 Chason. All rights reserved.
//

#import "MessageCordView.h"
#import "myView.h"
//手机屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
static int countDownTime = 60;
@implementation MessageCordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        UIView *rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        rechargeView.backgroundColor = [UIColor whiteColor];
        [self addSubview:rechargeView];
        
        UILabel *rechargeMoney = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, frame.size.height - 20)];
        rechargeMoney.font = [UIFont systemFontOfSize:16];
        rechargeMoney.textColor = [UIColor grayColor];
        rechargeMoney.text = @"验证码";
        rechargeMoney.font = [UIFont systemFontOfSize:20];
        [rechargeView addSubview:rechargeMoney];
        
        _rechargeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, frame.size.width - 230, frame.size.height - 20)];
        _rechargeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rechargeField.placeholder = @"请输入验证码";
        _rechargeField.borderStyle = UITextBorderStyleNone;
        [rechargeView addSubview:_rechargeField];

        _button = [myView creatButtonWithFrame:CGRectMake(frame.size.width - 105, 5, 90, frame.size.height - 10) title:@"获取验证码" tag:1000 tintColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithRed:18/255.0  green:129/255.0  blue:201/255.0 alpha:1]];
        _button.layer.cornerRadius = 10;
        _button.font = [UIFont systemFontOfSize:14];
        [_button addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [rechargeView addSubview:_button];
    }
    return self;
}

- (void)getVerificationCode
{
    _label = [[UILabel alloc]initWithFrame:self.button.bounds];
    
    _timer = [[NSTimer alloc]init];
    _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    //请求服务器发送短信验证码
    //......
}

- (void)countDown
{
    countDownTime--;
    if (countDownTime<=0||countDownTime ==60) {
        _label.hidden = YES;
        _button.hidden = NO;
        _button.userInteractionEnabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        countDownTime =60;
    }else{
        _label.hidden = NO;
        _label.text = [NSString stringWithFormat:@"(%ds)重新获取",countDownTime];
        _label.font = [UIFont systemFontOfSize:12];
        _label.backgroundColor = [UIColor colorWithRed:18/255.0  green:129/255.0  blue:201/255.0 alpha:1];
        _label.layer.cornerRadius = 8;
        _label.clipsToBounds = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor= [UIColor whiteColor];
        [_button addSubview:_label];
        _button.userInteractionEnabled = NO;
    }
}

@end
