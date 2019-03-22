//
//  UIView+ZHRoundCorner.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/6.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIView+ZHRoundCorner.h"

@implementation UIView (ZHRoundCorner)

- (void)zh_setAllRound
{
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)zh_setCornerWithRectCorner:(UIRectCorner)rectCorner cornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)zh_setAllCornerWithCornerRadius:(CGFloat)cornerRadius
{
    [self zh_setCornerWithRectCorner:UIRectCornerAllCorners cornerRadius:cornerRadius];
}

- (void)zh_setCornerOnTopWithCornerRadius:(CGFloat)cornerRadius
{
    [self zh_setCornerWithRectCorner:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadius:cornerRadius];
}

- (void)zh_setCornerOnBottomWithCornerRadius:(CGFloat)cornerRadius
{
    [self zh_setCornerWithRectCorner:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadius:cornerRadius];
}

- (void)zh_setNoCorner
{
    self.layer.mask = nil;
}

@end
