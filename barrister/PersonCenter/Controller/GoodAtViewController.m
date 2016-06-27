//
//  GoodAtViewController.m
//  barrister
//
//  Created by 徐书传 on 16/6/27.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "GoodAtViewController.h"
#import "MeNetProxy.h"
#import "BizAreaModel.h"
#import "BizTypeModel.h"


#define ButtonWidth (SCREENWIDTH - 60)/4.0
#define ButtonHeight 35

#define LeadingPading 15
#define HorSpace 10
#define VerSpace 15
#define TopPadding 40

@interface GoodAtViewController ()

@property (nonatomic,strong) MeNetProxy *proxy;

@property (nonatomic,strong) NSMutableArray *typeArray;

@property (nonatomic,strong) NSMutableArray *areaArray;

@property (nonatomic,strong) UIView *areaView;

@property (nonatomic,strong) UIView *typeView;

@property (nonatomic,strong) UIScrollView *bgScrollView;


@end

@implementation GoodAtViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configData];
    [self configView];
}

-(void)configView
{
    self.title = @"选择擅长";
    
    [self initNavigationRightTextButton:@"确定" action:@selector(confirmSelectAciton:)];
    
    for (int i = 0; i < self.areaArray.count;  i ++) {
        BizAreaModel *model = [self.areaArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.desc forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        [button setFrame:RECT(LeadingPading + (ButtonWidth + HorSpace)*(i % 4), TopPadding + (i/4)*(ButtonHeight + VerSpace), ButtonWidth, ButtonHeight)];
        button.tag = i + 1;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithString:@"#e8e8e8" colorAlpha:1].CGColor;
        button.layer.masksToBounds = YES;
        [button setTitleColor:KColorGray666 forState:UIControlStateNormal];
        [button.titleLabel setFont:SystemFont(14.0f)];
        [button addTarget:self action:@selector(areaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.areaView addSubview:button];
        
    }
    
    [self.areaView setFrame:RECT(0, 0, SCREENWIDTH, ceil(self.areaArray.count/4.0) * (ButtonHeight + VerSpace) + TopPadding)];
    
    
    for (int i = 0; i < self.typeArray.count;  i ++) {
        BizTypeModel *typeModel = [self.typeArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:typeModel.desc forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        [button setFrame:RECT(LeadingPading + (ButtonWidth + HorSpace)*(i % 4), TopPadding + (i/4)*(ButtonHeight + VerSpace), ButtonWidth, ButtonHeight)];
        button.tag = i + 1000;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithString:@"#e8e8e8" colorAlpha:1].CGColor;
        button.layer.masksToBounds = YES;
        [button setTitleColor:KColorGray666 forState:UIControlStateNormal];
        [button.titleLabel setFont:SystemFont(14.0f)];
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeView addSubview:button];
        
    }
    
    [self.typeView setFrame:RECT(0, self.areaView.frame.size.height + self.areaView.frame.origin.x + 10, SCREENWIDTH, ceil(self.typeArray.count/4.0) * (ButtonHeight + VerSpace) + TopPadding)];

    if (self.typeView.height + self.areaView.height > 0) {
        
    }

    [self.bgScrollView addSubview:self.typeView];
    [self.bgScrollView addSubview:self.areaView];
    
    [self.bgScrollView setContentSize:CGSizeMake(0, self.typeView.height + self.areaView.height + 100)];
    [self.view addSubview:self.bgScrollView];

    

}

-(void)typeButtonClick:(UIButton *)button
{
    if (self.typeArray.count > button.tag - 1000) {
        BizTypeModel *model = (BizTypeModel *)[self.typeArray objectAtIndex:button.tag - 1000];
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:kNavigationBarColor];
        }
        else
        {
            [button setTitleColor:KColorGray666 forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        
    }

}


-(void)areaButtonClick:(UIButton *)button
{
    
    if (self.areaArray.count > button.tag - 1) {
        BizAreaModel *model = (BizAreaModel *)[self.areaArray objectAtIndex:button.tag - 1];
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:kNavigationBarColor];
        }
        else
        {
            [button setTitleColor:KColorGray666 forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        
    }

}

-(void)configData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaseDataSingleton shareInstance].userModel.userId,@"userId",[BaseDataSingleton shareInstance].userModel.verifyCode,@"verifyCode", nil];
    
    
    __weak typeof(*& self) weakSelf = self;
    
    [self.proxy getAreaAndTypeListWithParams:params block:^(id returnData, BOOL success) {
        if (success) {
         
            NSDictionary *dict = (NSDictionary *)returnData;

            NSArray *bizTypes = [dict objectForKey:@"bizTypes"];
            NSArray *bizAreas = [dict objectForKey:@"bizAreas"];
            [weakSelf handleCaseTypesWithArray:bizTypes];
            [weakSelf handleAreaTypesWithArray:bizAreas];
        }
        else
        {
            [XuUItlity showFailedHint:@"加载失败" completionBlock:nil];
        }
    }];
}

-(void)handleCaseTypesWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count ; i ++) {
        NSDictionary *dict = [array objectAtIndex:i];
        BizTypeModel *typeModel = [[BizTypeModel alloc] initWithDictionary:dict];
        [self.typeArray addObject:typeModel];
    }
}


-(void)handleAreaTypesWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count ; i ++) {
        NSDictionary *dict = [array objectAtIndex:i];
        BizAreaModel *typeModel = [[BizAreaModel alloc] initWithDictionary:dict];
        [self.areaArray addObject:typeModel];
    }
    
    [self configView];
    
}

#pragma -mark ----Action---

-(void)confirmSelectAciton:(UIButton *)btn
{
    NSString *typeIdstr = @"";
    for (int i = 0; i < self.typeArray.count; i ++) {
        BizTypeModel *modelTemp = (BizTypeModel *)[self.typeArray objectAtIndex:i];
        if (modelTemp.isSelected) {
            typeIdstr = [NSString stringWithFormat:@"%@,%@",typeIdstr,modelTemp.typeId];
        }

    }
    
    NSString *areaIdStr = @"";
    for (int i = 0; i < self.areaArray.count; i ++) {
        BizAreaModel *modelTemp = (BizAreaModel *)[self.areaArray objectAtIndex:i];
        if (modelTemp.isSelected) {
            areaIdStr = [NSString stringWithFormat:@"%@,%@",areaIdStr,modelTemp.areaId];
        }
    }
    
    if ([typeIdstr hasPrefix:@","]) {
       typeIdstr = [typeIdstr substringFromIndex:1];
    }
    if ([areaIdStr hasPrefix:@","]) {
        areaIdStr = [areaIdStr substringFromIndex:1];
    }
    
    self.cellModel.bizTypeIdStr = typeIdstr;
    self.cellModel.bizAreaIdStr = areaIdStr;
    if (self.cellModel.bizAreaIdStr.length == 0 && self.cellModel.bizTypeIdStr.length == 0) {
        self.cellModel.subtitleStr = @"未填写";
    }
    else
    {
        self.cellModel.subtitleStr = @"已填写";
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark --Getter----

-(MeNetProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[MeNetProxy alloc] init];
    }
    return _proxy;
}

-(NSMutableArray *)areaArray
{
    if (!_areaArray) {
        _areaArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _areaArray;
}

-(NSMutableArray *)typeArray
{
    if (!_typeArray) {
        _typeArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _typeArray;
}

-(UIView *)typeView
{
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, LeftPadding, 200, 40 - LeftPadding *2)];
        titleLabel.text = @"选择擅长类型";
        titleLabel.font = SystemFont(14.0f);
        [_typeView addSubview:titleLabel];

        _typeView.backgroundColor = [UIColor whiteColor];
    }
    return _typeView;
}

-(UIView *)areaView
{
    if (!_areaView) {
        _areaView = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:RECT(LeftPadding, LeftPadding, 200, 40 - LeftPadding *2)];
        titleLabel.text = @"选择擅长领域";
        titleLabel.font = SystemFont(14.0f);
        [_areaView addSubview:titleLabel];
        _areaView.backgroundColor = [UIColor whiteColor];
    }
    return _areaView;
}

-(UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT)];
        _bgScrollView.userInteractionEnabled = YES;
    }
    return _bgScrollView;
}

@end