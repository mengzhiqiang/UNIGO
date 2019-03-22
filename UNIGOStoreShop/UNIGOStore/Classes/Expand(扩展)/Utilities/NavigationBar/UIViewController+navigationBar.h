//
//  UIViewController+NavnationBar.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/22.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (navigationBar)

/*
///添加标题栏
 */
-(void)headerViewWithTitle:(NSString*)title target:(id)sender;

/*
///422  返回提示信息 
 */
//-(BOOL)TitleMessage:(NSDictionary *)Dic_data;

/*
///标题栏错误提示
 */
-(void)promtNavHidden:(NSString*)title;



@end
