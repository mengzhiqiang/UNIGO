//
//  NSDate+zh_Format.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/4.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "NSDate+zh_Format.h"

#define Date_MINUTE  	60
#define Date_HOUR		3600
#define Date_DAY		86400
#define Date_WEEK		604800
#define Date_YEAR		31556926

#define  DATE_COMPONENTS_Calendar_Unit (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]



@implementation NSDate (zh_Format)


#pragma mark - Relative Dates

+ (NSDate *)dateWithDaysFromNow:(NSUInteger)days
{
    //dateWithTimeIntervalSince1970 已1970年为基准
//    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] + Date_DAY * days;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
//    return newDate;
    
    //timeIntervalSinceReferenceDate  已2001年为基准
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_DAY * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithDaysBeforeNow:(NSUInteger)days
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_DAY *days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//多少小时之后的时间
+ (NSDate *)dateWithHoursFromNow:(NSUInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//多少小时之前的时间
+ (NSDate *)dateWithHoursBeforeNow:(NSUInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//多少分钟之后的时间
+ (NSDate *)dateWithMinutesFromNow:(NSUInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//多少分钟之前的时间
+ (NSDate *)dateWithMinutesBeforeNow:(NSUInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

#pragma mark -


//是否是今天
- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

//是否是明天
- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

//是否昨天
- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

//是否今年
- (BOOL)isThisYear
{
    return [self isEqualToYearIgnoringTime:[NSDate date]];
}

//是否这个月
- (BOOL)isThisMonth
{
    return [self isEqualToMonthIgnoringTime:[NSDate date]];
}

//是否周
- (BOOL)isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}


#pragma mark - Private Methods
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:aDate];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}

- (BOOL)isEqualToYearIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:aDate];
    return [components1 year] == [components2 year];
}

- (BOOL)isEqualToMonthIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:aDate];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]));
}

- (BOOL)isSameWeekAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:aDate];
    
    if ([components1 week] != [components2 week]) return NO;
    
    return (fabs([self timeIntervalSinceDate:aDate]) < Date_WEEK);
}

#pragma mark - 

- (NSInteger)currentSecond
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS_Calendar_Unit fromDate:self];
    return components.second;
}

+ (NSInteger)currentSecond
{
    return [[NSDate date] currentSecond];
}

+ (NSString *)currentDate
{
   return [[NSDate date] currentDate];
}

- (NSString *)currentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

// MM月dd日 hh:mm
+ (NSString *)currentTime
{
    return [[NSDate date] currentTime];
}
- (NSString *)currentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd号 HH:mm"];
    return [formatter stringFromDate:self];
}

+ (NSString *)durationFromTimeInterval:(NSTimeInterval)timeInterval
{
    long duration = lroundf(timeInterval);
    int hour = 0;
    int minute = duration / 60.0f;
    int second = duration % 60;
    if (minute > 59) {
        hour = minute / 60;
        minute = minute % 60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    }
    else {
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

#pragma mark - 时间转换

+ (NSDate *)dateForString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}



#pragma mark 时间转换
+ (NSString *)chineseTimeFromDataTime:(NSString *)dateTime{

    NSArray * arr =[dateTime componentsSeparatedByString:@"-"];
    
    if ([arr count]>=3) {
        return [NSString stringWithFormat:@"%@ 年 %@ 月 %@ 日",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2]];
    }
    
    return @"某年某月某日";
}

+(int)durationWtihDate:(NSString*)duration{

    NSArray * arr =[duration componentsSeparatedByString:@":"];
    if ([arr count]==2) {
        return  [[arr objectAtIndex:0] intValue]*60+[[arr objectAtIndex:1] intValue];
    }else if ([arr count]==3) {
        return  [[arr objectAtIndex:0] intValue]*3600+[[arr objectAtIndex:1] intValue]*60+[[arr objectAtIndex:2] intValue];
    }
    return 0;
}

+ (NSString *)currentDateName
{
    NSString *currentDate = [[[NSDate date] currentDate] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    currentDate = [currentDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    currentDate = [currentDate stringByReplacingOccurrencesOfString:@":" withString:@""];
    return currentDate;
}
@end
