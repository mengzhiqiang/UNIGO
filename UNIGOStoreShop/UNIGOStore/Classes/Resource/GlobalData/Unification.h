//
//  Unification.h
//  ALPHA
//
//  Created by teelab2 on 14-9-17.
//  Copyright (c) 2014年 ALPHA. All rights reserved.  messagePerson messageFriends
//messageSystem

#import <Foundation/Foundation.h>


static const NSString *HSCoder = @"汉斯哈哈哈";

@interface Unification : NSObject



#pragma  mark  各个接口状态
@property ( strong,nonatomic)     NSDictionary     *      token_Status;     /// 用户鉴权
@property ( strong,nonatomic)     NSDictionary     *      account_Status;   /// 注册
@property ( strong,nonatomic)     NSDictionary     *      password_Status;  /// 修改密码
@property ( strong,nonatomic)     NSMutableDictionary     *      baby_Status;      /// 宝宝信息
@property ( strong,nonatomic)     NSMutableDictionary     *      account_robot_Status;     ///   帐号宝贝
@property ( strong,nonatomic)     NSMutableDictionary     *      robot_Status;     /// 机器人信息
@property ( strong,nonatomic)     NSMutableDictionary     *      Item_Status;     /// 影音点播信息
@property ( strong,nonatomic)     NSMutableDictionary     *      HelpMe_Status;     /// 帮我说信息


/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareUnification;


//-(NSDictionary*)LoadFrameOfcommodityStyle:(NSString*)style;

/// 根据款式 输入汉字
//-(NSString*)styleOfChineseWithStyle:(NSString*)style;


@end
