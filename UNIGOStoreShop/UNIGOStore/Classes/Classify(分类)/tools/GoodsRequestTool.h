//
//  GoodsRequestTool.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 24/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsRequestTool : NSObject


+(void)getGoodsCate:(void(^)(id responseObject))success ;

+(void)getGoodsCateWithPram:(NSDictionary*)pram success:(void(^)(id responseObject))success fail:(void (^)(NSDictionary*error))error;

/*
 首页 推荐商品列表
 */
+(void)getHomeGoodsCateWithsuccess:(void(^)(id responseObject))success
                              fail:(void (^)(NSDictionary*error))error ;
@end

NS_ASSUME_NONNULL_END
