//
//  AFAccount.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/9/19.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFAccount.h"

@implementation AFAccount

MJCodingImplementation

+ (void)load
{
//    [AFAccount mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"identifier" : @"id"};
//    }];
    
    [AFAccount mj_setupObjectClassInArray:^NSDictionary *{
        return @{ @"client" : @"UNClient"};
    }];
}

@end

@implementation UNClient

MJCodingImplementation
+ (void)load
{
    [UNClient mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
    [UNClient mj_setupObjectClassInArray:^NSDictionary *{
        return @{ @"nim" : @"AFAccountNim", @"avatar" : @"AFAccountAvatar", @"config" : @"AFAccountConfig"};
    }];
    
}

@end


@implementation AFAccountAvatar

MJCodingImplementation

@end


@implementation AFAccountNim

MJCodingImplementation

@end

@implementation AFAccountConfig

MJCodingImplementation

+ (void)load
{
    [AFAccountConfig mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"app_cover" : @"AFAppCover"};
    }];
}
@end

@implementation AFAppCover

MJCodingImplementation

@end
