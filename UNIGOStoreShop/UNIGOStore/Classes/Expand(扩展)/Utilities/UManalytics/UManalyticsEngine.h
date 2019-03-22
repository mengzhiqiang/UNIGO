//
//  UManalyticsEngine.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/24.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UManalyticsEngine : NSObject

#pragma  mark  统计分析
/**************************************************************
 ** 功能:     统计分析点击事件
 ** 参数:     nsstring 事件id
 ** 返回:     无
 **************************************************************/
+(void)UMAnalyticsCountEven:(NSString *)evenID;
/**************************************************************
 ** 功能:     统计分析 计算数据
 ** 参数:     nsstring 事件id  事件参数
 ** 返回:     无
 **************************************************************/
+(void)UMAnalyticsCalculateEven:(NSString *)evenID  value:(id)value count:(int)count;
/**************************************************************
 ** 功能:     统计分析 计时开始
 ** 参数:     nsstring 事件id
 ** 返回:     无
 **************************************************************/
+(void)UMAnalyticsBeginLogEven:(NSString *)evenID;
/**************************************************************
 ** 功能:     统计分析 计时结束
 ** 参数:     nsstring 事件id
 ** 返回:     无
 **************************************************************/
+(void)UMAnalyticsEndinLogEven:(NSString *)evenID;

@end
