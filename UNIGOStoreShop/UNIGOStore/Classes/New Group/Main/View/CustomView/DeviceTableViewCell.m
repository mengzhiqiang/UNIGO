//
//  DeviceTableViewCell.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/3/14.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "Define.h"
#import "ExtendClass.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self markround:_pointLabel Color:nil];
    
}

///设置位圆角阴影
-(UIView*)markround:(UIView*)view Color:(UIColor*)color{
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    
    
    return view;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
