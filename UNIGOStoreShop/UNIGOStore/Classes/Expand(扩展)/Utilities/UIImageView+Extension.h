//
//  UIImageView+Extension.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/26.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

- (void)zh_BlurImageWithUrlString:(NSString *)string placeholderImage:(UIImage *)placeholderImage;

- (void)zh_BlurEffectWithImage:(UIImage *)image;

@end
