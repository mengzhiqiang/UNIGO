//
//  NSString+Regular.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "NSString+Regular.h"
//#import "AppDelegate+Notification.h"
 #import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
}NETWORK_TYPE;


@implementation NSString (Regular)

//正则判断手机号码格式
- (BOOL)isValidMobileNumber
{
   
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
//    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
   /*
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    */
    NSPredicate *iPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_zh];
    
    if ([iPhone evaluateWithObject:self]) {
        return YES ;
    }
    
    return NO;
    
    
//    if (([regextestmobile evaluateWithObject:self]
//         || [regextestcm evaluateWithObject:self]
//         || [regextestct evaluateWithObject:self]
//         || [regextestcu evaluateWithObject:self])) {
//        return YES;
//    }
//    
//    return NO;
}

-(BOOL)isValidBabyAlias{
    
    /* 匹配中文 字母 和汉字 下划线 */
    NSString * rule = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    
    if ([regextestmobile evaluateWithObject:self]) {
        
        return [self IsNickNameRule];
    }
    
    return NO;
}

#pragma  mark 昵称规则
-(BOOL)IsNickNameRule{
    
    if ([self rangeOfString:@"_"].location != NSNotFound) {
        
        return NO;
    }
    return YES;
}

- (BOOL)isValidContainNull
{
    if ([self rangeOfString:@" "].location != NSNotFound) {
        return YES;
    }
    return NO;
}
#pragma  mark 是否包含中文
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString *)stringByFilterForSpace
{
    NSString *filterContent;
    filterContent = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    filterContent = [filterContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    return filterContent;
}


- (CGFloat)widthOfStringFont:(UIFont *)font
{
    CGSize strSize = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    return strSize.width;
}

- (CGSize)sizeOfStringFont:(UIFont *)font
{
    CGSize strSize = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    return strSize;
}



+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font maxWidth:(CGFloat)width
{
    //CGSizeMake(width, CGFLOAT_MAX)
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size.height;
}

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  最后时间
 ** 返回:     NSString 剩余时间 (显示的时间)
 **************************************************************/

+(NSString *)showtimeSurplusGamesTimes:(NSString*)gamesTimes{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:gamesTimes];
    NSDate * now = [NSDate date];
    
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:now];
    
    
   return [self countDown:timeBetween];
    
}

+(NSString* )countDown:(NSTimeInterval)timeBetween{

    if (timeBetween<0) {
        return @"00:00";
    }
    
    int mm;  int ss;
    NSString*  mm_str;  NSString*  ss_str;
    
    
    mm=timeBetween/60;
    
    ss=((int)timeBetween%3600)%60;
    
    if (mm<10) {
        mm_str=[NSString stringWithFormat:@"0%d",mm];
    }else{
        mm_str=[NSString stringWithFormat:@"%d",mm];
        
    }
    
    if (ss<10) {
        ss_str=[NSString stringWithFormat:@"0%d",ss];
        
    }else{
        ss_str=[NSString stringWithFormat:@"%d",ss];
        
    }
    
    return [NSString stringWithFormat:@"%@:%@",mm_str,ss_str];

}

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  宝贝生日
 ** 返回:     NSString   年龄大小(显示的时间 *岁*月)
 **************************************************************/
+(NSString *)showBabyAgeWithTimes:(NSString*)babyDate{

    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"newsDate = %@",babyDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:babyDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [NSDate date];
    
    
    int year = [self year:current_date] -[self year:newsDateFormatted];
    
    int month = [self month:current_date] -[self month:newsDateFormatted];

    int day = [self day:current_date] -[self day:newsDateFormatted];

    
    if (month<0) {
        year--;
        
        month = 12+month;
        if (day<0) {
            month--;
        }
        
    }
    else if (month==0){
        if (day<0) {
            year--;
            month=11;
        }
        
    }else{
        
        if (day<0) {
            month = month-1;
        }
    }

    NSString *dateContent;

    if (year>0) {
        if (month>0) {
            dateContent = [NSString stringWithFormat:@"%d 岁 %d 个月",year,month];
        }else{
            dateContent = [NSString stringWithFormat:@"%d 岁",year];
        }
    }else{
        if (month>0) {
            dateContent = [NSString stringWithFormat:@"%d 个月",month];
        }else{
            dateContent = [NSString stringWithFormat:@"未满月"];

        }
    }
    return dateContent;
}

+(int)year:(NSDate*)date{
    
    int year = (int)[[self yearMothDate:date ] year];
    
    return year;
}
+(int )month:(NSDate*)date{
    
    int month = (int)[[self yearMothDate:date ] month];
    
    return month;
}
+(int )day:(NSDate*)date{
    
    int day = (int)[[self yearMothDate:date ] day];
    
    return day;
}
+(int )weekday:(NSDate*)date{
    
    int week = (int)[[self yearMothDate:date ] weekday];
    
    return week;
}

+(NSDateComponents* )yearMothDate:(NSDate*)date{
    //获取当前时间
//    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSCalendarUnitWeekdayOrdinal | NSWeekdayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];

    return dateComponent;
}


+(int)howManyDaysInThisYear:(int)year month:(int)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}
/*
    获取当前时间字符串
 */

+(NSString*)nowTime{
    NSDate *today =[NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* s1 = [df stringFromDate:today];
    return s1;
}
+(NSString*)nowTimeFileName{
    NSDate *today =[NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyyMMdd_HH:mm:ss"];
    NSString* s1 = [df stringFromDate:today];
    return s1;
}


/*  
 去除字典中的空key
 */
+ (NSDictionary *)resetNewUserInfoWithOldObject:(NSDictionary*)oldObject
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    for (NSString *key in [oldObject allKeys]) {
         if ([[[oldObject objectForKey:key] class] isSubclassOfClass:[NSDictionary class]] ) {
            NSDictionary *accountDic= [self resetNewUserInfoWithOldObject:[oldObject objectForKey:key]];
            if ([accountDic allKeys]>0) {
                [userInfo setObject:accountDic forKey:key];
            }
             continue;
         } else if ([[[oldObject objectForKey:key] class] isSubclassOfClass:[NSNull class]] ) {
             continue;
         }else if ([[[oldObject objectForKey:key] class] isSubclassOfClass:[NSString class]] &&  [[oldObject objectForKey:key] length]<1) {
             continue;
         }
        else{
            [userInfo setObject:[oldObject objectForKey:key] forKey:key];
        }
    }
    return userInfo ;
}

+ (NSString *)typeForImageData:(NSDictionary *)info{
    
    NSURL *url = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSArray *arr  =[url.resourceSpecifier componentsSeparatedByString:@"&"];
    
    NSString * imageSuffix = @"jpg";
    for (NSString *string in arr) {
        if ([string hasPrefix:@"ext="]) {
            imageSuffix=[string substringFromIndex:4];
        }
    }
    
    return imageSuffix;
}


+ (NSString *)colorWithSerial:(NSString *)serial_no{
    
    NSString * str_color = [serial_no substringWithRange:NSMakeRange(5, 1)];
    NSDictionary * dic =[NSDictionary dictionaryWithObjectsAndKeys:@"黑色",@"0",@"棕色",@"1",@"红色",@"2",@"橙色",@"3",@"黄色",@"4",@"绿色",@"5",@"蓝色",@"6",@"紫色",@"7",@"灰色",@"8",@"白色",@"9",@"金色",@"G",@"粉色",@"P",@"无色",@"Z",@"透明",@"C",@"本色",@"F", nil];
    
    return [dic objectForKey:str_color];
}


+(NSString*)stringWithTitle:(NSString*)title  andType:(NSString*)type{
    NSString * contant = @"休眠";
    switch ([type intValue]) {
        case 1:
            contant = [NSString stringWithFormat:@"看了《%@》",title];
            break;
        case 2:  case 3:
            contant = [NSString stringWithFormat:@"听了《%@》",title];
            break;
        case 4:
            contant = [NSString stringWithFormat:@"学了《%@》",title];
            break;
        case 5:
            contant = [NSString stringWithFormat:@"和%@聊天",title];
            break;
        case 6:
            contant = [NSString stringWithFormat:@"和乐迪聊天"];
            break;
        case 7:
            contant = [NSString stringWithFormat:@"使用了《%@》",title];
            break;
        default:
            break;
    }
    return contant;
}

/*
 判断该时间是否到期
 */

+(BOOL)isDueWithDate:(NSString*)state{
  
    if ([state intValue]==0) {
        return NO;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"newsDate = %@",state);
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:state];
    
    /* 与实际时间晚8个小时  */
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSTimeInterval stateDate=[newsDateFormatted timeIntervalSince1970]*1;
    NSTimeInterval now=[localeDate timeIntervalSince1970]*1;
    
    NSLog(@"newsDate===stateDate-now = %f",stateDate-now);
    NSLog(@"newsDate = %@===%@",newsDateFormatted,localeDate);

    if (stateDate-now>0) {
        return NO;
    }

    return YES;
}
/*
  字符串长度判断
 */
+(int)CountOFNSString:(NSString*)sou{
    
    NSLog(@"==%lu==",(unsigned long)[sou length]);
    int length = (int)[sou length];
    
    int nicknameleng=0;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [sou substringWithRange:range];
        const char *cString = [subString UTF8String];
        
        if (cString==nil) {
            nicknameleng=nicknameleng+1;
            return  10000;
            
            //            continue;
        }
        
        if (strlen(cString) == 3)
        {
            NSLog(@"汉字:%s", cString);
            nicknameleng=nicknameleng+2;
        }else {
            nicknameleng=nicknameleng+1;
        }
    }
    
    return nicknameleng;
    
}


#pragma mark  判断是否正在夜间休眠

+(BOOL)isNightSleep{
    
    NSDictionary *nightSleepDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"夜间休眠key"];
    NSString *start = nightSleepDic[@"night_hibernate_from"];
    NSString *end = nightSleepDic[@"night_hibernate_to"];
    
    BOOL result =  [self compareNightSleepTimeStarTime:start endTime:end];
    if (![[nightSleepDic objectForKey:@"night_hibernate"] intValue]) {
        result = NO ;
    }
    return result;
}
/*
 start 夜间休眠开始时间
 end   夜间休眠结束时间
 */
+ (BOOL)compareNightSleepTimeStarTime:(NSString *)start endTime:(NSString *)end {
    
    BOOL isCurrentDay = [self compareNightSleepTimeisCurrentDayWithStartTime:start andEndTime:end];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *endDate = [formatter dateFromString:end];
    
    NSString *currentDataStr = [formatter stringFromDate:[NSDate date]];
    NSDate *currentDataStart = [formatter dateFromString:currentDataStr];
    
    NSTimeInterval currentBetweenStart = [currentDataStart timeIntervalSinceDate:startDate];
    if (currentBetweenStart < 0) {//当前时间 不超过休眠开始时间 还没休眠
        return NO;
    }else {
        NSTimeInterval currentBetweenEnd = [currentDataStart timeIntervalSinceDate:endDate];
        if (isCurrentDay) {//如果是当天
            if (currentBetweenEnd > 0) {//当前时间 > 结束时间 没休眠
                return NO;
            }else {//当前时间 <= 结束时间 正在休眠
                return YES;
            }
        }else {
            return YES;
        }
    }
}
///是否次日时间
+(BOOL)compareNightSleepTimeisCurrentDayWithStartTime:(NSString *)start andEndTime:(NSString *)end{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *endDate = [formatter dateFromString:end];
    NSTimeInterval timeBetween = [endDate timeIntervalSinceDate:startDate];
    if (timeBetween>0) {
        return YES;
    }
    //次日
    return NO;
}

#pragma  mark  获取当前wifi Name
+ (NSString *)getIPhoneWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
//    NSLog(@"network info -> %@", interfaces);
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
//            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            NSData *data = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSIDData];
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//            NSLog(@"=result==wifi==%@",result);
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    NSLog(@"===wifi====Name  =%@",wifiName);
    return wifiName;
}


/**
 *  判断字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return YES or NO
 */
+ (BOOL)judgeIsEmptyWithString:(NSString *)string
{
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
}


// 十六进制转换为普通字符串
+ (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}

//签名算法
//签名生成的通用步骤如下：
//第一步，设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
//特别注意以下重要规则：
//◆ 参数名ASCII码从小到大排序（字典序）；
//◆ 如果参数的值为空不参与签名；
//◆ 参数名区分大小写；

+(NSString *)signStr:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (int i=0;i< [sortedArray count];i++) {
        
        NSString *categoryId = [sortedArray objectAtIndex: i];
        
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            if (i==sortedArray.count-1) {
                [contentString appendFormat:@"%@=%@", categoryId, [dict objectForKey:categoryId]];
            }else{
                [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
            }
        }
    }
    NSLog(@"要签名参数串contentString:%@",contentString);

    ///转义
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [contentString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    
    NSLog(@"要签名参数串转义:%@",encodedUrl);

    NSString *signStr = [encodedUrl md5HexDigest];
    NSLog(@"已签名数据signStr-md5：%@",signStr);

//    NSString * str2 = signStr.lowercaseString;

    
    return signStr;
}
//+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr
//{
//    const char *cKey  = [keyStr cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cData = [toEncryptStr cStringUsingEncoding:NSUTF8StringEncoding];
//    const unsigned int blockSize = 64;
//    char ipad[blockSize];
//    char opad[blockSize];
//    char keypad[blockSize];
//
//    unsigned int keyLen = strlen(cKey);
//    CC_MD5_CTX ctxt;
//    if (keyLen > blockSize) {
//        CC_MD5_Init(&ctxt);
//        CC_MD5_Update(&ctxt, cKey, keyLen);
//        CC_MD5_Final((unsigned char *)keypad, &ctxt);
//        keyLen = CC_MD5_DIGEST_LENGTH;
//    }
//    else {
//        memcpy(keypad, cKey, keyLen);
//    }
//
//    memset(ipad, 0x36, blockSize);
//    memset(opad, 0x5c, blockSize);
//
//    int i;
//    for (i = 0; i < keyLen; i++) {
//        ipad[i] ^= keypad[i];
//        opad[i] ^= keypad[i];
//    }
//
//    CC_MD5_Init(&ctxt);
//    CC_MD5_Update(&ctxt, ipad, blockSize);
//    CC_MD5_Update(&ctxt, cData, strlen(cData));
//    unsigned char md5[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(md5, &ctxt);
//
//    CC_MD5_Init(&ctxt);
//    CC_MD5_Update(&ctxt, opad, blockSize);
//    CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
//    CC_MD5_Final(md5, &ctxt);
//
//    const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
//    char hex[hex_len];
//    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
//    }
//
//    NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
//    NSString *hashStr = [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding] ;
//    NSString *hash= [hashStr uppercaseString];
//
//    return hash;
//}

@end
