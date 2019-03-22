//
//  UIImageView+Extension.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/26.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Extension)


- (void)zh_BlurImageWithUrlString:(NSString *)string placeholderImage:(UIImage *)placeholderImage
{
    
    [self sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage blurImageWithImage:placeholderImage] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.image = [UIImage blurImageWithImage:image];
        }
    }];
}

- (void)zh_BlurEffectWithImage:(UIImage *)image
{
//    UIImageView *blurImgv = [[UIImageView alloc]initWithFrame:CGRectMake(50, 500, 150, 150)];
//    blurImgv.image = image;
//    [self.view addSubview:blurImgv];
    self.image = image;
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:view];
}


@end
