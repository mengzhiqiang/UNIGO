//
//  DCDetailGoodReferralCell.h
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCDetailGoodReferralCell : UICollectionViewCell

/* 商品标题 */
@property (strong , nonatomic)UILabel *goodTitleLabel;
/* 商品价格 */
@property (strong , nonatomic)UILabel *goodPriceLabel;

/* 商品原价 */
@property (strong , nonatomic)UILabel *goodMarketPriceLabel;
/* 商品小标题 */
@property (strong , nonatomic)UILabel *goodSubtitleLabel;

/* 销量 */
@property (strong , nonatomic)UILabel *goodSaleCountLabel;
/* 优惠按钮 */
@property (strong , nonatomic)UIButton *preferentialButton;


/** 分享按钮点击回调 */
@property (nonatomic, copy) dispatch_block_t shareButtonClickBlock;


@end
