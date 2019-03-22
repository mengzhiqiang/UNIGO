//
//  UIColor+For16.h
//  SmartDevice
//
//  Created by singelet on 16/6/27.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (For16)


+ (UIColor *)colorWithHexValue:(NSInteger)haxValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexValue:(NSInteger)haxValue;

+ (NSString *)hexValueFromColor:(UIColor *)color;

////颜色值转颜色
- (UIColor *)colorWithHexString:(NSString *)haxString;

+(UIColor *)HexString:(NSString *) haxString;


@end
