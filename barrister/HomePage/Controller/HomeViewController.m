//
//  HomeViewController.m
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "HomeViewController.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"
#import "BarristerLoginVC.h"
#import "OrderViewCell.h"
#import "BarristerOrderModel.h"
#import "HomeAccountCell.h"


@interface HomeViewController ()

@property (nonatomic,strong) NSMutableArray *orderItems;
@property (nonatomic,strong) UIView *accountHeadView;
@property (nonatomic,strong) UIView *daiBanHeadView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configData];
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:YES];
}

#pragma -mark ----UI---------

-(void)createView
{
    [self createBaseView];
    [self createTableView];
}

-(void)createBaseView
{
    [self initNavigationRightTextButton:@"登录" action:@selector(toLoginAction:)];
}

-(void)createTableView
{
    NSArray *UrlStringArray = @[@"http://e.hiphotos.baidu.com/lvpics/h=800/sign=61e9995c972397ddc97995046983b216/35a85edf8db1cb134d859ca8db54564e93584b98.jpg", @"http://e.hiphotos.baidu.com/lvpics/h=800/sign=1d1cc1876a81800a71e5840e813533d6/5366d0160924ab185b6fd93f33fae6cd7b890bb8.jpg", @"http://f.hiphotos.baidu.com/lvpics/h=800/sign=8430a8305cee3d6d3dc68acb73176d41/9213b07eca806538d9da1f8492dda144ad348271.jpg", @"http://d.hiphotos.baidu.com/lvpics/w=1000/sign=81bf893e12dfa9ecfd2e521752e0f603/242dd42a2834349b705785a7caea15ce36d3bebb.jpg", @"http://f.hiphotos.baidu.com/lvpics/w=1000/sign=4d69c022ea24b899de3c7d385e361c95/f31fbe096b63f6240e31d3218444ebf81a4ca3a0.jpg"];
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140) WithImageUrls:UrlStringArray];
    
    
    picView.placeImage = [UIImage imageNamed:@"timeline_image_loading.png"];
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    picView.AutoScrollDelay = 2.0f;
    
    
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        
    }];
    
    
    self.tableView.tableHeaderView = picView;

}

#pragma -mark -------Data---------

-(void)initData
{
    self.orderItems = [NSMutableArray arrayWithCapacity:1];
}

-(void)configData
{
    BarristerOrderModel *model4 = [[BarristerOrderModel alloc] init];
    model4.customerName = @"用户134****7654";
    model4.userHeder = @"http://img4.duitang.com/uploads/item/201508/26/20150826212734_ST5BC.thumb.224_0.jpeg";
    model4.startTime = @"2016/04/24 13:00";
    model4.endTime = @"2016/03/24 14:00";
    model4.caseType = @"债务纠纷";
    model4.orderType = BarristerOrderTypeYYZX;
    
    BarristerOrderModel *model5 = [[BarristerOrderModel alloc] init];
    model5.userHeder = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=327417392,2097894166&fm=116&gp=0.jpg";
    model5.customerName = @"用户158****0087";
    model5.startTime = @"2016/04/25 14:00";
    model5.endTime = @"2016/04/25 15:00";
    model5.caseType = @"财产纠纷";
    model5.orderType = BarristerOrderTypeYYZX;
    
    BarristerOrderModel *model6 = [[BarristerOrderModel alloc] init];
    model6.userHeder = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=731016823,2238050103&fm=116&gp=0.jpg";
    model6.customerName = @"用户186****7339";
    model6.startTime = @"2016/04/26 15:00";
    model6.endTime = @"2016/04/26 16:00";
    model6.caseType = @"民事案件";
    model6.orderType = BarristerOrderTypeYYZX;
    
    [self.orderItems addObject:model4];
    [self.orderItems addObject:model5];
    [self.orderItems addObject:model6];
    
    
    
    [self.tableView reloadData];

}


#pragma -mark ----TableViewDelegate Methods---------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return self.orderItems.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HomeAccountCell *cell = [[HomeAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *identifi = @"identifi";
        OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            cell = [[OrderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        }
        BarristerOrderModel *model = (BarristerOrderModel *)[self.orderItems objectAtIndex:indexPath.row];
        cell.model = model;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [HomeAccountCell getCellHeight];
    }
    else
    {
        return 75;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.accountHeadView;
    }
    else
    {
        
        return self.daiBanHeadView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.accountHeadView.height;
    }
    else
    {
        return 55;
    }
}

#pragma -mark ------Action------------

/**
 *  登录的方法
 *
 *  @param sender sender description
 */
-(void)toLoginAction:(id)sender
{
    BarristerLoginVC *loginVC = [[BarristerLoginVC alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

#pragma -mark ----Getter-----

-(UIView *)accountHeadView
{
    if (!_accountHeadView) {
        _accountHeadView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 90)];
        _accountHeadView.backgroundColor = [UIColor whiteColor];
        
        UIView *topBGView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 45)];
        topBGView.backgroundColor = RGBCOLOR(241,242, 243);
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:RECT((SCREENWIDTH - 110)/2.0, 15, 110, 15)];
        stateLabel.text = @"当前状态:正常接单";
        stateLabel.textColor = RGBCOLOR(63, 39, 22);
        stateLabel.font = SystemFont(13.0f);
        
        UIImageView *lightImage = [[UIImageView alloc] initWithFrame:RECT(stateLabel.x - 15, (45 - 10)/2.0, 10, 10)];
        [lightImage setBackgroundColor:RGBCOLOR(54, 182, 31)];
        lightImage.layer.cornerRadius = 5.0f;
        lightImage.layer.masksToBounds = YES;
        
        [topBGView addSubview:stateLabel];
        [topBGView addSubview:lightImage];

        
        [_accountHeadView addSubview:topBGView];

        
        UILabel *dindan = [[UILabel alloc] initWithFrame:RECT(LeftPadding, topBGView.height + 15, 100, 15)];
        dindan.text = @"订单统计";
        dindan.textAlignment = NSTextAlignmentLeft;
        dindan.textColor = KColorGray4;
        dindan.font = [UIFont boldSystemFontOfSize:15.0f];
        [_accountHeadView addSubview:dindan];
        
        UIImageView *rightRow = [[UIImageView alloc] initWithFrame:RECT(SCREENWIDTH - 10 - 15, dindan.y, 15, 15)];
        rightRow.image = [UIImage imageNamed:@"rightRow.png"];
        
        UILabel *leiji = [[UILabel alloc] initWithFrame:RECT(rightRow.x - 200 - 10, dindan.y, 200, 15)];
        leiji.text = @"累计订单 23";
        leiji.textAlignment = NSTextAlignmentRight;
        leiji.textColor = KColorGray2;
        leiji.font = SystemFont(14.0f);
        
        [_accountHeadView addSubview:rightRow];
        
        [_accountHeadView addSubview:leiji];
        
        [_accountHeadView addSubview:[self getLineViewWithFrame:RECT(0, _accountHeadView.height - 1, SCREENWIDTH, 1)]];

    }
    return _accountHeadView;
}

-(UIView *)daiBanHeadView
{
    if (!_daiBanHeadView) {
        
        _daiBanHeadView =[[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 55)];
        _daiBanHeadView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 10)];
        topView.backgroundColor = RGBCOLOR(241,242, 243);
        [_daiBanHeadView addSubview:topView];
        
        
        UILabel *daiban = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 15 + topView.height, 100, 15)];
        daiban.text = @"待办事项";
        daiban.textAlignment = NSTextAlignmentLeft;
        daiban.textColor = KColorGray4;
        daiban.font = [UIFont boldSystemFontOfSize:15.0f];
        [_daiBanHeadView addSubview:daiban];

        [_daiBanHeadView addSubview:[self getLineViewWithFrame:RECT(0, _daiBanHeadView.height - 1, SCREENWIDTH, 1)]];

    }
    return _daiBanHeadView;
}



@end
