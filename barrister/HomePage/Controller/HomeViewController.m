
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
#import "HomePageProxy.h"
#import "AppointmentViewController.h"
#import "TiXianViewControlleer.h"
#import "BarristerLoginManager.h"
#import "HomeBannerModel.h"
#import "XuPushManager.h"

#import "BaseWebViewController.h"
#import "HomeCaseSourceCell.h"
#import "HomeCaseListModel.h"
#import "CaseSourceViewController.h"

#import "OrderDetailViewController.h"

@interface HomeViewController ()

@property (nonatomic,strong) NSMutableArray *orderItems;
@property (nonatomic,strong) UIView *accountHeadView;
@property (nonatomic,strong) UIView *daiBanHeadView;
@property (nonatomic,strong) UIImageView *lightImage;
@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,strong) UILabel *leijiLabel;

@property (nonatomic,strong) DCPicScrollView *bannerView;
@property (nonatomic,strong) HomePageProxy *proxy;
@property (nonatomic,strong) NSMutableArray *bannerItems;


@property (nonatomic,strong) NSMutableArray *caseSourceItems;

@property (nonatomic,strong) UIView *caseSourceView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:YES];
    if ([BaseDataSingleton shareInstance].loginState.intValue != 1) {
        [[BarristerLoginManager shareManager] showLoginViewControllerWithController:self];
    }
    else
    {
        [[BarristerLoginManager shareManager] userAutoLogin];
    }
    [[XuPushManager shareInstance] handleUnActiveMsg];
    
    
}




#pragma -mark -------Data---------

-(void)initData
{
    self.orderItems = [NSMutableArray arrayWithCapacity:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccessAciton:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    if ([[BaseDataSingleton shareInstance].loginState isEqualToString:@"1"]) {
        [BarristerLoginManager shareManager].showController  = self;
        [[BarristerLoginManager shareManager] userAutoLogin];
    }
}

-(void)LoginSuccessAciton:(NSNotification *)nsnotifi
{
    [self.orderItems removeAllObjects];
    [self loadAccountData];
    [self loadCaseSourceData];

}

-(void)loadCaseSourceData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",@"pageSize",@"1",@"page", nil];
    
    __weak typeof(*&self) weakSelf = self;
    
    [self.proxy getCaseListWithParams:params Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            [weakSelf handleSourceListWithDict:dict];
        }
        else
        {
            
        }
    }];
}


-(void)handleSourceListWithDict:(NSDictionary *)params
{
    
    NSArray *array = (NSArray *)[params objectForKey:@"cases"];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = (NSDictionary *)[array safeObjectAtIndex:i];
        HomeCaseListModel *model = [[HomeCaseListModel alloc] initWithDictionary:dict];
        [self.caseSourceItems addObject:model];
    }
    
    [self.tableView reloadData];
    
}



-(void)configData
{
    
    [self loadBannerData];
    
}

-(void)loadBannerData
{
    
    [self.proxy getHomePageBannerWithParams:nil Block:^(id returnData, BOOL success) {
        if (success) {
            NSDictionary *dict = (NSDictionary *)returnData;
            if ([dict respondsToSelector:@selector(objectForKey:)]) {
                NSArray *listArray = [dict objectForKey:@"list"];
                [self handleBannerDataWithArray:listArray];
            }
        }
   
    }];
}

-(void)loadAccountData
{

    NSMutableDictionary *aParams = [NSMutableDictionary dictionary];
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
    [aParams setObject:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
   [_proxy getHomePageAccountDataWithParams:aParams Block:^(id returnData, BOOL success) {
       if (success) {
           NSDictionary *dict = (NSDictionary *)returnData;
           NSString *resultCode = [dict objectForKey:@"resultCode"];
           if (resultCode.integerValue == 200) {
               [self handleAccountDataWithDict:dict];
           }
       }
       else
       {
       
       }
   }];
}


-(void)handleAccountDataWithDict:(NSDictionary *)dict
{
    
    NSString *appintmentStatus = [dict objectForKey:@"status"];
    
    [BaseDataSingleton shareInstance].status = appintmentStatus?appintmentStatus:@"can_not";

    
    [BaseDataSingleton shareInstance].remainingBalance = [dict objectForKey:@"remainingBalance"];
    [BaseDataSingleton shareInstance].totalIncome = [dict objectForKey:@"totalIncome"];
    [BaseDataSingleton shareInstance].orderQty = [dict objectForKey:@"orderQty"];
    
    [self updateAppointmentStatus];
    
    [self.tableView reloadData];
    
    NSArray *array = [dict objectForKey:@"todoList"];
    
    if ([XuUtlity isValidArray:array]) {

        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dict = [array safeObjectAtIndex:i];
            BarristerOrderModel *model = [[BarristerOrderModel alloc] initWithDictionary:dict];
            [self.orderItems addObject:model];
        }
        [self.tableView reloadData];

    }

}


-(void)handleBannerDataWithArray:(NSArray *)array
{
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array safeObjectAtIndex:i];
        HomeBannerModel *model = [[HomeBannerModel alloc] initWithDictionary:dict];
        [self.bannerItems addObject:model];
        [imageUrls addObject:model.image];
    }
    
    [self setBannerViewWithUrls:imageUrls];

}



#pragma -mark ----TableViewDelegate Methods---------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return self.caseSourceItems.count;
    }
    else if (section == 2)
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
        __weak typeof(*&self) weakSelf = self;
        cell.ActionBlock = ^(id object ,BaseTableViewCell *cellTemp)
        {
            [weakSelf tixianAction];
        };
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1)
    {

        static NSString *identifi  = @"identifi1";
        HomeCaseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            cell = [[HomeCaseSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        if (self.caseSourceItems.count > indexPath.row) {
            HomeCaseListModel *model = [self.caseSourceItems safeObjectAtIndex:indexPath.row];
            cell.model = model;
            
        }
        
        return cell;
    }
    else
    {
        static NSString *identifi = @"identifi";
        OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            cell = [[OrderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        }
        if (self.orderItems.count > indexPath.row) {
            BarristerOrderModel *model = (BarristerOrderModel *)[self.orderItems safeObjectAtIndex:indexPath.row];
            cell.model = model;
        }


        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [HomeAccountCell getCellHeight];
    }
    else if(indexPath.section == 1)
    {
        if (self.caseSourceItems.count > indexPath.row) {
            HomeCaseListModel *model  = (HomeCaseListModel *)[self.caseSourceItems safeObjectAtIndex:indexPath.row];
            return [HomeCaseSourceCell getCellHeightWithModel:model];
        }
        return 0;
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
    else if (section == 1)
    {
        return self.caseSourceView;
    }
    else
    {
        if (self.orderItems.count > 0) {
            return self.daiBanHeadView;
        }
        else
        {
            return [UIView new];
        }

    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.accountHeadView.height;
    }
    else if(section == 1)
    {
        if (self.caseSourceItems.count > 0) {
            return 55;
        }
        else
        {
            return 0;
        }

    }
    else if (section == 2)
    {
        if (self.orderItems.count > 0) {
            return 55;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (self.orderItems.count > indexPath.row) {
            BarristerOrderModel *model = (BarristerOrderModel *)[self.orderItems safeObjectAtIndex:indexPath.row];
            OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] initWithOrderId:model.orderId];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        

    }
}

#pragma -mark ------Action------------
-(void)toCaseListVC:(UITapGestureRecognizer *)tap
{
    CaseSourceViewController*caseSourceVC = [[CaseSourceViewController alloc] init];
    [self.navigationController pushViewController:caseSourceVC animated:YES];
}


#pragma -mark ----Getter-----

-(DCPicScrollView *)setBannerViewWithUrls:(NSArray *)urlStrings
{
    if (!_bannerView) {
        _bannerView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140) WithImageUrls:urlStrings];
        _bannerView.placeImage = [UIImage imageNamed:@"timeline_image_loading.png"];

        __weak typeof(*&self) weakSelf = self;
        [_bannerView setImageViewDidTapAtIndex:^(NSInteger index) {
            if (weakSelf.bannerItems.count > index) {
                HomeBannerModel *model = [weakSelf.bannerItems safeObjectAtIndex:index];
                
                BaseWebViewController *webView = [[BaseWebViewController alloc] init];
                webView.showTitle = model.title;
                webView.url = model.url;
                
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }

        }];
        
        _bannerView.AutoScrollDelay = 2.0f;
        
        //下载失败重复下载次数,默认不重复,
        [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
        
        //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
        [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
            
        }];
        
        self.tableView.tableHeaderView = _bannerView;

        [self.tableView reloadData];
    }
    return _bannerView;
}


-(UIView *)accountHeadView
{
    if (!_accountHeadView) {
        _accountHeadView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 90)];
        _accountHeadView.backgroundColor = [UIColor whiteColor];
        
        UIView *topBGView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 45)];
        topBGView.backgroundColor = RGBCOLOR(241,242, 243);
        
        _stateLabel = [[UILabel alloc] initWithFrame:RECT((SCREENWIDTH - 110)/2.0, 15, 110, 15)];
        _stateLabel.text = @"当前状态:不可接单";
        _stateLabel.textColor = RGBCOLOR(63, 39, 22);
        _stateLabel.font = SystemFont(13.0f);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingTimeAciton)];
        _stateLabel.userInteractionEnabled = YES;
        [_stateLabel addGestureRecognizer:tap];
        
        
        _lightImage = [[UIImageView alloc] initWithFrame:RECT(_stateLabel.x - 15, (45 - 10)/2.0, 10, 10)];
        [_lightImage setBackgroundColor:[UIColor redColor]];
        _lightImage.layer.cornerRadius = 5.0f;
        _lightImage.layer.masksToBounds = YES;
        
        [topBGView addSubview:_stateLabel];
        [topBGView addSubview:_lightImage];

        
        [_accountHeadView addSubview:topBGView];

        
        UILabel *dindan = [[UILabel alloc] initWithFrame:RECT(LeftPadding, topBGView.height + 15, 100, 15)];
        dindan.text = @"订单统计";
        dindan.textAlignment = NSTextAlignmentLeft;
        dindan.textColor = KColorGray222;
        dindan.font = [UIFont boldSystemFontOfSize:15.0f];
        [_accountHeadView addSubview:dindan];
        
        UIImageView *rightRow = [[UIImageView alloc] initWithFrame:RECT(SCREENWIDTH - 10 - 15, dindan.y, 15, 15)];
        rightRow.image = [UIImage imageNamed:@"rightRow.png"];
        
        self.leijiLabel = [[UILabel alloc] initWithFrame:RECT(rightRow.x - 200 - 10, dindan.y, 200, 15)];
        self.leijiLabel.text = [NSString stringWithFormat:@"累计订单%@",[BaseDataSingleton shareInstance].orderQty?[BaseDataSingleton shareInstance].orderQty:@"0"];
        self.leijiLabel.textAlignment = NSTextAlignmentRight;
        self.leijiLabel.textColor = KColorGray666;
        self.leijiLabel.font = SystemFont(14.0f);
        
        [_accountHeadView addSubview:rightRow];
        
        [_accountHeadView addSubview:self.leijiLabel];
        
        [_accountHeadView addSubview:[self getLineViewWithFrame:RECT(0, _accountHeadView.height - .5, SCREENWIDTH, .5)]];

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
        daiban.textColor = KColorGray222;
        daiban.font = [UIFont boldSystemFontOfSize:15.0f];
        [_daiBanHeadView addSubview:daiban];

        [_daiBanHeadView addSubview:[self getLineViewWithFrame:RECT(0, _daiBanHeadView.height - .5, SCREENWIDTH, .5)]];

    }
    return _daiBanHeadView;
}


-(UIView *)caseSourceView
{
    if (!_caseSourceView) {
        _caseSourceView =[[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 55)];
        _caseSourceView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, 10)];
        topView.backgroundColor = RGBCOLOR(241,242, 243);
        [_caseSourceView addSubview:topView];
        
        
        UILabel *anyuan = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 15 + topView.height, 100, 15)];
        anyuan.text = @"案源列表";
        anyuan.textAlignment = NSTextAlignmentLeft;
        anyuan.textColor = KColorGray222;
        anyuan.font = [UIFont boldSystemFontOfSize:15.0f];
        [_caseSourceView addSubview:anyuan];
        
        UIImageView *rightRow = [[UIImageView alloc] initWithFrame:RECT(SCREENWIDTH - 10 - 15, anyuan.y, 15, 15)];
        rightRow.image = [UIImage imageNamed:@"rightRow.png"];
        rightRow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCaseListVC:)];
        [rightRow addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:RECT(rightRow.x - 200 - 10, anyuan.y, 200, 15)];
        label.text = @"查看更多";
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = KColorGray666;
        label.font = SystemFont(14.0f);
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCaseListVC:)];
        [label addGestureRecognizer:tap1];
        
        [_caseSourceView addSubview:rightRow];
        [_caseSourceView addSubview:label];
        
        [_caseSourceView addSubview:[self getLineViewWithFrame:RECT(0, _caseSourceView.height - .5, SCREENWIDTH, .5)]];
        
    }
    return _caseSourceView;
}

-(HomePageProxy *)proxy
{
    if (!_proxy) {
        _proxy = [[HomePageProxy alloc] init];
    }
    return _proxy;
}

-(NSMutableArray *)bannerItems
{
    if (!_bannerItems) {
        _bannerItems = [NSMutableArray arrayWithCapacity:5];
    }
    return _bannerItems;
}

-(NSMutableArray *)caseSourceItems
{
    if (!_caseSourceItems) {
        _caseSourceItems = [NSMutableArray arrayWithCapacity:5];
    }
    return _caseSourceItems;
}

#pragma -mark -------Aciton-----

/**
 *  接单状态设置
 */

-(void)settingTimeAciton
{
    
    if ([[BaseDataSingleton shareInstance].status isEqualToString:ORDER_STATUS_CAN]) {
        [XuUItlity showYesOrNoAlertView:@"确定" noText:@"取消" title:@"提示" mesage:@"确定改成不可接单状态吗" callback:^(NSInteger buttonIndex, NSString *inputString) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"can_not",@"status", nil];
            if (buttonIndex == 1) {
                __weak typeof(*&self) weakSelf = self;
                [self.proxy setStatuWithParams:params Block:^(id returnData, BOOL success) {
                    if (success) {
                        [XuUItlity showSucceedHint:@"设置成功" completionBlock:nil];
                        [BaseDataSingleton shareInstance].status = ORDER_STATUS_NOT;
                    }
                    else
                    {
                        [XuUItlity showFailedHint:@"设置失败" completionBlock:nil];

                    };
                    [weakSelf updateAppointmentStatus];
                }];
            }
            else
            {
                //取消
            }
        }];
    }
  else
  {
      
      [XuUItlity showYesOrNoAlertView:@"确定" noText:@"取消" title:@"提示" mesage:@"确定改成可接单状态吗" callback:^(NSInteger buttonIndex, NSString *inputString) {
          NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"can",@"status", nil];
          if (buttonIndex == 1) {
                __weak typeof(*&self) weakSelf = self;
              [self.proxy setStatuWithParams:params Block:^(id returnData, BOOL success) {
                  if (success) {
                      [XuUItlity showSucceedHint:@"设置成功" completionBlock:nil];
                      [BaseDataSingleton shareInstance].status = ORDER_STATUS_CAN;
                  }
                  else
                  {
                      [XuUItlity showFailedHint:@"设置失败" completionBlock:nil];
                      
                  };
                  [weakSelf updateAppointmentStatus];
                  
              }];
          }
          else
          {
              //取消
          }
      }];
  }

}

-(void)updateAppointmentStatus
{
    if ([[BaseDataSingleton shareInstance].status isEqualToString:ORDER_STATUS_NOT]) {
        self.stateLabel.text = @"当前状态:不可接单";
        self.lightImage.backgroundColor = [UIColor redColor];
    }

    else
    {
        self.stateLabel.text = @"当前状态:正常接单";
        self.lightImage.backgroundColor = RGBCOLOR(54, 182, 31);
    }
    self.leijiLabel.text = [NSString stringWithFormat:@"累计订单 %@",[BaseDataSingleton shareInstance].orderQty];
}

-(void)tixianAction
{
    TiXianViewControlleer *tixianVC = [[TiXianViewControlleer alloc] init];
    [self.navigationController pushViewController:tixianVC animated:YES];
}

@end
