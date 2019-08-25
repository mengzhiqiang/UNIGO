//
//  DCListGridCell.h
//  CDDMall
//
//  Created by apple on 2017/6/14.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCHomeGoodsItem;

@interface DCListGridCell : UICollectionViewCell

/* 推荐数据 */
@property (strong , nonatomic)DCHomeGoodsItem *youSelectItem;

/** 冒号点击回调 */
@property (nonatomic, copy) dispatch_block_t colonClickBlock;

@end
