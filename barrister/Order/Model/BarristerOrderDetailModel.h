//
//  BarristerOrderDetailModel.h
//  barrister
//
//  Created by 徐书传 on 16/6/28.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseModel.h"


//callHistories = "<null>";
//caseType = "";
//customerIcon = "";
//customerId = 2;
//customerNickname = "";
//customerPhone = 18515058521;
//id = 2;
//payTime = "";
//paymentAmount = 30;
//remarks = "";
//status = "order.status.waiting";
//type = APPOINTMENT;

@interface BarristerOrderDetailModel : BaseModel

@property (nonatomic,strong) NSMutableArray *callHistories;
@property (nonatomic,strong) NSString *caseType;
@property (nonatomic,strong) NSString *customerIcon;
@property (nonatomic,strong) NSString *customerNickname;
@property (nonatomic,strong) NSString *customerPhone;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *payTime;
@property (nonatomic,strong) NSString *paymentAmount;
@property (nonatomic,strong) NSString *remarks;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *lawFeedback;

@property (nonatomic,assign) CGFloat markHeight;



@end
