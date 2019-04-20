//
//  DCRecommendList.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 20/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCHomeRecommend;

NS_ASSUME_NONNULL_BEGIN

@interface DCRecommendList : NSObject

/** 商品ID  */
@property (nonatomic, copy ) NSMutableArray  <DCHomeRecommend *>*data;
/** 图片URL */
@property (nonatomic, copy ) NSString *image;
/** 商品标题 */
@property (nonatomic, copy ) NSString *name;

@end

@interface DCHomeRecommend : NSObject



/** 图片URL */
@property (nonatomic, copy ) NSString *image;

/** 跳转URL */
@property (nonatomic, copy ) NSString *url;
/** 商品标题 */
@property (nonatomic, copy ) NSString *title;

@property (nonatomic, copy ) NSString *type;
@property (nonatomic, copy ) NSString *desc;

@end

NS_ASSUME_NONNULL_END
