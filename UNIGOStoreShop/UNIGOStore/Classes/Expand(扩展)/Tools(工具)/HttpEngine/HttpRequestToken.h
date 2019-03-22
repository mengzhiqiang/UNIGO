//
//  HttpRequestToken.h
//  SmartDevice
//
//  Created by singelet on 16/6/12.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestToken : NSObject

//解析token 判断是否失效

+ (BOOL)analysisToken:(NSString*)token;

//保存token
+ (void)saveToken:(NSString *)token;

+ (NSString*)getToken;

@end
