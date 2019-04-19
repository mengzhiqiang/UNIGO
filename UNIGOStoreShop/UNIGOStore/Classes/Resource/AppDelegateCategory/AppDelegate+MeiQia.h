//
//  AppDelegate+MeiQia.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/8/29.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (MeiQia)

- (void)MeiQiaApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/*
 
 添加、移除 美洽消息通知
 
 */
-(void)addNotificationOfWeiQiaMessage;
-(void)removeNotificationOfWeiQiaMessage;

@end
