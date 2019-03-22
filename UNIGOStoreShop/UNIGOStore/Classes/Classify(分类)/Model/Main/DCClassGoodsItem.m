//
//  DCClassGoodsItem.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCClassGoodsItem.h"

@implementation DCClassGoodsItem

MJCodingImplementation

+ (void)load
{
    [DCClassGoodsItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    

}

@end
