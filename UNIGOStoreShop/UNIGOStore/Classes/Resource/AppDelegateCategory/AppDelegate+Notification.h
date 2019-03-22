//
//  AppDelegate+Notification.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/16.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)<CAAnimationDelegate>

- (void)setupAppDelegateNotification;

+ (void)postSwitchRootViewControllerNotificationWithIsLogin:(BOOL)isLogin;

///跳转激活绑定页面
+ (void)pushPageWithSlectedRobotInterface;
/////全局提示框
//+ (void)showAlertViewWithTitle:(NSString *)title
//                       message:(NSString *)message
//                   cancelTitle:(NSString *)cancelTitle
//                           tag:(int)tag;
/////
@end
