//
//  AboutUslistViewController.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/5/18.
//  Copyright © 2016年 ALPHA. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "TitleOfHeardViewController.h"
@interface AboutUslistViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *rootTableView;

@property (strong, nonatomic) IBOutlet UIView *headRootView;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *jfjVersionLabel;

@end
