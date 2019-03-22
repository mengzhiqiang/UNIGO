//
//  NSString+Extension.m
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/13.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)getImageUrlWithCover:(NSDictionary*)cover{
    
    if (iPhone5|| isPAD_or_IPONE4) {
        return  [cover objectForKey:@"small"];
    }
    else if (iPhone6) {
        return  [cover objectForKey:@"medium"];
    }
    else if (iPhone6plus) {
        return  [cover objectForKey:@"large"];
    }
    else{
        return  [cover objectForKey:@"large"];
    }
}

// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str {
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData ];
    return photo;
    
}
// 图片转64base字符串
+ (NSString *)imageToString:(UIImage *)image
{
    NSData *imagedata = UIImagePNGRepresentation(image);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return image64;
    
}

//给定一个字符串，对该字符串进行Base64编码，然后返回编码后的结果
+(NSString *)base64EncodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
    
}

//对base64编码后的字符串进行解码
+(NSString *)base64DecodeString:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}


@end
