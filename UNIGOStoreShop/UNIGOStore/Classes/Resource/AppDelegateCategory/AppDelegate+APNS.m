//
//  AppDelegate+APNS.m
//  SmartDevice
//
//  Created by singelet on 16/6/20.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AppDelegate+APNS.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (APNS)

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        // iOS 8 Notifications
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
            
            [application registerUserNotificationSettings:
             [UIUserNotificationSettings settingsForTypes:
              (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                               categories:nil]];
            [application registerForRemoteNotifications];
        }else{
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
            
        }
    }else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
//                [self setupDelegateOfPush];
            }
        }];
        [application registerForRemoteNotifications];
        
    }
    
}

- (void)registerPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    // 注册推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}


@end
