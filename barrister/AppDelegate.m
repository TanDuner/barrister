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
#import "BaseViewController.h"
#import "BaseNavigaitonController.h"
#import "OrderDetailViewController.h"
#import "MyAccountHomeViewController.h"
#import "MyMessageViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//在这里写针对iOS10的代码或者引用新的API
#import <UserNotifications/UserNotifications.h>

#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

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
    self.window.rootViewController = _tabBarCTL;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

-(void)initNetWorkingData
{
    [XuNetWorking updateBaseUrl:BaseUrl];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    [IMVersionManager shareInstance];
    [headerDict setObject:[OpenUDID value] forKey:@"X-DEVICE-NUM"];
    [headerDict setObject:[NSString stringWithFormat:@"ios-%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] forKey:@"X-VERSION"];
    
    if ([JPUSHService registrationID]) {
        [headerDict setObject:[JPUSHService registrationID] forKey:@"X-PUSHID"];
    }

    [headerDict setObject:[[UIDevice currentDevice] model] forKey:@"X-TYPE"];
    [headerDict setObject: @"ios" forKey:@"X-SYSTEM"];
    [headerDict setObject:[XuUtlity getIOSVersion] forKey:@"X-SYSTEM-VERSION"];
    [headerDict setObject:[NSString stringWithFormat:@"%f*%f",SCREENWIDTH ,SCREENHEIGHT] forKey:@"X-SCREEN"];
    [headerDict setObject:@"appleStore" forKey:@"X-MARKET"];
    if ([BaseDataSingleton shareInstance].userModel != nil) {
        [headerDict setObject:[NSString stringWithFormat:@"%@",[BaseDataSingleton shareInstance].userModel.userId] forKey:@"X-UID"];
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
//    /**
//     *  注册极光push
//     */
//    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                      UIRemoteNotificationTypeSound |
//                                                      UIRemoteNotificationTypeAlert)
//                                          categories:nil];
//    
//    
    NSDictionary *remoteDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteDic) {
        NSLog(@"%@",[[remoteDic objectForKey:@"aps"] objectForKey:@"alert"]);

        [[XuPushManager shareInstance] receivePushMsgByUnActive:remoteDic];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"App Store" apsForProduction:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerJPushFInish) name:kJPFNetworkDidLoginNotification object:nil];
    
}

-(void)registerJPushFInish
{
    [self initNetWorkingData];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initCallAction];
    
    [self initUMData];
    
    [self initJPushWithLaunchOptions:launchOptions];
    
    
    [self initControllersAndConfig];

    
    [self initNetWorkingData];
   
    return YES;
}



-(void)jumpToViewControllerwithType:(NSString *)type Params:(NSDictionary *)params;
{

    BaseTabbarController *mainTabVC = self.tabBarCTL;
    BaseNavigaitonController * navigationController = [mainTabVC.viewControllers objectAtIndex:mainTabVC.selectedIndex];
    

    if ([type isEqualToString:Push_Type_Order_Status_Change]||[type isEqualToString:Push_Type_Receive_Star]||[type isEqualToString:Push_Type_New_AppointmentOrder]||[type isEqualToString:Push_Type_HangOff]) {
        NSString *contentId = [params objectForKey:@"contentId"];
        
        OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] initWithOrderId:contentId];
        [navigationController pushViewController:detailVC animated:YES];
    }
    else if ([type isEqualToString:Push_Type_Order_Receive_Reward]||[type isEqualToString:Push_Type_Order_Receive_Moneny]||[type isEqualToString:Push_TYpe_Tixian_Status])
    {
        //去我的账户
        MyAccountHomeViewController *account = [[MyAccountHomeViewController alloc] init];
        [navigationController pushViewController:account animated:YES];
        
    }
    else if ([type isEqualToString:Push_Type_System_Msg])
    {
        //去系统消息
        MyMessageViewController *myMessage = [[MyMessageViewController alloc] init];
        [navigationController pushViewController:myMessage animated:YES];
        
    }
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[XuPushManager shareInstance] receivePushMsgByActive:userInfo];
    
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark- JPUSHRegisterDelegate

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [[XuPushManager shareInstance] receivePushMsgByActive:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [[XuPushManager shareInstance] receivePushMsgByActive:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

#endif


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[XuPushManager shareInstance] receivePushMsgByActive:userInfo];
    
    // Required, iOS 7 Support
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
