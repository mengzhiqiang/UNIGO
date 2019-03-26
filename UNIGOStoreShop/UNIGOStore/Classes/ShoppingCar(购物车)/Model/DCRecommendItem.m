//
//  DCRecommendItem.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCRecommendItem.h"

@implementation DCRecommendItem

+(void )load
{
    [DCRecommendItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}
@end
