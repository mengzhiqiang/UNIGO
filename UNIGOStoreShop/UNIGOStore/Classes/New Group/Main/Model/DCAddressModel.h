//
//  DCAddressModel.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 7/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DCAdressItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAddressModel : NSObject

@property (strong , nonatomic)NSMutableArray <DCAdressItem*> *addressList;

/**
 DataBase数据
 
 @return 数据
 */
+ (instancetype)sharedDataBase;
@end

NS_ASSUME_NONNULL_END
