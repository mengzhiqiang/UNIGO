//
//  AFAccountEngine.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAccount.h"
#import "AFCommonEngine.h"
@interface AFAccountEngine : NSObject

@property (nonatomic, strong)AFAccount *currentAccount;

/*
 未读通知数量
 */
@property (nonatomic, assign) int noticeCount;
#pragma mark - Singleton
//单例
+ (instancetype)sharedInstance;

+ (AFAccountEngine *)getAccountEngine;

+ (AFAccount *)getAccount;

+ (void)quitAccount;

/* 保存个人信息 带token 个人新*/
+ (void)saveAccountAndTokenWithUserInfo:(NSDictionary *)userInfo;

/* 保存个人信息 不带token*/
+ (void)saveAccountInformationWithUserInfo:(NSDictionary *)userInfo ;

/* 保存个人信息  单独token*/
+ (void)saveTokens:(NSDictionary *)userInfo ;
@end
