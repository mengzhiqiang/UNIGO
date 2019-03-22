//
//  NSString+Regular.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

//是否为手机号码
- (BOOL)isValidMobileNumber;

///是否符合宝贝关系格式
-(BOOL)isValidBabyAlias;

//是否包含空字符串
- (BOOL)isValidContainNull;

#pragma  mark 是否包含中文
- (BOOL)includeChinese;

-(BOOL)IsNickNameRule;


//过滤空格
- (NSString *)stringByFilterForSpace;



/**
 *  计算字符串的宽度
 *
 *  @param font 字符串的字体
 *
 *  @return 返回宽度
 */
- (CGFloat)widthOfStringFont:(UIFont *)font;

- (CGSize)sizeOfStringFont:(UIFont *)font;

/**
 *  根据固定的宽度计算字符串的高度
 *
 *  @param str   字符串
 *  @param font  字体大小
 *  @param width 宽度
 *
 *  @return 返回高度
 */
+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font maxWidth:(CGFloat)width;

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  最后时间
 ** 返回:     NSString 剩余时间 (显示的时间)
 **************************************************************/
+(NSString *)showtimeSurplusGamesTimes:(NSString*)gamesTimes;


+(NSString* )countDown:(NSTimeInterval)timeBetween;

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  宝贝生日
 ** 返回:     NSString   年龄大小(显示的时间 *岁*月)
 **************************************************************/
+(NSString *)showBabyAgeWithTimes:(NSString*)babyDate;

/**************************************************************
 ** 功能:     警告提示
 ** 参数:     NSDictionary 接口返回
 ** 返回:     BOOL 是否要单独提醒
 **************************************************************/
//+(BOOL)alertMessageWithDIC:(NSDictionary*)diction;

/*
 去除字典中的空key
 */
+ (NSDictionary *)resetNewUserInfoWithOldObject:(NSDictionary*)oldObject;


/*
   获取图片后缀 格式
 */
+ (NSString *)typeForImageData:(NSDictionary *)info;

/*
  获取机器人颜色 根据序列号
 */
+ (NSString *)colorWithSerial:(NSString *)serial_no;

/*
 获取机器人型号 根据序列号
 */
//+ (NSString *)modelWithSerial:(NSString *)serial_no;


/*
 获取机器人使用记录内容
 */
+(NSString*)stringWithTitle:(NSString*)title  andType:(NSString*)type;

/*
 *根据年和月 获取当月天数
 * 根据date获取年份
 * 根据date获取月份
 * 根据date获取日期
 * 根据date获取星期

 */
+(int)howManyDaysInThisYear:(int)year month:(int)imonth ;

+(int)year:(NSDate*)date;
+(int )month:(NSDate*)date;
+(int )day:(NSDate*)date;
+(int )weekday:(NSDate*)date;


/*
 获取当前时间字符串
 */

+(NSString*)nowTime;
+(NSString*)nowTimeFileName;
/*
  判断该时间是否到期
 */
+(BOOL)isDueWithDate:(NSString*)state;


/*
  根据字符串 返回字符长度
 */
+(int)CountOFNSString:(NSString*)sou;

/*
 判断是否正在夜间休眠
  直接获取保存的数据
 */
+(BOOL)isNightSleep;
/*
    判断是否正在夜间休眠 
    start 夜间休眠开始时间
    end   夜间休眠结束时间
 */
+ (BOOL)compareNightSleepTimeStarTime:(NSString *)start endTime:(NSString *)end ;

#pragma  mark  获取当前wifi Name
+ (NSString *)getIPhoneWifiName;
/**
 *  判断字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return YES or NO
 */
+ (BOOL)judgeIsEmptyWithString:(NSString *)string;

+ (NSString *)stringFromHexString:(NSString *)hexString;

//签名算法
+(NSString *)signStr:(NSMutableDictionary*)dict;
@end
