//
//  BaseDataSingleton.m
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseDataSingleton.h"
#import "SandboxFile.h"

//static BaseDataSingleton *_instance;
//
//const static NSString* archiveFileName = @"barrister.dat";


@implementation BaseDataSingleton


+ (instancetype)shareInstance
{
    static BaseDataSingleton *dataSingleTon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSingleTon = [[self alloc] init];
        [dataSingleTon getLoginState];
    });
    
    return dataSingleTon;
}


-(void )getLoginState
{
    NSString *validCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    NSString *loginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    self.userModel.verifyCode = validCode;
    self.loginState = loginState;
    self.userModel.phone = phone;
}

-(void)setLoginStateWithValidCode:(NSString *)validCode Phone:(NSString *)phone
{
    self.loginState = @"1";
    self.userModel.verifyCode = validCode;
    [[NSUserDefaults standardUserDefaults] setObject:validCode forKey:@"verifyCode"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginState"];
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//+ (instancetype)shareInstance
//{
//    
//    @synchronized(self) {
//        if (_instance == nil) {
//            
//            NSString* documentDirectory = [SandboxFile GetDocumentPath];
//            NSString* archivePath =[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName];
//            _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
////            [_instance initData];
//        }
//        if (_instance == nil) {
//            _instance = [[self alloc] init];
//            [_instance initData];
//        }
//        
//    }
//    return _instance;
//}

-(void)initData
{
    self.remainingBalance = @"300";
    self.totalIncome = @"0";
    self.loginState = @"0";
    
}


-(void)logoOut
{
    self.userModel = nil;
    self.loginState = 0;
    self.remainingBalance = @"0";
    self.totalIncome = @"0";
    self.loginState = @"0";

}


//-(BOOL) archive {
//    NSString* documentDirectory = [SandboxFile GetDocumentPath];
//    return [NSKeyedArchiver archiveRootObject:self
//                                       toFile:[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName]];
//}
//
//-(void) encodeWithCoder:(NSCoder *)aCoder {
//    
//    [aCoder encodeObject:self.loginState forKey:@"loginState"];
//    [aCoder encodeObject:self.appointStatus forKey:@"appointStatus"];
//    [aCoder encodeObject:self.orderQty forKey:@"orderQty"];
//    [aCoder encodeObject:self.remainingBalance forKey:@"remainBalance"];
//    [aCoder encodeObject:self.totalIncome forKey:@"totalIncome"];
//
//    
//}
//
//-(id) initWithCoder:(NSCoder *)aDecoder {
//    
//    self.loginState = [aDecoder decodeObjectForKey:@"loginState"];
//    self.appointStatus = [aDecoder decodeObjectForKey:@"appointStatus"];
//    self.orderQty = [aDecoder decodeObjectForKey:@"orderQty"];
//    self.remainingBalance = [aDecoder decodeObjectForKey:@"remainBalance"];
//    self.totalIncome = [aDecoder decodeObjectForKey:@"totalIncome"];
//    
//    
//    return self;
//} 



@end
