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
    
    int shopCount = [_shopCar.count intValue];
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
    
    _countTF.text = [NSString stringWithFormat:@"%d",shopCount];
    _shopCar.count = _countTF.text;
    if (_backSelect) {
        _backSelect(_shopCar);
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
    _goodsdetailLabel.text = shopCar.info;
    _priceLabel.text = shopCar.price;
    _countTF.text = shopCar.count;
    
    if (_shopCar.isSelect) {
       
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];;

    }else{
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];;

    }
    
}

@end
