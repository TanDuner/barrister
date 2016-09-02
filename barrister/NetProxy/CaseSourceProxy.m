//
//  CaseSourceProxy.m
//  barrister
//
//  Created by 徐书传 on 16/8/23.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "CaseSourceProxy.h"
#import "AFHTTPSessionManager.h"

#define AttachCaseUrl @"buyCase.do"
#define BackCaseUrl @"giveCaseBack.do"

#define UpdateCaseUrl @"updateCaseProgress.do"
#import "NSMutableURLRequest+PostFile.h"
@interface CaseSourceProxy ()

@property (nonatomic, strong) NSMutableData *mResponseData;

@end

@implementation CaseSourceProxy

/**
 *  接案源
 *
 *  @param aParams
 *  @param aBlock  返回block
 */
-(void)attachCaseSourceWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:aParams];
    [XuNetWorking postWithUrl:AttachCaseUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
            }
            else
            {
                aBlock(CommonNetErrorTip,NO);
            }
            
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(CommonNetErrorTip,NO);
        }
    }];
}

/**
 *  退回案源
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)backCaseSourceWithParams:(NSMutableDictionary *)aParams Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:aParams];
    [XuNetWorking postWithUrl:BackCaseUrl params:aParams success:^(id response) {
        if (aBlock) {
            if ([self isCommonCorrectResultCodeWithResponse:response]) {
                aBlock(response,YES);
            }
            else
            {
                aBlock(CommonNetErrorTip,NO);
            }
            
        }
    } fail:^(NSError *error) {
        if (aBlock) {
            aBlock(CommonNetErrorTip,NO);
        }
    }];

}


/**
 *  更新案源
 *
 *  @param aParams
 *  @param aBlock
 */
-(void)updateCaseSourceWithParams:(NSMutableDictionary *)params imageData:(NSData *)imageData Block:(ServiceCallBlock)aBlock
{
    [self appendCommonParamsWithDict:params];

    AFHTTPSessionManager *manager = [XuNetWorking manager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",[XuNetWorking baseUrl],UpdateCaseUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (aBlock && [self isCommonCorrectResultCodeWithResponse:responseObject]) {
            aBlock(responseObject,YES);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (aBlock) {
            aBlock(@"网络错误,请稍后重试",NO);
        }
    }];
    
    
//    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[XuNetWorking baseUrl],UpdateCaseUrl]] andFilenName:@"pic" andImageData:imageData];
//
//
//    [request setValue:@"1" forKey:@"hasContract"];
//    [request setValue:aContractMoney forKey:@"contractMoney"];
//    [request setValue:aPercentagePayment forKey:@"percentagePayment"];
//    [request setValue:[BaseDataSingleton shareInstance].userModel.userId forKey:@"userId"];
//    [request setValue:[BaseDataSingleton shareInstance].userModel.verifyCode forKey:@"verifyCode"];
//    
//    
//    NSURLSession *session=[NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        id result=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"post==%@",result);
//        
//    }];
//    [dataTask resume];
    
    
    
    
    
//    AFHTTPSessionManager *manager = [XuNetWorking manager];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[XuNetWorking baseUrl],UpdateCaseUrl]]];
//    XuURLSessionTask *session = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
//        if (progress) {
//            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
//        }
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        NSLog(@"%@",@"xxx");
//    }];
    
    return;
    
    
    //上传的接口
    NSURL* urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[XuNetWorking baseUrl],UpdateCaseUrl]];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlStr
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                        timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //    //要上传的图片
    //    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data

    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"pic.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: jpg/jpeg/image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method  
    [request setHTTPMethod:@"POST"];  
    
    //建立连接，设置代理  
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    
    //设置接受response的data  
    if (conn) {  
        _mResponseData = [[NSMutableData alloc] init];  
    }

}



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_mResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:_mResponseData options:kNilOptions error:nil];
    NSLog(@"%@", dic);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}


@end
