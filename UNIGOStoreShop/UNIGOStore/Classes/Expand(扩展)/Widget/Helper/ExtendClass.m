//
//  ExtendClass.m
//  tp_self_help
//
//  Created by cloudpower on 13-7-31.
//  Copyright (c) 2013年 cloudpower. All rights reserved.
//
#define  SERVICE_NAME   @"keyName"


#import "UIHelper.h"
#import "ExtendClass.h"
#import "Define.h"
#import "GTMBase64New.h"
#import "UIImageView+AFNetworking.h"
@implementation ExtendClass

+(int)AdaptiveFrame{
    
    if (iPhone6plus ) {
        return 0;
    }else if (iPhone6){
    
        return 10;

    }else if (iPhone4Retina){
    
        return 20;

    }else if (iPhone5){
        
        return 20;
        
    }
    return 0;
}
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

@end

#pragma mark-   NSString
#define gkey			@"teeLab!@#$%^" //自行修改
#define gIv             @"1234567887654321" //自行修改

//static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@implementation NSString (Extend)

////////时间运算
+(NSString *)sourTime:(NSString *)timeStr{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    
    
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now=[datenow timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/60<1) {
        timeString = [NSString stringWithFormat:@"%f", cha];
        timeString = [timeString substringToIndex:timeString.length-7];
        
        if ([timeString intValue]<5) {
            timeString=@"刚刚";
        }else{
            timeString=[NSString stringWithFormat:@"%@秒前", timeString];

        }
        
    }
    
    if (cha/3600<1 && cha/60>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        
        
    }
    if (cha/86400>1&&cha/(86400*7)<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }else if(cha/(86400*7)>1) {
        
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM-dd"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date]];
    }
    return timeString;
}


/////字符串长度 （字节）
-(NSString*)newSring:(NSString *)sou stringLength:(int)Leng{
    
    
    NSLog(@"==%lu==",(unsigned long)[sou length]);
    int length = (int)[sou length];
    
    int nicknameleng=0;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [sou substringWithRange:range];
        const char *cString = [subString UTF8String];

        if (strlen(cString) == 3)
        {
                NSLog(@"汉字:%s", cString);
            nicknameleng=nicknameleng+2;
        }else {
            nicknameleng=nicknameleng+1;
        }
        
       
        if (nicknameleng==20) {
            
            NSRange Newrange = NSMakeRange(0, i);
            NSString *NewString = [sou substringWithRange:Newrange];
            return NewString;
        }
        if (nicknameleng==21) {
            
            NSRange Newrange = NSMakeRange(0, i-1);
            NSString *NewString = [sou substringWithRange:Newrange];
            return NewString;
        }
        
    }
    
    
    return sou;
}


+(NSString *)AES128Encrypt:(NSString *)plainText
{
    //    int kCCKeySizeAES128;
    //    int kCCBlockSizeAES128;
    
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize =(int) dataLength + diff;
    }
    
//    char dataPtr[newSize];
    Byte dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    NSString* key= [[NSUserDefaults standardUserDefaults] objectForKey:SERVICE_NAME];

    
    NSData *testData = [[key md5HexDigest] dataUsingEncoding: NSUTF8StringEncoding];

    Byte *testByte = (Byte *)[testData bytes];


    
    Byte keyByte[16];
    
    for(int i=8;i<[testData length];i++){
        
        if (i==24) {
            break;
        }
//        NSLog(@"testByte = %d\n",testByte[i]);
        keyByte[i-8]=testByte[i];
        
    }
    

    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0X0000,               //No padding
                                          keyByte,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr ,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    

        if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64New stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText
{
    
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64New decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;

    NSString* key= [[NSUserDefaults standardUserDefaults] objectForKey:SERVICE_NAME];
    NSData *testData = [[key md5HexDigest] dataUsingEncoding: NSUTF8StringEncoding];
    
    Byte *testByte = (Byte *)[testData bytes];
    Byte keyByte[16];
    
    for(int i=8;i<[testData length];i++){
        
        if (i==24) {
            break;
        }
        keyByte[i-8]=testByte[i];
        
    }
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0X0000,
                                          keyByte,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

/**************************************************************
 ** 功能:     邮费计算
 ** 参数:     nil
 ** 返回:     NSString
 **************************************************************/
-(NSString*)LoadNewPostageWithNumber:(NSString*)string{

        NSString *post=@"12";
    
    int number=[string intValue];
    
    if (number==26 || number==27 ||number==28) {
        post=@"30";
        return post;

    }else if (number==19 || number==22|| number==23 ||number==25 || number==31){
    
        post=@"20";
    
        return post;

    }else if (number==12){
        
        return @"10";
        
    }else if (number==8 || number==16|| number==17 ||number==18 || number==24|| number==29|| number==21 ||number==30 || number==32|| number==33|| number==34 ){

        post=@"15";
        
        return post;
        
    }

    
    return post;
}


/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  当前时间  赛区结束时间
 ** 返回:     NSString 时间差 （数据 剩余多少秒）
 **************************************************************/
-(NSString*)surplusNowTime:(NSString*)timeStr surplusGamesTimes:(NSString*)GamesTimes{
    //“2012-11-20”转化成“2012年11月20日”
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:GamesTimes];
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:now];
    
    int time_be=(int)timeBetween;

    return [NSString stringWithFormat:@"%d",time_be];
    
    /*=== =======================  */
    int day=timeBetween/(24*3600);
    
    if (day>=1) {
        return [NSString stringWithFormat:@"%d天",day];
    }
    else{
        
        int hh; int mm;  int ss;
        NSString* hh_str; NSString*  mm_str;  NSString*  ss_str;
        
        
        hh=timeBetween/3600;
        
        mm=((int)timeBetween%3600)/60;
        
        ss=((int)timeBetween%3600)%60;
        
        if (hh<10) {
            hh_str=[NSString stringWithFormat:@"0%d",hh];
//            NSLog(@"====时间差==%@",hh_str);
            
        }else{
            hh_str=[NSString stringWithFormat:@"%d",hh];
        }
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
        return [NSString stringWithFormat:@"%@:%@:%@",hh_str,mm_str,ss_str];
        
    }
    
}

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  当前时间  赛区结束时间
 ** 返回:     NSString 时间差 (显示的时间)
 **************************************************************/
-(NSString *)ShowtimePurNowTime:(NSString*)timeStr surplusGamesTimes:(NSString*)GamesTimes{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:GamesTimes];
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:now];

    //    NSLog(@"====时间差==%d",(int)timeBetween);
    
    
    
    /*=== =======================  */
    
    int day=timeBetween/(24*3600);
    
    if (day>=1) {
        return [NSString stringWithFormat:@"%d天",day];
    }
    else{
        
        if (timeBetween<0) {
            return @"00:00:00";
        }
        
        int hh; int mm;  int ss;
        NSString* hh_str; NSString*  mm_str;  NSString*  ss_str;
        
        
        hh=timeBetween/3600;
        
        mm=((int)timeBetween%3600)/60;
        
        ss=((int)timeBetween%3600)%60;
        
        if (hh<10) {
            hh_str=[NSString stringWithFormat:@"0%d",hh];
            //            NSLog(@"====时间差==%@",hh_str);
            
        }else{
            hh_str=[NSString stringWithFormat:@"%d",hh];
        }
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
        return [NSString stringWithFormat:@"%@:%@:%@",hh_str,mm_str,ss_str];
        
    }
    
    
    
}

/**************************************************************
 ** 功能:     时间
 ** 参数:     NSString  作品创作时间
 ** 返回:     NSString  时间展示 (显示的时间)
 **************************************************************/
-(NSString *)ShowLaterTimeNowTime:(NSString*)Workingtime{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:Workingtime];
    
    NSDate * now = [NSDate date];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:date];
    /*=== =======================  */
    int day=timeBetween/(24*3600);
    
    if (day>=7) {
        
        return [Workingtime substringWithRange:NSMakeRange(0,10)];
        
    }
   else if (day>=1&&day<7) {
       return [NSString stringWithFormat:@"%d天前",day];
   }
    else{
        
        if (timeBetween<60) {
            return [NSString stringWithFormat:@"%d秒前",(int)timeBetween];
        }
        
        
        if (timeBetween/60<60) {
            return [NSString stringWithFormat:@"%d分钟前",(int)timeBetween/60];

        }
        if (timeBetween/60<3600) {
            return [NSString stringWithFormat:@"%d小时前",(int)timeBetween/3600];
            
        }
        
   
    }
    
    return nil;
}



/**************************************************************
 ** 功能:     温馨提示thml解析
 ** 参数:     nssgring
 ** 返回:     NSString
 **************************************************************/
-(NSString*)GetThmlOfString:(NSString*)sender{
    
  /*NSString *responseStr=[sender stringByReplacingOccurrencesOfString:@"1." withString:@"\n  1."];
    
    NSString *responseStr2=[responseStr stringByReplacingOccurrencesOfString:@"<br />2." withString:@"\n  2."];
    
    NSString *responseStr3=[responseStr2 stringByReplacingOccurrencesOfString:@"<br />3." withString:@"\n  3."];
    */
     NSString *responseStr1=[sender stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n\n"];
     NSString *responseStr3=[responseStr1 stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n\n"];
    NSString *responseStr4=[responseStr3 stringByReplacingOccurrencesOfString:@"太" withString:@""];

    return responseStr4;
}

/**************************************************************
 ** 功能:     电话号码正则
 ** 参数:     无
 ** 返回:     bool
 **************************************************************/
- (BOOL)validatePhoneNumber{
    
//    \d{3}-\d{8}|\d{4}-\d{7}   (\(\d{3,4}\)|\d{3,4}-|\s)?\d{8}
    
    NSPredicate *passpre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONE];
    
    if ([passpre evaluateWithObject:self]) {
    
        return true;
    }
    
    
    if (self.length != 11) {
        return false;
    }else if(![[self substringToIndex:1] isEqualToString:@"1"]){
        return false;
    }else{
        return true;
    }
    
    
}


/**************************************************************
 ** 功能:     email正则
 ** 参数:     无
 ** 返回:     bool
 **************************************************************/
-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**************************************************************
 ** 功能:     md5加密
 ** 参数:     无
 ** 返回:     nsstring（加密后字符串）
 **************************************************************/
-(NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
}

/**************************************************************
 ** 功能:     获取当前设备型号
 ** 参数:     无
 ** 返回:     字符串
 **************************************************************/

+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return IPHONE_3G;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return IPHONE_3GS;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return IPHONE_4;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return IPHONE_4S;
    if ([deviceString isEqualToString:@"iPhone5,2"])    return IPHONE_5;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

#pragma mark - HTML Methods

- (NSString *)escapeHTML {
	NSMutableString *s = [NSMutableString string];
	
	NSUInteger start = 0;
	NSUInteger len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
                //			case '…':
                //				[s appendString:@"&hellip;"];
                //				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}


- (NSString *)unescapeHTML {
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

@end

#pragma mark-   UIImageView

@implementation UIImageView (Extend)

/**************************************************************
 ** 功能:     二级界面构成－－方形背景
 ** 参数:     整型数（界面第几个view，从0开始,横向数）
 ** 返回:     imageview
 **************************************************************/
+ (UIImageView*)squareBackgroundViewWithNum:(NSInteger)num{
    
    CGFloat xSpace = SQUARE_X_SPACE;
    CGFloat ySpace = SQUARE_Y_SPACE_NOMAL;
    
    CGFloat height;
    if ([[NSString deviceString] isEqualToString:IPHONE_5]) {
        height = SQUARE_HEITHG_IPHONE5;
    }else{
        height = SQUARE_HEITHG;
    }
    
    CGFloat width = SQUARE_WIDTH;
    UIImageView *imgView = [[UIImageView alloc] init];
    CGFloat x; CGFloat y;
    if (num % 2 == 0) {
        x = xSpace;
        y = ySpace + num/2*(height + ySpace);
    }else{
        x = xSpace + (width + xSpace);
        y = ySpace + num/2*(height + ySpace);
    }
    CGRect frame = CGRectMake(x, y, width, height);
    [imgView setFrame:frame];
    [imgView setImage:[UIImage imageNamed:@"white_frame.png"]];
    //[imgView setUserInteractionEnabled:YES];
    return imgView;
}



/**************************************************************
 ** 功能:     头像添加新浪认证
 ** 参数:     UIButton  按钮   style 认证类型 tag 扩展
 ** 返回:     无
 **************************************************************/
- (void)addSinaVWithBtn:(UIView*)btn style:(NSString*)style andBtnTag:(NSString*)tag{
    

    
    NSLog(@"======%@",btn);
    NSLog(@"====tag==%@",tag);

    
    if (!tag  || [tag isEqualToString:@""] || [tag isEqualToString:@"false"]) {
       
        if (!style  || [style isEqualToString:@""] || [style isEqualToString:@"false"]) {
            
            return;
        }

    }
    

    
    
    float x=btn.frame.origin.x;
    float y=btn.frame.origin.y;

    
    float with=btn.frame.size.height/3;
    btn.backgroundColor=[UIColor clearColor];

 
    
    if ([tag isEqualToString:@"O"]) {
        
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(with*2+x, with*2+y, with, with)];
        imageView.image=[UIImage imageNamed:@"头像身份标识.png"];
        imageView.tag=888;
        [btn.superview addSubview:imageView];
//        imageView.backgroundColor=[[UIColor whiteColor] hexStringToColor:greenONE];
        
        return;
        
  
    }else{
    
        UILabel *imageV=[[UILabel alloc]initWithFrame:CGRectMake(with*2+x, with*2+y, with, with)];
        UILabel *imageV_in=[[UILabel alloc]initWithFrame:CGRectMake(2.1, 2.1, with-4.2, with-4.2)];
        
        imageV.tag=888;
        imageV_in.tag=889;
        imageV.text=@"";
        imageV.textColor=[UIColor whiteColor];
        imageV.textAlignment=NSTextAlignmentCenter;
        //    imageV.font=[UIFont systemFontOfSize:with-2];
        
        
        
        imageV_in.text=@"V";
        imageV_in.textColor=[UIColor whiteColor];
        imageV_in.textAlignment=NSTextAlignmentCenter;
        imageV_in.font=[UIFont systemFontOfSize:(with*2)/3];
        
        [imageV addSubview:imageV_in];
        
        
        if ([style isEqualToString:@"true"]) {
            ///橙色V标记
            imageV.textColor=[UIColor colorWithHexValue:0xf9a825];
            //        imageV.textColor=[UIColor redColor];
            [btn.superview addSubview:imageV];
        }else{
            ////无标记
            
        }
        
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = with/2.0;
        imageV.layer.borderWidth = 2.0;
        imageV.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        
    }
    

    
}





@end



#pragma mark-   UILabel


@implementation UILabel (Extend)

+ (UILabel*)squareCenterLableWithText:(NSString*)text
{
    UILabel  *label=[[UILabel  alloc]init];
    label.textColor=[UIColor colorWithHexValue:0xffffff];
    label.font=[UIFont systemFontOfSize:15*RATIO];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    return label;
}

///设置位圆角阴影
-(UILabel*)markround:(UILabel*)view Color:(UIColor*)color{
    
    
    view.layer.shadowOffset = CGSizeMake(1, 2);
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOpacity=0.3;
    view.layer.shadowRadius = 1.0;
    
    
    return view;
}
-(UILabel*)customLabel:(UILabel*)label withString:(NSString*)string font:(UIFont*)font{
    
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    // 需要改变的区间
    NSRange range = [label.text rangeOfString:string];
    // 改变颜色
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:font range:range];
    // 为label添加Attributed
    [label setAttributedText:noteStr];
    
    return label ;
}

@end


#pragma mark-   UIButton

@implementation UIButton (Extend)

/**************************************************************
 ** 功能:     二级界面构成－－方形图上最外层button
 ** 参数:     整型数（界面第几个view，从0开始,横向数）
 ** 返回:     uibutton
 **************************************************************/
+ (UIButton*)squareCenterButtonWithNum:(NSInteger)num{
    CGFloat xSpace = SQUARE_X_SPACE;
    CGFloat ySpace = SQUARE_Y_SPACE_NOMAL;
    
    CGFloat height;
    if ([[NSString deviceString] isEqualToString:IPHONE_5]) {
        height = SQUARE_HEITHG_IPHONE5;
    }else{
        height = SQUARE_HEITHG;
    }
    
    CGFloat width = SQUARE_WIDTH;
    //CGFloat height = SQUARE_HEITHG;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    CGFloat x; CGFloat y;
    if (num % 2 == 0) {
        x = xSpace;
        y = ySpace + num/2*(height + ySpace);
    }else{
        x = xSpace + (width + xSpace);
        y = ySpace + num/2*(height + ySpace);
    }
    CGRect frame = CGRectMake(x, y, width, height);
    [btn setFrame:frame];
    [btn showsTouchWhenHighlighted];
    [btn setAdjustsImageWhenHighlighted:YES];
    return btn;
}

@end




@implementation UIView (Extend)
/**************************************************************
 ** 功能:     下载的progerssview
 ** 参数:     frame，背景颜色，透明度
 ** 返回:     uiview
 **************************************************************/
+ (UIView*)progressViewWithFrame:(CGRect)frame color:(UIColor*)color alpha:(CGFloat)alpha andText:(NSString*)text{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    view.alpha = alpha;
    
    CGFloat proWidth = frame.size.width*3/4;
    CGFloat proHeight = 10;
    //add progress  0
    UIProgressView *prov = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [prov setFrame:CGRectMake((frame.size.width - proWidth)/2, (frame.size.height - proHeight)/3, proWidth, proHeight)];
    [view addSubview:prov];
    
    CGFloat lableWidth = frame.size.width*3/4;
    CGFloat lableHeight = 20;
    //add lable    1
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - lableWidth)/2, prov.frame.origin.y + prov.frame.size.height + 10, lableWidth, lableHeight)];//(frame.size.height - lableHeight)
    lable.text = text;
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lable];
    
    return view;
}



///设置位圆角
+(UIView*)markround:(UIView*)view radius:(float)rad Width:(float)wid Color:(UIColor*)color{
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = rad;
    view.layer.borderWidth = wid;
    view.layer.borderColor = [color CGColor];
    
    return view;
}




@end


@implementation NSObject (Extend)

/**************************************************************
 ** 功能:     协助解析 将object对象转成数组
 ** 参数:     无
 ** 返回:     数组
 **************************************************************/
- (NSArray*)convertToArray{
    if ([self isKindOfClass:[NSArray class]]) {
        return (NSArray*)self;
    }else if ([self isKindOfClass:[NSDictionary class]]){
        NSArray *array = [NSArray arrayWithObject:(NSDictionary*)self];
        return array;
    }else{
        NSArray *array = [NSArray arrayWithObject:self];
        return array;
    }
}

/**************************************************************
 ** 功能:     协助解析 将object对象转成字典
 ** 参数:     无
 ** 返回:     数组
 **************************************************************/
- (NSDictionary*)convertToDict{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)self;
    }else if ([self isKindOfClass:[NSString class]]){
        NSDictionary *dict = [NSDictionary dictionaryWithObject:(NSString*)self forKey:@"a"];
        return dict;
    }else{
        return [NSDictionary dictionaryWithObject:@"" forKey:@""];
    }
}

@end


#pragma mark  UIimage
@implementation UIImage (Extend)

+ (UIImage *)imageNamedNoCache:(NSString *)imageName
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = nil;
    if ([imageName hasSuffix:@"png"]) {
        filePath = [NSString stringWithFormat:@"%@/%@", bundlePath, imageName];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@.png",bundlePath, imageName];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}



- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


///////改变图片颜色

- (UIImage *) imageWithTintColor:(UIColor *)tintColor image:(UIImage*)img alpha:(float)alpha
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    //    UIImage *image0 =  [self addImage:img withImage:self.WIthImage ];
        UIImage *image0 = img;
        
        UIGraphicsBeginImageContextWithOptions(image0.size, NO, 0.0f);
        
        [tintColor setFill];
        
        CGRect bounds = CGRectMake(0, 0, image0.size.width, image0.size.height);
        UIRectFill(bounds);
        
        //Draw the tinted image in context
        [image0 drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:alpha];
        
        UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return tintedImage;
}

/////图片旋转
-(UIImage *)overTurnWithImage:(UIImage*)img{
    
    
    CGSize size = img.size;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGContextRotateCTM(ctx, M_PI*2);
    
    CGContextDrawImage(ctx, CGRectMake(0,0,size.width, size.height), img.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask   sourImage:(UIImage*)sourImage inRect:(CGRect)rect useName:(NSString*)useName
{
    
    int multiple=2;
    
    CGSize size=CGSizeMake(1242/multiple, 1242/multiple);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext(size);
    }
#endif
    
    //原图
//    [sourImage drawInRect:CGRectMake(0, 0, sourImage.size.width, sourImage.size.height)];
    
    [sourImage drawInRect:CGRectMake(0, 0, size.height, size.height)];

    
    //水印图
    rect.origin.y= sourImage.size.height-sourImage.size.height-10;
    [mask drawInRect:CGRectMake(0, 0, size.height, size.height)];
    
    
    UILabel  *lab=[[UILabel alloc]init];
    lab.text=[NSString stringWithFormat:@"%@",useName];
    lab.font=[UIFont systemFontOfSize:31];
    
    CGSize labSize=[UIHelper  makeNewRectView:lab oldSize:CGSizeMake(size.width*(2/3)/multiple, 30/multiple)];
    
    labSize.width=labSize.width+10; 
    
    
    NSDictionary  *dic_darw=@{NSForegroundColorAttributeName:[UIColor colorWithHexValue:0x737279],NSFontAttributeName: [UIFont boldSystemFontOfSize:31/multiple] };
    [lab.text drawInRect:CGRectMake(82*2/multiple,18*2/multiple,labSize.width, 35/multiple) withAttributes:dic_darw];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    return newPic;
    
//    return [self addText:newPic text:[NSString stringWithFormat:@"作者：%@",useName]];
}

#pragma mark  ////加文字

- (UIImage *) addText:(UIImage *)img text:(NSString *)mark {
    int w = img.size.width;
    int h = img.size.height;
    
//    UILabel  *lab=[[UILabel alloc]init];
//    lab.text=mark;
//    lab.font=[UIFont systemFontOfSize:25];
//    
//    CGSize labSize=[UIHelper  makeNewRectView:lab oldSize:CGSizeMake(700, 30)];
//    
//    labSize.width=labSize.width+10;
    
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary  *dic=@{NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x8bc34a],NSFontAttributeName: [UIFont boldSystemFontOfSize:25] };
    
    [mark drawInRect:CGRectMake(w/2,h-50, w/2, 30) withAttributes:dic];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    [lab release];

    return aimg;
    
}



/////根据url 获取图片
+(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
        return result;
    
}

/////根据 组装图片   获取图片
+(UIImage *)loadNewImageWithDic:(NSDictionary *)dic  drawImage:(UIImage*)drawImage {
    
    UIImage *BGImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",[dic objectForKey:@"style"],[dic objectForKey:@"color"]]];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([BGImage size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [BGImage drawInRect:CGRectMake(0, 0, BGImage.size.width, BGImage.size.height)];
    //水印图
    
    CGRect rect;
    if ([[dic objectForKey:@"style"] isEqualToString:@"A1"]) {
        rect=CGRectMake((BGImage.size.width-240)/2, 200, 240, 150);
    }else if ([[dic objectForKey:@"style"] isEqualToString:@"A2"]){
        rect=CGRectMake((BGImage.size.width-220)/2, 200, 200, 150);

    }else{
        rect=CGRectMake(230, 200, 200, 150);

    }
 
    [drawImage drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return newPic;
    
}



@end









