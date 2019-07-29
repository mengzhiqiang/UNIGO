//
//  DCHomeGoodsItem.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/7/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCHomeGoodsItem : NSObject

/** 图片  */
@property (nonatomic, copy ) NSString *image;
/** 文字  */
@property (nonatomic, copy ) NSString *name;
/** 链接  */
@property (nonatomic, copy ) NSString *url;
/** 价格  */
@property (nonatomic, copy ) NSString *price;
/** 原价  */
@property (nonatomic, copy ) NSString *market_price;
/** 商品ID  */
@property (nonatomic, copy ) NSString *identity;
/** 商品销量  */
@property (nonatomic, copy ) NSString *sales;
/** 商品库存  */
@property (nonatomic, copy ) NSString *stock;
@end

NS_ASSUME_NONNULL_END
