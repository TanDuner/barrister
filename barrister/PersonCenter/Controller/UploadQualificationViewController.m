//
//  UploadQualificationViewController.m
//  barrister
//
//  Created by 徐书传 on 16/6/13.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "UploadQualificationViewController.h"
#import "UploadQualificaitonModel.h"
#import "UploadQualificationCell.h"


@interface UploadQualificationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *items;
@end

@implementation UploadQualificationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    [self configData];
}

#pragma -mark --Data--
-(void)configData
{
    self.items = [NSMutableArray arrayWithCapacity:5];
    UploadQualificaitonModel *model1 = [[UploadQualificaitonModel alloc] init];
    model1.title = @"法律职业资格证书";
    model1.uploadType = UploadTypeGnvqs;
    
    UploadQualificaitonModel *model2 = [[UploadQualificaitonModel alloc] init];
    model2.title = @"执业证书";
    model2.uploadType = UploadTypeCertificate;
    
    UploadQualificaitonModel *model3 = [[UploadQualificaitonModel alloc] init];
    model3.title = @"执业证书年检页";
    model3.uploadType = UploadTypeYear;
    
    UploadQualificaitonModel *model4 = [[UploadQualificaitonModel alloc] init];
    model4.title = @"身份证正面";
    model4.uploadType = UploadTypeCard;
    
    UploadQualificaitonModel *model5 = [[UploadQualificaitonModel alloc] init];
    model5.title = @"身份证反面";
    model5.uploadType = UploadTypeCard;
    
    [self.items addObject:model1];
    [self.items addObject:model2];
    [self.items addObject:model3];
    [self.items addObject:model4];
    [self.items addObject:model5];
}

#pragma -mark -----UI------

-(void)configView
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar:NO];
}

#pragma -mark -----UITableView Delegate Methods------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"identifiUpload";
    UploadQualificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UploadQualificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    if (self.items.count > indexPath.row) {
        UploadQualificaitonModel *modelTemp = [self.items objectAtIndex:indexPath.row];
        cell.model = modelTemp;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
