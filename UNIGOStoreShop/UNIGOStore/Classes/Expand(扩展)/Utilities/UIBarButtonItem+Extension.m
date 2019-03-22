//
//  UIBarButtonItem+Extension.m
//  SmartDevice
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
@implementation UIBarButtonItem (Extension)

/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageEdgeInsets = UIEdgeInsetsMake(9, -5, 9, 30);
    [btn setTitleColor:[UIColor grayColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置尺寸
    //    btn.frame = CGRectMake(0, 0, 40, 40);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color
{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    //    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置尺寸
    //    btn.frame = CGRectMake(0, 0, 40, 40);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
