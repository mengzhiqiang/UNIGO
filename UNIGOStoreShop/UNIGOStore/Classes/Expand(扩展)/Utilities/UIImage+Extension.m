//
//  UIImage+Extension.m
//  SmartDevice
//
//  Created by singelet on 16/6/28.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Extension)

+ (UIImage *)mergeImage:(NSArray *)imgArray
{
    return nil;
}

+ (UIImage *)mergeImage:(UIImage *)img1 andPoint:(CGPoint)point1 andImg2:(UIImage *)img2 andPoint2:(CGPoint)point2 andMergeImageSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [img1 drawAtPoint:point1];
    [img2 drawAtPoint:point2];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)resizeImage:(UIImage *)originImage andSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [originImage drawInRect:CGRectMake(0, 0, size.width+1, size.height+1)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resizeImage;   //返回的就是已经改变的图片
}

+ (UIImage *)makeStyleMaskImageFromSourceImg:(UIImage *)sourImg andMask:(UIImage *)maskImg andSize:(CGSize)imgSize andTeeSize:(CGSize)teeSize
{
    UIImage *simage = [self getSourceImage:sourImg andSize:imgSize andTeeSize:teeSize];
    UIImage *mimage = [self getMaskImage:maskImg andSize:imgSize];
    UIImage *rimage = [self maskImage:simage andMaskImg:mimage];
    return rimage;
}

+ (UIImage *)maskImage:(UIImage *)sourImg andMaskImg:(UIImage *)maskImg{
    
    CGImageRef maskRef = maskImg.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = sourImg.CGImage;
    CGImageRef imageWithAlpha = sourceImage;
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
    
}

+ (UIImage *)getSourceImage:(UIImage *)sourImg andSize:(CGSize)imgSize andTeeSize:(CGSize)teeSize
{
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 3);
    [sourImg drawInRect:CGRectMake(-(teeSize.width - imgSize.width)/2, -(teeSize.height * 0.20652), teeSize.width, teeSize.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)getMaskImage:(UIImage *)recImage andSize:(CGSize)imgSize
{
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 3);
    
    [recImage drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}


+ (UIImage *)changeShapeColor:(UIImage *)image andColor:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIRectFillUsingBlendMode(bounds, kCGBlendModeColor);
    
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return im;
}


+ (UIImage *)zh_fetchImage:(NSString *)imageNameOrPath{
    UIImage *image = [UIImage imageNamed:imageNameOrPath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imageNameOrPath];
    }
    return image;
}

+ (UIImage *)blurImageWithImage:(UIImage *)image
{

    return  [self boxblurImage:image withBlurNumber:2.0f];
}

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    //    if (blur < 0.f || blur > 1.f) {
    //        blur = 0.5f;
    //    }
    
    if (blur < 0.0f) {
        blur = 0.5f;
    }
    if (!image) {
        return nil;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    @try {
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        free(pixelBuffer);
        CFRelease(inBitmapData);
        CGImageRelease(imageRef);
    } @catch (NSException *exception) {
        NSLog(@"=@catch=exception.userInfo=%@",exception.userInfo);
    } @finally {
        NSLog(@"=图片处理==@finally==");
    }
    //    //clean up
    //    CGContextRelease(ctx);
    //    CGColorSpaceRelease(colorSpace);
    //    free(pixelBuffer);
    //    CFRelease(inBitmapData);
    //    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
