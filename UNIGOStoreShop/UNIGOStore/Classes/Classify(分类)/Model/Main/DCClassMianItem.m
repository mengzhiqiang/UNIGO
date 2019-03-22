//
//  DCClassMianItem.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCClassMianItem.h"

@implementation DCClassMianItem

+(void )load
{
    [DCClassMianItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}

@end
