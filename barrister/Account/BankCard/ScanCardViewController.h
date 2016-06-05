//
//  ScanCardViewController.h
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class BankCardModel;

typedef void (^cardInfoBlock)(BankCardModel* cardModel);

@interface ScanCardViewController : BaseViewController


@property (nonatomic,copy) cardInfoBlock cardBlock;
@end
