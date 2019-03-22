//
//  DeviceTableViewCell.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/3/14.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *DeviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *DeviceNameLable;
@property (weak, nonatomic) IBOutlet UIView *rootDeviceView;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TagImageView;
@property (weak, nonatomic) IBOutlet UIButton *bandButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;


//cell 1
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushNextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pushTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;



@end
