//
//  NSDate+zh_Format.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/4.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (zh_Format)


#pragma mark - Relative Dates

//明天
+ (NSDate *)dateTomorrow;

//昨天
+ (NSDate *)dateYesterday;

//多少天之后的时间
+ (NSDate *)dateWithDaysFromNow:(NSUInteger)days;

//多少天之前的时间
+ (NSDate *)dateWithDaysBeforeNow:(NSUInteger)days;

//多少小时之后的时间
+ (NSDate *)dateWithHoursFromNow:(NSUInteger)dHours;

//多少小时之前的时间
+ (NSDate *)dateWithHoursBeforeNow:(NSUInteger)dHours;

//多少分钟之后的时间
+ (NSDate *)dateWithMinutesFromNow:(NSUInteger)dMinutes;

//多少分钟之前的时间
+ (NSDate *)dateWithMinutesBeforeNow:(NSUInteger)dMinutes;

#pragma mark -

//是否是今天
- (BOOL)isToday;

//是否是明天
- (BOOL)isTomorrow;

//是否昨天
- (BOOL)isYesterday;

//是否今年
- (BOOL)isThisYear;

//是否这个月
- (BOOL)isThisMonth;

//是否周
- (BOOL)isThisWeek;

#pragma mark - 

- (NSInteger)currentSecond;

+ (NSInteger)currentSecond;

//yyyy-MM-dd HH:mm:ss
+ (NSString *)currentDate;
- (NSString *)currentDate;

//HH:mm
+ (NSString *)currentTime;
- (NSString *)currentTime;

+ (NSString *)durationFromTimeInterval:(NSTimeInterval)timeInterval;

#pragma mark - 时间转换

+ (NSDate *)dateForString:(NSString *)string;
+ (NSString *)stringForDate:(NSDate *)date;


#pragma mark 时间转换
+ (NSString *)chineseTimeFromDataTime:(NSString *)dateTime;

#pragma mark hh:mm:ss 转换为秒数
+(int)durationWtihDate:(NSString*)duration;

///时间去除空格标点
+ (NSString *)currentDateName;
@end
