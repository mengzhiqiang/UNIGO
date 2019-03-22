//
//  UIScrollView+zh_EdgeInsets.m
//  AFJiaJiaMob
//
//  Created by singelet on 2017/1/9.
//  Copyright © 2017年 AoFei. All rights reserved.
//

#import "UIScrollView+zh_EdgeInsets.h"


#define NavBarHeight  64

@implementation UIScrollView (zh_EdgeInsets)

- (void)resetContentInset
{
    self.contentInset = UIEdgeInsetsMake(NavBarHeight, 0, 0, 0);
}

//+ (void)load
//{
//    [[UIScrollView appearance] setContentInset:UIEdgeInsetsMake(NavBarHeight, 0, 0, 0)];
//}

@end
