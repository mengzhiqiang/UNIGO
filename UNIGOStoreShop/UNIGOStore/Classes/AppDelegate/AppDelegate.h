//
//  AppDelegate.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy)NSString *refreshUrl;  ////更新url


+ (AppDelegate *)delegateGet;

@end

