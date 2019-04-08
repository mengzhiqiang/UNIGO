//
//  DCShopCar.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCShopCar.h"

@implementation DCShopCar


static DCShopCar *shopcar = nil;
+(id) sharedDataBase
{
    @synchronized(self)
    {
        if (shopcar == nil)
        {
            shopcar = [[DCShopCar alloc] init];
            shopcar.carList = [NSMutableArray array];
            shopcar. buyList = [NSMutableArray array];

        }
    }
    return shopcar;
}

@end
