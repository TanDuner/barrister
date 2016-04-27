//
//  BaseTableViewCell.h
//  barrister
//
//  Created by 徐书传 on 16/4/6.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

-(void)configData;

-(UIView *)getLineViewWithRect:(CGRect)rect;

@end
