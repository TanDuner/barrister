//
//  BaseTableView.h
//  barrister
//
//  Created by 徐书传 on 16/3/22.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate <NSObject>

-(void)circleTableViewDidTriggerRefresh:(id)object;

-(void)circleTableViewDidLoadMoreData:(id)object;

@end

@interface BaseTableView : UITableView

@property (nonatomic,weak) id <BaseTableViewDelegate> refreshDelegate;


@end


