//
//  DCShowTypeFourCell.m
//  CDDMall
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCShowTypeFourCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCShowTypeFourCell ()



@end

@implementation DCShowTypeFourCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)setUpData
{
    self.iconImageView.image = [UIImage imageNamed:@"MG_payVoucher"];
    self.iconImageView.frame = CGRectMake(10, 10, 40, 40);
    [self.iconImageView draCirlywithColor:nil andRadius:20.f];
    [self addSubview:self.iconImageView];
    
    self.contentLabel.text = @"店铺名称";
    [self addSubview:self.contentLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //重写leftTitleLableFrame
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.left.mas_equalTo(self)setOffset:DCMargin];
//        make.centerY.mas_equalTo(self);
//    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.iconImageView.mas_right)setOffset:DCMargin];
        make.centerY.mas_equalTo(self);
    }];
    
    
}

#pragma mark - Setter Getter Methods

@end
