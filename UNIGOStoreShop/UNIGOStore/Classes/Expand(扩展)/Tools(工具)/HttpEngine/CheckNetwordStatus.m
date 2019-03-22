//
//  CheckNetwordStatus.m
//  SmartDevice
//
//  Created by singelet on 16/6/15.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "CheckNetwordStatus.h"

static CheckNetwordStatus *sharedInstance = nil;

@implementation CheckNetwordStatus

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //注意：这里建议使用self,而不是直接使用类名（考虑继承）
        sharedInstance = [[self alloc] init];
        sharedInstance.isNetword = YES;
    });
    return sharedInstance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    //使用GCD中的一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}
//让代码更加的严谨
- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return sharedInstance;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return sharedInstance;
}

@end
