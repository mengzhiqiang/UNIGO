//
//  DCGoodsSortCell.h
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCClassMianItem;

@interface DCGoodsSortCell : UICollectionViewCell

/* 品牌数据 */
@property (strong , nonatomic)DCClassMianItem *subItem;

/* imageView */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* label */
@property (strong , nonatomic)UILabel *goodsTitleLabel;
@end
