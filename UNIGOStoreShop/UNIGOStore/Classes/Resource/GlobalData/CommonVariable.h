//
//  NETworking.m
//  ALPHA
//
//  Created by teelab2 on 14-5-15.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "Define.h"
#import "Unification.h"

@interface CommonVariable : NSObject<NSXMLParserDelegate>


@property (nonatomic, assign)   BOOL                isLogin;
@property (nonatomic, retain)   UserInfo            *userInfoo;
@property (nonatomic, retain)   NSDictionary        *userDIC;  ///用户全部数据
@property (nonatomic, retain)   Unification         *   unification;  ///全局混合数据

@property (nonatomic, copy)     NSString            *userInfoStr;
@property (nonatomic, retain)     NSString            *APNS_Token;  ///消息推送获取token

@property (nonatomic, retain)     NSString            *APNS_regid;  ///极光消息推送获取iD

@property (nonatomic, retain)     NSArray            *Indent_array;  ///下订单添加的衣服


@property (nonatomic, retain)     NSMutableArray            *LoadImage_Array;  ///加载图片

@property (nonatomic, retain)     NSArray            *address_Array;  ///配送地址
@property (nonatomic, retain)     NSDictionary       *dic_SystemInit;  ///初始化数据


@property (nonatomic, assign)     BOOL            isNetword;  ///当前网络是否可用

@property (nonatomic, assign)     BOOL            IS_SystemInit;  ///是否初始化


@property (nonatomic, strong)   NSString         *netWorkSytle;  ////当前网络类型

///V1.0.3
@property (nonatomic, strong)   NSURL         *     Pick_sourUrl;  //高清图片


/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareCommonVariable;


/**************************************************************
 ** 功能:     更新全局数据
 ** 参数:     newdic 后台返回更新数据
 ** 返回:     nil  直接保存到plist文件
 **************************************************************/
-(void)UpdateGlobalData:(NSDictionary*)NewDIc;


/**************************************************************
 ** 功能:     设置网络通
 ** 参数:
 ** 返回:
 **************************************************************/
-(void)loadNewNetWorkIsYes;

@end
