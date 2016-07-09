//
//  AppDelegate.m
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

//13301096303
//638964
//18515058521
//159153

#import "AppDelegate.h"
#import "XuNetWorking.h"
#import "OpenUDID.h"
#import "UMMobClick/MobClick.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "JPUSHService.h"
#import "XuPushManager.h"
#import "IMVersionManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
/**
 *  选择tab 的Index
 *
 *  @param index 序号
 */

-(void)selectTabWithIndex:(NSInteger)index
{
    _tabBarCTL.selectedIndex = index;
}

-(void)initControllersAndConfig
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _tabBarCTL = [[BaseTabbarController alloc] init];
    [IMVersionManager shareInstance];
    self.window.rootViewController = _tabBarCTL;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

-(void)initNetWorkingData
{
    [XuNetWorking updateBaseUrl:BaseUrl];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    [headerDict setObject:[OpenUDID value] forKey:@"X-DEVICE-NUM"];
    [headerDict setObject:[NSString stringWithFormat:@"ios-%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] forKey:@"X-VERSION"];
    [headerDict setObject:[[UIDevice currentDevice] model] forKey:@"X-TYPE"];
    [headerDict setObject: @"ios" forKey:@"X-SYSTEM"];
    [headerDict setObject:[XuUtlity getIOSVersion] forKey:@"X-SYSTEM-VERSION"];
    [headerDict setObject:[NSString stringWithFormat:@"%f*%f",SCREENWIDTH ,SCREENHEIGHT] forKey:@"X-SCREEN"];
    [headerDict setObject:@"appleStore" forKey:@"X-MARKET"];
    if ([BaseDataSingleton shareInstance].userModel != nil) {
        [headerDict setObject:[BaseDataSingleton shareInstance].userModel.userId forKey:@"X-UID"];
    }
    
    [XuNetWorking configCommonHttpHeaders:headerDict];
    
    //打开debug开关
    [XuNetWorking enableInterfaceDebug:YES];
}

-(void)initUMData
{
    UMConfigInstance.appKey = @"577b28cc67e58e0fd00005d5";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.appKey = @"577b28cc67e58e0fd00005d5";
    [MobClick startWithConfigure:UMConfigInstance];
    
}

-(void)initCallAction
{
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"Call is incoming");
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"call is dialing");
        }
        else
        {
            NSLog(@"Nothing is done");
        }
    };

}


/**
 *  初始化极光的环境 push 相关
 *
 *
 */

-(void)initJPushWithLaunchOptions:(NSDictionary  *)launchOptions
{
    /**
     *  注册极光push
     */
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    
    
    NSDictionary *remoteDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteDic) {
        NSLog(@"%@",[[remoteDic objectForKey:@"aps"] objectForKey:@"alert"]);

        [[XuPushManager shareInstance] receivePushMsgByUnActive:remoteDic];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"App Store" apsForProduction:NO];
    
    [[XuPushManager shareInstance] setJPushTags:[NSSet set] Alias:@"xxxx"];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initCallAction];
    
    [self initUMData];
    
    [self initJPushWithLaunchOptions:launchOptions];
    
    
    [self initControllersAndConfig];
    
    
    [self initNetWorkingData];
   
    return YES;
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)applicationWillResignActive:(UIApplication *)application {

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
