//
//  AppDelegate+MeiQia.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/8/29.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AppDelegate+MeiQia.h"
#import <MeiQiaSDK/MQManager.h>
#import "AFMeiQiaCustomEngine.h"
#import "MQChatViewConfig.h"
#import "MQChatFileUtil.h"
#import "MQAssetUtil.h"

#define MeiQiaAppKey         @"fcf49b59e18a1db6f97ce2a3980e14e3"

@implementation AppDelegate (MeiQia)

- (void)MeiQiaApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [MQManager initWithAppkey:MeiQiaAppKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
#pragma 在合适的地方监听有新消息的广播
    [self addNotificationOfWeiQiaMessage];
    if (launchOptions) {
        if ([[launchOptions objectForKey:@"messageId"] length]>1 || [[launchOptions objectForKey:@"clientId" ] length]>1) {
            [self MeiQiaPushController];
        }
    }
}
-(void)addNotificationOfWeiQiaMessage{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
}
-(void)removeNotificationOfWeiQiaMessage{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
}
// push
- (void)MeiQiaPushController
{
    UINavigationController *navi  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSLog(@"===%@",[navi viewControllers]);
    UIViewController *currentController = [[navi viewControllers] lastObject];
    [AFMeiQiaCustomEngine didMeiQiaUIViewController:currentController andContant:nil];
}
#pragma 监听收到美洽聊天消息的广播
- (void)didReceiveNewMQMessages:(NSNotification *)notification {
    //广播中的消息数组
//    NSArray *messages = [notification.userInfo objectForKey:@"messages"];
//    NSLog(@"监听到了收到客服消息的广播、、、、///==\n==%@",messages);
    
    if (![MQChatViewConfig sharedConfig].enableMessageSound || [MQChatViewConfig sharedConfig].incomingMsgSoundFileName.length == 0) {
        return;
    }
    [MQChatFileUtil playSoundWithSoundFile:[MQAssetUtil resourceWithName:[MQChatViewConfig sharedConfig].incomingMsgSoundFileName]];
}
@end
