//
//  MeiQiaCustomEngine.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/8/29.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFMeiQiaCustomEngine.h"
#import "MQChatViewManager.h"
#import "AppDelegate+MeiQia.h"

#import "AFAccountEngine.h"
@implementation AFMeiQiaCustomEngine

+ (void)didMeiQiaUIViewController:(UIViewController*)viewController  andContant:(NSDictionary*)contantDic{
    //基本功能 - 在线客服
    
//    NSString *clientId = [MQManager getCurrentClientId]; ////美洽id
#pragma 帐号信息
    AFAccount *account = [AFAccountEngine sharedInstance].currentAccount;
//    AFAccountAvatar *avatar = account.avatar;
    
    NSString * customId =account.client.phone;
    NSString * Name = account.client.nickname;
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:false];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    [chatViewManager enableEvaluationButton:NO];
  

    chatViewManager.chatViewStyle.navBarTintColor=[UIColor  colorWithHexString:@"000000"];
    [chatViewManager setClientInfo:@{@"name":Name,@"tel":customId,@"来源":@"ios设备"}]; //终端信息
    [chatViewManager pushMQChatViewControllerInViewController:viewController];
    [chatViewManager setLoginCustomizedId:customId];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // something
//        NSData *date=[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar.medium]];
//        UIImage *iconImage =[UIImage imageWithData:date];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [chatViewManager setoutgoingDefaultAvatarImage:iconImage];
//        });
//    });
    
    [chatViewManager setNavigationBarTitleColor:[UIColor colorWithHexString:@"000000"]];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [chatViewManager setRecordMode:MQRecordModeDuckOther];
    [chatViewManager setPlayMode:MQPlayModeMixWithOther];
    [[AppDelegate delegateGet]removeNotificationOfWeiQiaMessage];
    

    if ([[contantDic objectForKey:@"style"] isEqualToString:@"1"]) {
        [chatViewManager setPreSendMessages: @[@"我想咨询的订单号：【17050454968】"]];
    }else  if ([[contantDic objectForKey:@"style"] isEqualToString:@"2"]) {
        NSString *title = [NSString stringWithFormat:@"我想咨询的商品是：%@ \n地址：%@",[contantDic objectForKey:@"title"],[contantDic objectForKey:@"details"]];
        [chatViewManager setPreSendMessages: @[title]];
    }
    
}


@end
