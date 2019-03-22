//
//  NSData+zh_JSON.h
//  SmartDevice
//
//  Created by singelet on 16/6/12.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (zh_JSON)

// 字典转Data
+ (NSData *)zh_dataFromJSON:(NSDictionary *)dic;

// Data转字典
+ (NSDictionary *)zh_JSONFromData:(NSData *)data;

// 字典数组转JSONString
+ (NSString *)zh_JSONStringWithObject:(id)object;

//压缩
+ (NSData *)gzipDeflate:(NSData*)data;
//解压缩
+ (NSData *)gzipInflate:(NSData*)data;

+(NSString*)changeData:(NSDictionary*)diction ;
@end
