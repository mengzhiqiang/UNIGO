//
//  DCRecommendItem.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCRecommendItem : NSObject

/** 商品ID  */
@property (nonatomic, copy ,readonly) NSString *identifier;
/** 图片URL */
@property (nonatomic, copy ,readonly) NSString *image;
/** 商品标题 */
@property (nonatomic, copy ,readonly) NSString *name;

/** 商品价格 */
@property (nonatomic, copy ,readonly) NSString *price;
/** 市场价格 */
@property (nonatomic, copy ,readonly) NSString *market_price;

/** 剩余库存 */
@property (nonatomic, copy ,readonly) NSString *stock;
/** 销量 */
@property (nonatomic, copy ,readonly) NSString *sales;

/** 属性 */
@property (nonatomic, copy ,readonly) NSString *nature;
/** 商品小标题 */
@property (nonatomic, copy ,readonly) NSString *info;

/* 头部轮播 */
@property (copy , nonatomic , readonly)NSArray *images;

@end
