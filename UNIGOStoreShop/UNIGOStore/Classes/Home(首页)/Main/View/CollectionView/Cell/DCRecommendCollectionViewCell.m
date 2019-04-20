//
//  DCRecommendCollectionViewCell.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 20/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCRecommendCollectionViewCell.h"

@implementation DCRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setRecommendItem:(DCHomeRecommend *)RecommendItem{
    _RecommendItem = RecommendItem;
    
    _titleLabel.text = RecommendItem.title;
    _descLabel.text = RecommendItem.desc;

    [_goodsImageView setImageWithURL:[NSURL URLWithString:RecommendItem.image] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
}
@end
