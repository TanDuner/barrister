//
//  MeNetProxy.m
//  barrister
//
//  Created by 徐书传 on 16/5/16.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "MeNetProxy.h"
#define GetAppointDataUrl @"getMyAppointmentSettings.do"
#define SetAppointDataUrl @"setAppointmentSettings.do"
#define UploadHeadImageUrl @"uploadUserIcon.do"
#define AreaAndTypeUrl @"bizAreaAndBizTypeList.do?"
#define UpdateUserInfo @"updateUserInfo.do"
#define UploadAuthUrl @"uploadFiles.do"
#define TixianUrl @"getMoney.do";
#define MyMessageUrl @"getMyMsgs.do"

#define FeedBackUrl @"addFeedback.do"


@implementation MeNetProxy
/**
 *  获取预约设置的数据
 *
 *  @param params 请求参数
 *  @param aBlock 处理block
 */
-(void)getAppointDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:GetAppointDataUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            if (aBlock) {
                aBlock(response,YES);
            }
        }
        else{
            aBlock(CommonNetErrorTip,NO);
        }
       
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
    }];
}

/**
 *  设置预约的数据
 *
 *  @param params 参数
 *  @param aBlock 回调
 */
-(void)setAppintDataWithParams:(NSDictionary *)params Block:(ServiceCallBlock)aBlock
{
    [XuNetWorking getWithUrl:SetAppointDataUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            if (aBlock) {
                aBlock(response,YES);
            }
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }

    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
    }];
}

/**
 *  上传头像
 *
 *  @param params 参数
 *  @param aBlock 回调
 */

-(void)UploadHeadImageUrlWithImage:(UIImage *)image
                            params:(NSMutableDictionary *)params
                          fileName:(NSString *)fileName
                             Block:(ServiceCallBlock)aBlock
{
    NSData *imageData = [XuUtlity p_compressImage:image];

    UIImage *imageTemp = [[UIImage alloc] initWithData:imageData];
    [XuNetWorking uploadWithImage:imageTemp url:UploadHeadImageUrl filename:@"userIcon" name:@"userIcon" mimeType:@"image/jpeg" parameters:params progress:nil success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
    }];
}

/**
 *  我的消息列表
 *
 *  @param params 参数
 *  @param aBlock 回调block
 */
-(void)getMyMessageWithParams:(NSMutableDictionary *)params block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];
    [XuNetWorking postWithUrl:MyMessageUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            if (aBlock) {
                aBlock(response,YES);
            }
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }


    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }

    }];
}

/**
 *  业务领域 业务类型列表
 *
 *  @param params 参数
 *  @param aBlock 回调
 */


-(void)getAreaAndTypeListWithParams:(NSMutableDictionary *)params block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:AreaAndTypeUrl params:params success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
        
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
        
    }];

}

/**
 *  修改个人信息接口
 *
 *  @param params 参数
 *  @param aBlock 回调
 */
-(void)updateUserInfoWithParams:(NSMutableDictionary *)params block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:UpdateUserInfo params:params success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
        
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
        
    }];
    
}

/**
 *  上传资格认证证书
 *
 *  @param params 参数
 *  @param aBlock 回调block
 */
-(void)UploadAuthImageUrlWithImage:(UIImage *)image
                            params:(NSMutableDictionary *)params
                          fileName:(NSString *)fileName
                             Block:(ServiceCallBlock)aBlock
{

    [XuNetWorking uploadWithImage:image url:UploadAuthUrl filename:@"userIcon" name:@"userIcon" mimeType:@"image/jpeg" parameters:params progress:nil success:^(id response) {
        if (aBlock) {
            aBlock(response,YES);
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
    }];
}


/**
 *  填写反馈接口
 *
 *  @param params <#params description#>
 *  @param aBlock <#aBlock description#>
 */
-(void)feedBackWithParams:(NSMutableDictionary *)params block:(ServiceCallBlock)aBlock
{
    [XuNetWorking postWithUrl:FeedBackUrl params:params success:^(id response) {
        if ([self isCommonCorrectResultCodeWithResponse:response]) {
            if (aBlock) {
                aBlock(response,YES);
            }
        }
        else
        {
            aBlock(CommonNetErrorTip,NO);
        }
        
        
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(error,NO);
        }
        
    }];

}



@end
