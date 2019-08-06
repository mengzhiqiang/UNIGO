//
//  DCHomeGoodsCollectionViewCell.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 1/8/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCHomeGoodsItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCHomeGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rootImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *smartPriceLabel;

-(void)loadNewUI:(DCHomeGoodsItem*)diction;
@end

NS_ASSUME_NONNULL_END
