//
//  DCShopCar.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCShopCarModel.h"
#import "DCShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCShopCar : NSObject

@property(nonatomic,strong) NSMutableArray <DCShopModel*> *carList ;

@property(nonatomic,strong) NSMutableArray <DCShopCarModel*> *buyList ;

+(id) sharedDataBase ;

@end

NS_ASSUME_NONNULL_END
