//
//  AppDelegate.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "AppDelegate.h"
#import "JKDBModel.h"
#import "DCTabBarController.h"

#import "AppDelegate+MeiQia.h"
#import <MeiQiaSDK/MQManager.h>
#import "AppDelegate+Update.h"

#import "JPFPSStatus.h"
#import "RequestTool.h"
#import "NetworkUnit.h"
#import "DCAppVersionTool.h"
#import <SVProgressHUD.h>
#import "UIImageView+WebCache.h"
#import <WXApi.h>
#import "WXApiManager.h"
#import "DCNewFeatureViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setUpRootVC]; //跟控制器判断
    [self.window makeKeyAndVisible];
    
#if defined(DEBUG)||defined(_DEBUG) //仅仅在模拟器上跑测试会显示FPS
    [[JPFPSStatus sharedInstance] open];
#endif
    
    [self checkAppVersion];
    [self setUpFixiOS11]; //适配IOS 11
    [self MeiQiaApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [WXApi registerApp:@"wx3ddd4fb04c77a94b" enableMTA:YES];
//    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"demo 2.0"];
    

    return YES;
}


#pragma mark - 根控制器
- (void)setUpRootVC
{
    if ([BUNDLE_VERSION isEqualToString:[DCAppVersionTool dc_GetLastOneAppVersion]]) {//判断是否当前版本号等于上一次储存版本号

        self.window.rootViewController = [[DCTabBarController alloc] init];
    }else{
        
        [DCAppVersionTool dc_SaveNewAppVersion:BUNDLE_VERSION]; //储存当前版本号

        // 设置窗口的根控制器
        DCNewFeatureViewController *dcFVc = [[DCNewFeatureViewController alloc] init];
        [dcFVc setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
            
            *imageArray = @[@"guide1",@"guide2",@"guide3",@"guide4"];
            *showPageCount = YES;
            *showSkip = YES;
        }];
        self.window.rootViewController = dcFVc;
    }
}

#pragma mark - 适配
- (void)setUpFixiOS11
{
    if (@available(ios 11.0,*)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [MQManager openMeiqiaService];  // 进入前台 打开meiqia服务
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MQManager closeMeiqiaService];  //  进入后台  关闭meiqia服务

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
#pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
}

#pragma mark - 当APP接收到内存警告的时候
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager]cancelAll]; //取消所有下载
    [[SDWebImageManager sharedManager].imageCache clearMemory]; //立即清除缓存
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"wx3ddd4fb04c77a94b"] &&[url.resourceSpecifier hasPrefix:@"//pay/?"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

#pragma mark - 获取UIApplicationDelegate
+ (AppDelegate *)delegateGet
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:resultDic];

            
        }];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:resultDic];
        }];
    }
    return YES;
}

@end
