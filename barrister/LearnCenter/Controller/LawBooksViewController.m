//
//  LawBooksViewController.m
//  barrister
//
//  Created by 徐书传 on 16/7/15.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "LawBooksViewController.h"
#import "LearnCenterProxy.h"
#import "LawBooksModel.h"
#import "BaseWebViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "YYWebImage.h"
#import "BarristerLoginManager.h"
#import "UIImage+Additions.h"

#define ItemWidth (SCREENWIDTH - 1)/2.0
#define LawButtonWidth 50
#define LawLeftPadding 17.5
#define LawTopPadding 17.5 + 45
#define LawHorSpacing (SCREENWIDTH - LawLeftPadding *2 - LawButtonWidth *4)/3
#define LawVerSpacing (SCREENHEIGHT/640.0) *45
#define LawNumOfLine 4



@interface LawBooksViewController ()
@property (nonatomic,strong) UIView *bottomCategoryView;
@property (nonatomic,strong) LearnCenterProxy *proxy;
@property (nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic,strong) NSMutableArray *titleArray;

@end

@implementation LawBooksViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];

    self.title = @"法律应用大全";

    [self.view addSubview:self.bottomCategoryView];
}


-(void)configData
{
    __weak typeof(*&self)weakSelf = self;
    [self.proxy getLawBooksWithParams:nil WithBlock:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            NSArray *array = [dict objectForKey:@"legalList"];
            if ([XuUtlity isValidArray:array]) {
                [weakSelf handleLawBookListDataWithArray:array];
            }
            else
            {
                [weakSelf handleLawBookListDataWithArray:@[]];
            }
        }
        else
        {
            
        }
    }];
    
    
    
    
    
}

-(void)handleLawBookListDataWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array  safeObjectAtIndex:i];
        LawBooksModel *model = [[LawBooksModel alloc] initWithDictionary:dict];
        [self.titleArray addObject:model.name];
        [self.urlArray addObject:model.url];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = LawButtonWidth/2.0f;
        button.layer.masksToBounds = YES;
        [button setEnlargeEdge:8];
        button.tag = i;
        button.titleEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
        button.titleLabel.font = SystemFont(10.0f);
        [button addTarget:self action:@selector(clickLawBooksAciton:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:RECT(LawLeftPadding + (LawButtonWidth + LawHorSpacing) *(i%LawNumOfLine), 10 + (LawButtonWidth + LawVerSpacing)*(i/LawNumOfLine), LawButtonWidth, LawButtonWidth)];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:RECT(button.x - 10, button.y + button.height + 15, LawButtonWidth + 20, 12)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = KColorGray666;
        tipLabel.font = SystemFont(12.0f);
        tipLabel.text = self.titleArray[i];
        
        [self.bottomCategoryView addSubview:tipLabel];
        
        UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:button.frame];
        [imageVIew yy_setImageWithURL:[NSURL URLWithString:model.icon] placeholder:[UIImage createImageWithColor:[UIColor lightGrayColor]]];
        imageVIew.userInteractionEnabled = YES;
        
        [self.bottomCategoryView addSubview:imageVIew];
        [self.bottomCategoryView addSubview:button];
        
        
    }
    
    
    [self.bottomCategoryView setFrame:RECT(0, 10, SCREENWIDTH, ceil(array.count/4) * (LawTopPadding + LawButtonWidth))];
    
    
}


#pragma -mark --Aciton----

-(void)clickLawBooksAciton:(UIButton *)btn
{
    //没登录让登录
    if (![[BaseDataSingleton shareInstance].loginState isEqualToString:@"1"]) {
        [[BarristerLoginManager shareManager] showLoginViewControllerWithController:self];
        return;
    }
    if (self.titleArray.count != self.urlArray.count) {
        return;
    }
    
    
    if (self.urlArray.count > btn.tag) {
        NSString *url = [self.urlArray safeObjectAtIndex:btn.tag];
        if ([url hasSuffix:@" "]) {
            url = [url substringToIndex:url.length - 1];
        }
        BaseWebViewController *webView = [[BaseWebViewController alloc] init];
        webView.url = url;
        webView.showTitle = self.titleArray[btn.tag];
        [self.navigationController pushViewController:webView animated:YES];
    }
    
    
}

#pragma -mark ----Getter-------

-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _titleArray;
}

//@[@"http://sjtj.flgw.com.cn/zgfl/default.asp",@"http://sjtj.flgw.com.cn/zgfg/default.asp",@"http://sjtj.flgw.com.cn/dffg/default.asp",@"http://sjtj.flgw.com.cn/sfjs/default.asp",@"http://sjtj.flgw.com.cn/flks/default.asp",@"http://sjtj.flgw.com.cn/syal/default.asp",@"http://sjtj.flgw.com.cn/htfb/default.asp",@"http://sjtj.flgw.com.cn/flws/default.asp",@"http://sjtj.flgw.com.cn/gjty/default.asp",@"http://sjtj.flgw.com.cn/bxfl/default.asp",@"http://sjtj.flgw.com.cn/wto/default.asp",@"http://sjtj.flgw.com.cn/ywfl/default.asp"]

-(NSMutableArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _urlArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)bottomCategoryView
{
    if (!_bottomCategoryView) {
        _bottomCategoryView = [[UIView alloc] initWithFrame:RECT(0, 10, SCREENWIDTH, 1000)];
        _bottomCategoryView.backgroundColor = [UIColor whiteColor];
        
//        UILabel *tipLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 15, 200, 15)];
//        tipLabel.textColor = KColorGray222;
//        tipLabel.font = SystemFont(16.0);
//        tipLabel.text = @"中国法律应用大全";
        
//        [_bottomCategoryView addSubview:tipLabel];
        
        
//        UIView *horSpeView = [[UIView alloc] initWithFrame:RECT(0, 45, SCREENWIDTH, 1)];
//        horSpeView.backgroundColor = RGBCOLOR(239, 239, 246);
//        
//        [_bottomCategoryView addSubview:horSpeView];
        
    }
    return _bottomCategoryView;
    
}


-(LearnCenterProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[LearnCenterProxy alloc] init];
    }
    return _proxy;
}


@end
