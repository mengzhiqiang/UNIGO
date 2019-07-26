//
//  DCNewWebViewController.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 26/7/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "TitleOfHeardViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCNewWebViewController : TitleOfHeardViewController<WKNavigationDelegate>

@property (strong, nonatomic) NSString *webUrl;

@property (strong, nonatomic) NSString *headTitle;
@property (strong,nonatomic) WKWebView *webView;

@property (assign, nonatomic) BOOL IS_homeVC;  //是否首页的vc
@property (assign, nonatomic) BOOL IS_hiddenNav;  //是否隐藏标题栏

@property (strong, nonatomic) NSString *content;
@property (assign,nonatomic) int  loadCount;


@end

NS_ASSUME_NONNULL_END
