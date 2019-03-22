//
//  AFRegisterAccountViewController.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "TitleOfHeardViewController.h"


typedef NS_ENUM(NSInteger,AFViewControllerType)
{
    AFViewControllerTypeRegister = 1 << 1,
    AFViewControllerTypeForget = 1 << 2
};

@interface AFRegisterAccountViewController : TitleOfHeardViewController


@property (nonatomic, assign)AFViewControllerType viewType;
@end
