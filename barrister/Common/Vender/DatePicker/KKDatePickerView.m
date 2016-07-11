//
//  KKDatePickerView.m
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "KKDatePickerView.h"

@interface KKDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_yearArray;
    NSMutableArray *_mothArray;
    NSMutableArray *_dayArray ;
    UIView *_view;
}

@end

@implementation KKDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initData];
        [self initView];
    }
    return self;

}
//得到年月日这些数组
-(void)initData{

    NSArray *array = [self getSystemTime];
    self.model = [[KKDatePickerViewModel alloc] init];
    self.model.year = array[0];
    self.model.moth = array[1];
    self.model.day = array[2];
    
    _yearArray = [NSMutableArray array];
    NSString *yearSystem = array[0];
    int yearCount = [yearSystem intValue];
    for (int i = 1900; i<yearCount+1; i++) {
        NSString *year = [NSString stringWithFormat:@"%.2d",i];
        [_yearArray addObject:year];
    }
    _mothArray = [NSMutableArray array];
    for (int i = 1; i<13; i++) {
        NSString *moth = [NSString stringWithFormat:@"%.2d",i];
        [_mothArray addObject:moth];
    }
    
    [self getDaysInMoth:[self.model.moth integerValue]];
}
//初始化pickerview
-(void)initView{

    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 25)];
    titleLab.text = @"选择时间";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor colorWithRed:107/255.f green:107/255.f blue:107/255.f alpha:1];
    [self addSubview:titleLab];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(25, 35, self.bounds.size.width-50, 80)];
    _pickerView.backgroundColor = [UIColor clearColor];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    NSArray *array = [self getSystemTime];
    NSString  *yearRow = array[0] ;
    int year = [yearRow intValue]-1900;
    
    NSString *mothStr = array[1];
    int moth = [mothStr intValue];
    
    NSString *dayStr = array[2];
    int day = [dayStr intValue];
    
    
    //  设置默认选中日期,即现在的日期
    [self.pickerView selectRow:year inComponent:0 animated:YES];
    [self.pickerView selectRow:(moth-1) inComponent:1 animated:YES];
    [self.pickerView selectRow:(day-1) inComponent:2 animated:YES];
    
    [self performSelector:@selector(selectSystemTime)  withObject:nil afterDelay:.1];
    [self clearSeparatorWithView:_pickerView];
    
    //_pickerview的背景色为透明,在选中的那行上面放一层view,然后设置view的背景色
    UIView * selectViewBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-50, 20)];
    selectViewBac.backgroundColor = [UIColor colorWithRed:226/255.f green:242/255.f blue:250/255.f alpha:1];
    selectViewBac.center = _pickerView.center;
    
    [self addSubview:selectViewBac];
    [self addSubview:self.pickerView];
    
    UIColor * color = [UIColor colorWithRed:37/255.f green:162/255.f blue:219/255.f alpha:1];
    UIButton * cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_pickerView.frame)+10, 90, 30)];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:color forState:0];
    cancleBtn.layer.cornerRadius = 4;
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.borderColor = color.CGColor;
    cancleBtn.layer.borderWidth = 1;
    [cancleBtn addTarget:self action:@selector(cancelAciton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width -120, CGRectGetMaxY(_pickerView.frame) +10, 90, 30)];
    [sureBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:0];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = color;
    [self addSubview:sureBtn];
}

-(void)selectSystemTime{
    NSArray *array = [self getSystemTime];
    NSString  *yearRow = array[0];
    int year = [yearRow intValue]-1900;
    
    NSString *mothStr = array[1];
    int moth = [mothStr intValue];
    
    NSString *dayStr = array[2];
    int day = [dayStr intValue];
    //得到选中的那个view,并获取到它上面的label,再改变label的字体颜色
    UIView * yearview =  [_pickerView viewForRow:year forComponent:0];
    UILabel * yearlabel = yearview.subviews.firstObject;
    yearlabel.textColor =[UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];
    
    UIView * mothview =  [_pickerView viewForRow:(moth-1) forComponent:1];
    UILabel * mothlabel = mothview.subviews.firstObject;
    mothlabel.textColor =[UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];
    
    UIView * dayview =  [_pickerView viewForRow:(day-1) forComponent:2];
    UILabel * daylabel = dayview.subviews.firstObject;
    daylabel.textColor =[UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];

}
#pragma mark pickerviewDelegate
//返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//返回每列行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  _yearArray.count;
    } else if(component==1){
        
        return  _mothArray.count;
    }
    return _dayArray.count;
}
//每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20;
}
//每个item的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return  (self.bounds.size.width-50)/3;
    } else if(component==1){
        return  (self.bounds.size.width-50)/3;
    }
    return  (self.bounds.size.width-50)/3;
}

//改变选中那行的字体和颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.bounds.size.width-50)/3, 20)];
    if (component == 2) {
        NSInteger selecrDay  = [_pickerView selectedRowInComponent:component];
        if (selecrDay == row) {
            text.textColor = [UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];
        }
    }
    text.textAlignment = NSTextAlignmentCenter;
    if (component==0) {
        text.text = [_yearArray safeObjectAtIndex:row];
    }
    if (component==1) {
        text.text = [_mothArray safeObjectAtIndex:row];
    }
    if (component==2) {
        text.text = [_dayArray safeObjectAtIndex:row];
    }
    [view addSubview:text];
    
    return view;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //滑动月份时,更新日
    if (component ==1) {
        NSInteger moth = [_mothArray[row] integerValue];
        [self getDaysInMoth:moth];
        [_pickerView reloadComponent:2];
        
    }
    
    UIView * view =  [_pickerView viewForRow:row forComponent:component];
    UILabel * label = view.subviews.firstObject;
    label.textColor =[UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];
    if (component==0) {
        self.model.year = [_yearArray safeObjectAtIndex:row];
    }
    
    if (component==1) {
        self.model.moth = [_mothArray safeObjectAtIndex:row];
    }
    if (component==2) {
        self.model.day = [_dayArray safeObjectAtIndex:row];
    }
}
//获取某个月的天数
-(void)getDaysInMoth:(NSInteger)moth{
    
    int temp = 0;
    if (moth ==2) {
        temp = 29;
    }else if(moth == 1||moth == 3||moth == 5||moth == 7||moth == 8||moth == 10||moth == 12){
        temp = 31;
    }else{
        temp = 30;
    }
    _dayArray = [NSMutableArray array];
    for (int i = 1; i<=temp; i++) {
        NSString *day = [NSString stringWithFormat:@"%.2d",i];
        [_dayArray addObject:day];
    }
}
//让分割线背景颜色为透明
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        //分割线很薄的😊
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}
// 获取系统时间
-(NSArray*)getSystemTime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *na = [df stringFromDate:currentDate];
    return [na componentsSeparatedByString:@"-"];
    
}


#pragma -mark ---Aciton --
-(void)cancelAciton
{
    self.model.year = nil;
    self.model.moth = nil;
    self.model.day = nil;
    if (self.block) {
        self.block(self.model,self);
    }
}


-(void)confirmAction
{
    if (self.block) {
        self.block(self.model,self);
    }
}

@end
