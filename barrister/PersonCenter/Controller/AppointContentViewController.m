//
//  AppointContentViewController.m
//  barrister
//
//  Created by 徐书传 on 16/5/16.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "AppointContentViewController.h"
#import "AppointmentManager.h"


#define ButtonNum 36

#define ButtonWidth 25


@interface AppointCheckView : UIView

@property (nonatomic,strong) UIImageView *checkImageView;

@property (nonatomic,strong) UILabel *showLabel;

@property (nonatomic,assign) NSInteger startTimeNum;

@property (nonatomic,assign) NSInteger endTimeNum;

@property (nonatomic,assign) AppointMentState state;



@end

@implementation AppointCheckView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}



-(void)setState:(AppointMentState)state
{
    _state = state;
    if (_state == AppointMentStateSelect) {
        _checkImageView.image = [UIImage imageNamed:@"unSelected.png"];
    }
    else if(_state == AppointMentStateUnSelect)
    {
        _checkImageView.image = [UIImage imageNamed:@"Selected.png"];
    }
    else if (_state == AppointMentStateUnSelectable)
    {
        _checkImageView.image = [UIImage imageNamed:@"unSelectedable.png"];
    }

}

-(void)createView
{
    _checkImageView = [[UIImageView alloc] init];
    [_checkImageView setFrame:CGRectMake(0, 0, ButtonWidth, ButtonWidth)];
    _checkImageView.layer.cornerRadius = 3;
    _checkImageView.userInteractionEnabled = YES;
    _checkImageView.layer.masksToBounds = YES;
    [self addSubview:_checkImageView];
    
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(ButtonWidth + 5, 0, 65, ButtonWidth)];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.font = SystemFont(10.0f);
    _showLabel.textColor = [UIColor grayColor];
    [self addSubview:_showLabel];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end


#define CheckWidth 100
#define X_CenterPadding (SCREENWIDTH - 3*CheckWidth - LeftPadding *2)/2.0
#define Y_CenterPaddng 10
#define TopPadding 50

@interface AppointContentViewController ()

@property (nonatomic,strong) AppointCheckView *checkView;

@end
@implementation AppointContentViewController

#pragma -mark ----lifeCycle----

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.checkView = [[AppointCheckView alloc] initWithFrame:RECT(LeftPadding, LeftPadding, CheckWidth, 25)];

    BOOL isHaveUnSelect = NO;
    for (NSString *state in self.model.settingArray) {
        if ([state isEqualToString:@"0"]) {
            isHaveUnSelect = YES;
        }
    }
    
    if (isHaveUnSelect) {
            self.checkView.state = AppointMentStateUnSelect;
    }
    else
    {

        self.checkView.state = AppointMentStateSelect;


    }
    
    self.checkView.showLabel.text = @"选择全部";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAllAction:)];
    [self.checkView addGestureRecognizer:tap];
    [self.view addSubview:self.checkView];

    
    [self createView];
}


#pragma -mark ----UI------

-(void)createView
{
    NSInteger startTimeNum = 12 * 30;
    NSInteger endTimeNum = 13 *30;
    NSInteger stopTimeNum = 48 *30;
    
    if (self.model.settingArray.count < ButtonNum) {
        [self showNoContentView];
        return;
    }
    else
    {
        [self hideNoContentView];
    }
    
    for (int i = 0; i < ButtonNum; i ++) {
        
        if (startTimeNum == stopTimeNum) {
            break;
        }
        
        AppointCheckView *checkView = [[AppointCheckView alloc] init];
        NSString *startStr = [self getTimeStrWithTimeNum:startTimeNum];
        NSString *endStr = [self getTimeStrWithTimeNum:endTimeNum];
        
        NSString *stateStr = [self.model.settingArray safeObjectAtIndex:i];
        checkView.state = stateStr.integerValue;
        
        
        NSString *showStr = [NSString stringWithFormat:@"%@~%@",startStr,endStr];
        
        
        checkView.startTimeNum = startTimeNum;
        checkView.endTimeNum = endTimeNum;
        
        checkView.tag = i + 1000;
        
        [checkView setFrame:CGRectMake(LeftPadding + (i%3)*(CheckWidth + X_CenterPadding), TopPadding + (i / 3)*(Y_CenterPaddng + ButtonWidth), CheckWidth, 25)];
        checkView.showLabel.text = showStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAciton:)];
        [checkView addGestureRecognizer:tap];
        
        [self.checkViewItems addObject:checkView];
        [self.view addSubview:checkView];

        startTimeNum += 30;
        endTimeNum += 30;
        
    }
}


-(NSString *)getTimeStrWithTimeNum:(NSInteger)timeNum
{
    NSString *hourStr = timeNum / 60 < 10 ?[NSString stringWithFormat:@"0%ld",timeNum / 60]:[NSString stringWithFormat:@"%ld",timeNum / 60];
    NSString *minStr = timeNum % 60 < 10 ?[NSString stringWithFormat:@"0%ld",timeNum % 60]:[NSString stringWithFormat:@"%ld",timeNum % 60];
    
    NSString *totalStr = [NSString stringWithFormat:@"%@:%@",hourStr,minStr];
    
    return totalStr;
}

#pragma -mark ----Aciton ----

-(void)checkAciton:(UITapGestureRecognizer *)tap
{
    AppointCheckView *checkView = (AppointCheckView *)[tap view];
   
    
    if (self.model.settingArray.count > checkView.tag - 1000) {
        if (checkView.state == AppointMentStateSelect) {
            checkView.state = AppointMentStateUnSelect;
            //替换array  和字符串中的状态
            [self.model.settingArray replaceObjectAtIndex:checkView.tag - 1000 withObject:@"0"];
            [self.model replaceStringWithArrayIndex:checkView.tag - 1000 withStatus:@"0"];
        }
        else if(checkView.state == AppointMentStateUnSelect)
        {
            checkView.state = AppointMentStateSelect;
            [self.model.settingArray replaceObjectAtIndex:checkView.tag - 1000 withObject:@"1"];
            [self.model replaceStringWithArrayIndex:checkView.tag - 1000 withStatus:@"1"];
        }
        
    }

    
    [checkView setNeedsLayout];
   
}

-(void)checkAllAction:(UITapGestureRecognizer *)tap
{
    AppointCheckView *checkView = (AppointCheckView *)[tap view];
    if (checkView.state == AppointMentStateSelect) {
        checkView.state = AppointMentStateUnSelect;
        
        for (AppointCheckView *temp in self.checkViewItems) {
            if (temp.state == AppointMentStateSelect) {
                temp.state = AppointMentStateUnSelect;
            }
        }
        
        for ( int i = 0; i < self.model.settingArray.count; i ++) {
            [self.model.settingArray replaceObjectAtIndex:i withObject:@"0"];
        }
        self.model.settings = [self.model arrayToSettingStr:self.model.settingArray];
        
    }
    else if(checkView.state == AppointMentStateUnSelect)
    {
        checkView.state = AppointMentStateSelect;
        
        for (AppointCheckView *temp in self.checkViewItems) {
            if (temp.state == AppointMentStateUnSelect) {
                temp.state = AppointMentStateSelect;
            }
        }
        
        for ( int i = 0; i < self.model.settingArray.count; i ++) {
            [self.model.settingArray replaceObjectAtIndex:i withObject:@"1"];
        }
        
        self.model.settings =  [self.model arrayToSettingStr:self.model.settingArray];

    }

   
    
    
    
}

-(NSMutableArray *)checkViewItems
{
    if (!_checkViewItems) {
        _checkViewItems = [NSMutableArray arrayWithCapacity:10];
    }
    return _checkViewItems;
}


@end
