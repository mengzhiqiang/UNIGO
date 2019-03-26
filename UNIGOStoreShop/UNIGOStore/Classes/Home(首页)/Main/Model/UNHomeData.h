//
//  UNHomeData.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface UNHomeData : NSObject


+(void)getBanner:(void(^)(id responseObject))success
           error:(void(^)(NSDictionary *error))fail;


+(void)getRecommend:(void(^)(id responseObject))success
           error:(void(^)(NSDictionary *error))fail;

+(void)getGoodDetailWithID:(NSString*)goodID success:(void(^)(id responseObject))success
              error:(void(^)(NSDictionary *error))fail;

@end

NS_ASSUME_NONNULL_END
