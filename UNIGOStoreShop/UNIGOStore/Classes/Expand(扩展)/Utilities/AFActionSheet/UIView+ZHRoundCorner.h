//
//  UIView+ZHRoundCorner.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHRoundCorner)

- (void)zh_setAllRound;
- (void)zh_setCornerWithRectCorner:(UIRectCorner)rectCorner cornerRadius:(CGFloat)cornerRadius;
- (void)zh_setAllCornerWithCornerRadius:(CGFloat)cornerRadius;
- (void)zh_setCornerOnTopWithCornerRadius:(CGFloat)cornerRadius;
- (void)zh_setCornerOnBottomWithCornerRadius:(CGFloat)cornerRadius;
- (void)zh_setNoCorner;

@end
