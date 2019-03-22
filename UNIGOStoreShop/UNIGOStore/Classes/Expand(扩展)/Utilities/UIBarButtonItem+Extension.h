//
//  UIBarButtonItem+Extension.h
//  SmartDevice
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)color;
@end
