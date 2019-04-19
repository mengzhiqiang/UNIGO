//
//  AppDelegate+Notification.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/16.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import "AppDelegate.h"
#import "UIViewController+Extension.h"


@implementation AppDelegate (Notification)

- (void)setupAppDelegateNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kMobPushLoginVCNotification:) name:kMobPushLoginVCNotification object:nil];
   
    
}

- (void)kMobPopRootVCNotification:(NSNotification *)notification{
    [[UIViewController getCurrentController].navigationController popToRootViewControllerAnimated:YES];
}
- (void)kMobPuhsBindVCNotification:(NSNotification *)notification{
//    [[UIViewController getCurrentController].navigationController pushViewController:[BangdingDeviceViewController new] animated:YES];
}

- (void)kMobPushLoginVCNotification:(NSNotification *)notification
{

    return ;

}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - post Notification

+ (void)postSwitchRootViewControllerNotificationWithIsLogin:(BOOL)isLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMobPushLoginVCNotification object:[NSNumber numberWithBool:isLogin]];
}


#pragma mark 进入后台
-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"applicationDidEnterBackground==%@",application);

}
#pragma mark 进入前台
-(void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"applicationWillEnterForeground==%@",application);


}

#pragma mark - **************** 私有方法
//添加本地通知
-(void)addLocalNotification{
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];//通知触发时间，10s之后
    notification.repeatInterval = 0; //通知重复次数
    //设置通知属性
    notification.alertBody = @"👉点击立即进行连网";//通知主体
//    notification.applicationIconBadgeNumber = 1;//应用程序右上角显示的未读消息数
    notification.alertAction = @"打开应用";//待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片，这里使用程序启动图片
    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    //设置用户信息
    notification.userInfo = @{@"id":@1,@"user":@"XF"};
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - **************** 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
