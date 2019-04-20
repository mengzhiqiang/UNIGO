//
//  WKwebViewController.h
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/20.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleOfHeardViewController.h"
#import <WebKit/WebKit.h>


@interface WKwebViewController : TitleOfHeardViewController<WKNavigationDelegate>

@property (strong, nonatomic) NSString *webUrl;

@property (strong, nonatomic) NSString *headTitle;
@property (strong,nonatomic) WKWebView *webView;

@property (assign, nonatomic) BOOL IS_homeVC;  //是否首页的vc
@property (assign, nonatomic) BOOL IS_hiddenNav;  //是否隐藏标题栏

@property (strong, nonatomic) NSString *content;
@property (assign,nonatomic) int  loadCount;

@end
