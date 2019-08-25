//
//  DCHomeGoodsCollectionViewCell.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 1/8/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCHomeGoodsCollectionViewCell.h"

@implementation DCHomeGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadNewUI:(DCHomeGoodsItem*)diction{
    
    NSString * image = diction.image;

    _priceLabel.text = [NSString stringWithFormat:@"¥ %@",diction.price] ;
    _goodsTitleLabel.text = diction.name;
    _smartPriceLabel.text = diction.market_price;

    NSString *textStr = [NSString stringWithFormat:@"¥ %@",diction.market_price];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    // 赋值
    _smartPriceLabel.attributedText = attribtStr;
    
    if (diction.market_price.floatValue <= diction.price.floatValue) {
        _smartPriceLabel.hidden = YES;
    }
    
    if (image.length == 0) return;
    if ([[image substringToIndex:4] isEqualToString:@"http"]) {
        [_rootImageView sd_setImageWithURL:[NSURL URLWithString:image]placeholderImage:[UIImage imageNamed:@"default_image"]];
    }else{
        _rootImageView.image = [UIImage imageNamed:image];
    }
}
@end
