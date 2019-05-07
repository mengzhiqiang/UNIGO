//
//  DCShopCarTableViewCell.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 29/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCShopCarModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface DCShopCarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsdetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mousButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *countTF;

@property (weak, nonatomic)  DCShopCarModel *shopCar;

@property (copy, nonatomic)  void (^backSelect)(DCShopCarModel*model);

@property (copy, nonatomic)  void (^backShopCount)(DCShopCarModel*model);

@end

NS_ASSUME_NONNULL_END
