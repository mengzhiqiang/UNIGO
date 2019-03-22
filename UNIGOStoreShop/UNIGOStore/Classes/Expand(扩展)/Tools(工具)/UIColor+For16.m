//
//  UIColor+For16.m
//  SmartDevice
//
//  Created by singelet on 16/6/27.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UIColor+For16.h"

@implementation UIColor (For16)

+ (UIColor *)colorWithHexValue:(NSInteger)haxValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((CGFloat)((haxValue & 0xFF0000) >> 16))/255.0
                           green:((CGFloat)((haxValue & 0xFF00) >> 8))/255.0
                            blue:((CGFloat)(haxValue & 0xFF))/255.0 alpha:alpha];

}

+ (UIColor *)colorWithHexValue:(NSInteger)haxValue
{
    return [UIColor colorWithHexValue:haxValue alpha:1.0f];
}

+ (NSString *)hexValueFromColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}


- (UIColor *)colorWithHexString:(NSString *) haxString
{
    NSString *cString = [[haxString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor *)HexString:(NSString *) haxString{

   return [[self clearColor]colorWithHexString:haxString];
}



@end
