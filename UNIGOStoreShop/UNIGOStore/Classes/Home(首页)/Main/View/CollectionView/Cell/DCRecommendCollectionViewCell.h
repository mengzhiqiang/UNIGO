//
//  DCRecommendCollectionViewCell.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 20/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCRecommendList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCRecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

/* 推荐数据 */
@property (strong , nonatomic)DCHomeRecommend *RecommendItem;

@end

NS_ASSUME_NONNULL_END
