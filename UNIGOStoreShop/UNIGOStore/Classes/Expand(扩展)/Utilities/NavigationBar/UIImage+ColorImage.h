//
//  UIImage+ColorImage.h
//  SmartDevice
//
//  Created by singelet on 16/6/23.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
