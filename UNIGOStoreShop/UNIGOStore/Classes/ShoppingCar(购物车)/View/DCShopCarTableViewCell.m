//
//  DCShopCarTableViewCell.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCShopCarTableViewCell.h"

@implementation DCShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editCount:(UIButton *)sender {
    
    int shopCount = [_shopCar.cart_num intValue];
    if (sender.tag==10) {
        
        if (shopCount>1) {
            shopCount--;
        }else{
            shopCount=1;
        }
    }else{
        
        if (shopCount<[_shopCar.stock intValue]) {
            shopCount ++;
        }else{
            shopCount = [_shopCar.stock intValue];
        }
        
    }
    if ( [_shopCar.stock intValue]==0) {
        shopCount = 1 ;
    }
    
    _countTF.text = [NSString stringWithFormat:@"%d",shopCount];
    _shopCar.cart_num = _countTF.text;
    if (_backShopCount) {
        _backShopCount(_shopCar);
    }
    
}
- (IBAction)selcetRow:(UIButton *)sender {
    
    _shopCar.isSelect = !_shopCar.isSelect ;
    if (_backSelect) {
        _backSelect(_shopCar);
    }
}

-(void)setShopCar:(DCShopCarModel *)shopCar{
    _shopCar = shopCar;
    
    _goodsTitleLabel.text = shopCar.name ;
    _goodsdetailLabel.text = shopCar.spec_name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",shopCar.price];
    _countTF.text = shopCar.cart_num;
    
    [_shopImageView setImageWithURL:[NSURL URLWithString:shopCar.image] placeholderImage:[UIImage imageNamed:@"bj_baobei"] ];
    if (_shopCar.isSelect) {
       
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];;

    }else{
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];;

    }
}

@end
