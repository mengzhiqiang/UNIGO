//
//  NSData+DES.h
//  SmartDevice
//
//  Created by singelet on 16/6/27.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DES)

- (NSData *)des_EncryptWithKey:(NSString *)key;   // 加密

- (NSData *)des_DecryptWithKey:(NSString *)key;   // 解密

@end
