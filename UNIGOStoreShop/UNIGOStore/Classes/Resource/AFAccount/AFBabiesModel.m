//
//  AFBabiesModel.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/25.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFBabiesModel.h"

@implementation AFBabiesModel

MJCodingImplementation

+ (void)load
{
    [AFBabiesModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"data" : @"AFBabyData"};
    }];
}

@end


@implementation AFBabyData

MJCodingImplementation


+ (void)load
{
    [AFBabyData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
    
    [AFBabyData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"avatar" : @"AFBabyAvatar", @"ctx" : @"AFCtx"};
    }];
}

@end

@implementation AFBabyAvatar

MJCodingImplementation

//+ (instancetype)mj_objectWithKeyValues:(id)keyValues
//{
//    AFBabyAvatar *babyAvatar = [AFBabyAvatar mj_objectWithKeyValues:keyValues];
//    
//    if (babyAvatar.small.length > 0) {
//        babyAvatar.smallImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:babyAvatar.small]]];
//    }
//
//    if (babyAvatar.large.length > 0) {
//        babyAvatar.largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:babyAvatar.large]]];
//
//    }
//    
//    if (babyAvatar.medium.length > 0) {
//        babyAvatar.mediumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:babyAvatar.medium]]];
//
//    }
//    return babyAvatar;
//}

@end

@implementation AFCtx

MJCodingImplementation

@end
