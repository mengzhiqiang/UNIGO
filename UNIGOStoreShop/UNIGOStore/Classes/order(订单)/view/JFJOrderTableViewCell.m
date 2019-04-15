//
//  JFJOrderTableViewCell.m
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "JFJOrderTableViewCell.h"

@implementation JFJOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_DeleteOrderButton draCirlywithColor:[UIColor grayColor] andRadius:0.5f];
    [_payButton draCirlywithColor:[UIColor orangeColor] andRadius:0.5f];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectOrderButton:(UIButton *)sender {
    
    NSString * status = @"pay";
    if (sender.tag==10) {
        status = @"delete";
    }
    
    if (_backSelect) {
        _backSelect(status);
    }
    
}

@end
