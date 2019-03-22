//
//  NSDate+Extension.h
//  CompareTimeDemo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  获取当前时间戳
 *
 *  @return 返回时间戳字符串
 */
+ (NSString *)getCurrentTime;

+(NSString *)getNowTimeTimestamp3;  // 毫秒
/**
 *  获取当前时间
 *
 *  @return 返回 yyyy-MM-dd HH:mm:ss 格式时间字符串
 */
+ (NSString *)getCurrentDataTime;
/**
 *  当前时间与记录时间对比
 *
 *  @param dataString 记录时间
 *
 *  @return 返回是否超时
 */
+ (BOOL)compareDataTime:(NSString *)dataString;


/*
  时间长度（单位秒）
  转换格式为分：秒 mm:ss
 
 */
+(NSString*)changeTimeOfTimeInterval:(NSString*)timeInterval;

+ (NSDictionary *)resetNewUserInfoWithOldObject:(NSDictionary*)oldObject;
@end
