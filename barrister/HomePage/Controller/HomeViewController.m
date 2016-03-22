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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ----UI---------

-(void)initView
{
    [self initBannerView];
}

-(void)initBannerView
{
    NSArray *UrlStringArray = @[@"http://e.hiphotos.baidu.com/lvpics/h=800/sign=61e9995c972397ddc97995046983b216/35a85edf8db1cb134d859ca8db54564e93584b98.jpg", @"http://e.hiphotos.baidu.com/lvpics/h=800/sign=1d1cc1876a81800a71e5840e813533d6/5366d0160924ab185b6fd93f33fae6cd7b890bb8.jpg", @"http://f.hiphotos.baidu.com/lvpics/h=800/sign=8430a8305cee3d6d3dc68acb73176d41/9213b07eca806538d9da1f8492dda144ad348271.jpg", @"http://d.hiphotos.baidu.com/lvpics/w=1000/sign=81bf893e12dfa9ecfd2e521752e0f603/242dd42a2834349b705785a7caea15ce36d3bebb.jpg", @"http://f.hiphotos.baidu.com/lvpics/w=1000/sign=4d69c022ea24b899de3c7d385e361c95/f31fbe096b63f6240e31d3218444ebf81a4ca3a0.jpg"];
    
    
//    NSArray *titleArray = [@"第一张图片.第二张图片.第三张图片.第四张图片.第五张图片" componentsSeparatedByString:@"."];
    
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140) WithImageUrls:UrlStringArray];
    
//    picView.titleData = titleArray;
    
    picView.placeImage = [UIImage imageNamed:@"timeline_image_loading.png"];
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 2.0f;
    
    [self.view addSubview:picView];
    
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
    

}   



@end
