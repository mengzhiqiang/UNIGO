//
//  DCShopCarModel.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCShopCarModel : NSObject
/** 商品ID  */
@property (nonatomic, copy ) NSString *identifier;
/** 图片URL */
@property (nonatomic, copy ) NSString *image;
/** 商品标题 */
@property (nonatomic, copy ) NSString *name;

/** 商品价格 */
@property (nonatomic, copy ) NSString *price;
/** 市场价格 */
@property (nonatomic, copy ) NSString *market_price;

/** 数量 */
@property (nonatomic, copy ) NSString *count;

/** 是否选中 */
@property (nonatomic, assign ) BOOL isSelect;
/** 剩余库存 */
@property (nonatomic, copy ) NSString *stock;
/** 销量 */
@property (nonatomic, copy ) NSString *sales;

/** 属性 */
@property (nonatomic, copy ) NSString *nature;

/** 属性id */
@property (nonatomic, copy ) NSString *natureID;
/** 商品小标题 */
@property (nonatomic, copy ) NSString *info;

@end

NS_ASSUME_NONNULL_END
