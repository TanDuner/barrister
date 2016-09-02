//
//  CaseSourceProxy.h
//  barrister
//
//  Created by 徐书传 on 16/8/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseNetProxy.h"

@interface CaseSourceProxy : BaseNetProxy

/**
 *  接案源
 *
 *  @param aParams
 *  @param aBlock  返回block
 */
-(void)attachCaseSourceWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock;

/**
 *  退回案源
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)backCaseSourceWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock;



/**
 *  更新案源
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)updateCaseSourceWithParams:(NSMutableDictionary *)params imageData:(NSData *)imageData Block:(ServiceCallBlock)aBlock;

@end
