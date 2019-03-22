//
//  AppDelegate+APNS.h
//  SmartDevice
//
//  Created by singelet on 16/6/20.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (APNS)

- (void)setupPushWithLaunchOptions:(NSDictionary *)launchOptions;

- (void)registerPushWithLaunchOptions:(NSDictionary *)launchOptions;


@end
