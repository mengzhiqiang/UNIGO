//
//  UIViewController+Extension.m
//  AFJiaJiaMob
//
//  Created by singelet on 2016/12/2.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIViewController+Extension.h"


@implementation UIViewController (Extension)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentController
{
    UIViewController *currentController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootController = window.rootViewController;
    if (appRootController.presentedViewController) {
        nextResponder = appRootController.presentedViewController;
    }
    else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *navi = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        currentController = navi.childViewControllers.lastObject;
    }
    else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController *navi = (UIViewController *)nextResponder;
        currentController = navi.childViewControllers.lastObject;
    }
    else{
        currentController = nextResponder;
    }
    return currentController;
}


@end
