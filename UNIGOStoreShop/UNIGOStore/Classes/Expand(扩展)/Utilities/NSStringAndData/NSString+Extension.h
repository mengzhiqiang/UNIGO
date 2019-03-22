//
//  NSString+Extension.h
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/13.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *   根据手机适配不同链接图片
 *
 *  @return 图片链接
 */
+ (NSString *)getImageUrlWithCover:(NSDictionary*)cover;


// 图片转64base字符串
+ (NSString *)imageToString:(UIImage *)image;

// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str ;

//给定一个字符串，对该字符串进行Base64编码，然后返回编码后的结果
+(NSString *)base64EncodeString:(NSString *)string;

//对base64编码后的字符串进行解码
+(NSString *)base64DecodeString:(NSString *)string;

@end
