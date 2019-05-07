//
//  DCShopCarModel.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCShopCarModel.h"

@implementation DCShopCarModel

+(void )load
{
    [DCShopCarModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identifier" : @"id"};
    }];
    
}
@end
