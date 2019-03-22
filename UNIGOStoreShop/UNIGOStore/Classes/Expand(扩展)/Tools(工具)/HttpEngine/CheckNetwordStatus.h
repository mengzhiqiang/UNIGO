//
//  CheckNetwordStatus.h
//  SmartDevice
//
//  Created by singelet on 16/6/15.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AFNetworkStatus)
{
    NetworkStatusNotReachable = 1 << 1,
    NetworkStatusReachableViaWWAN = 1 << 2,
    NetworkStatusReachableViaWiFi = 1 << 3
};

@interface CheckNetwordStatus : NSObject

@property (nonatomic, assign)BOOL isNetword; //

@property (nonatomic, assign)AFNetworkStatus networdType;//网络状态

+ (instancetype)sharedInstance;

@end
