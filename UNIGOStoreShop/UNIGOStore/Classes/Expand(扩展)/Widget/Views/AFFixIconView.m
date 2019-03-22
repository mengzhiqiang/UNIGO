//
//  AFFixIconView.m
//  ALPHA
//
//  Created by teelab1 on 14-6-11.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import "AFFixIconView.h"
#import "UIImage+Extension.h"

@implementation AFFixIconView{
    float imageWidth;
    float imageHeight;
    CGSize imageSize;
    UIView *backgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.frame = [[UIApplication sharedApplication] keyWindow].frame;
        self.backgroundColor = [UIColor blackColor];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, 280)];
        self.iconImageView.image = image;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 124, 280, 280)];
        
        float imageW = image.size.width;
        float imageH = image.size.height;
        float percent = imageW / imageH;
        if (imageW > imageH) {
            imageHeight = 280;
            imageWidth = 280 * percent;
            self.iconImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.scrollView.contentOffset = CGPointMake(-(imageWidth - 280)/2, 0);
        }else{
            imageWidth = 280;
            imageHeight = 280 / percent;
            self.iconImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.scrollView.contentOffset = CGPointMake(0, -(imageHeight - 280)/2);
        }
        
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = self.iconImageView.frame.size;
        self.scrollView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.scrollView.layer.borderWidth = 1;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 5;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.clearsContextBeforeDrawing = NO;
        self.scrollView.delegate = self;
        [self.scrollView addSubview:_iconImageView];
        
        [self addSubview:_scrollView];
        
        //上面背景
        UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 124)];
        viewOne.backgroundColor = [UIColor blackColor];
        viewOne.alpha = 0.6;
        
        //返回按钮
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 17, 17)];
        [_backBtn setTitle:@"《" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        //提示label: 移动和缩放
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(117.5, 20, 85, 17)];
        tipsLabel.text = @"移动和缩放";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont boldSystemFontOfSize:17];
        
        //底部透明背景
        UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 444, 320, 124)];
        viewTwo.backgroundColor = [UIColor blackColor];
        viewTwo.alpha = 0.6;
        
        //底部黄色背景
        UIView *buttonBg = [[UIView alloc] initWithFrame:CGRectMake(0, 524, 320, 44)];
        buttonBg.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:0 alpha:1];
        
        //确认按钮
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((320-48)/2, 533, 48, 30)];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1]];
        _confirmBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 5.0;
        _confirmBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _confirmBtn.layer.shouldRasterize = YES;
        _confirmBtn.clipsToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmIconM) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:viewOne];
        [self addSubview:viewTwo];
        [self addSubview:_backBtn];
        [self addSubview:tipsLabel];
        [self addSubview:buttonBg];
        [self addSubview:_confirmBtn];
    }
    
    return self;
}

-(void)confirmIconM{
    
    CGImageRef imageRef = [UIImage resizeImage:_iconImageView.image andSize:_scrollView.contentSize].CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y, 280, 280));
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    
    [self.delegate getSubImage:retImg];
}

-(id)initWithImage:(UIImage *)image andImageSize:(CGSize)size{
    self = [super init];
    if (self) {
        imageSize = size;
        self.frame = [[UIApplication sharedApplication] keyWindow].frame;
        self.backgroundColor = [UIColor blackColor];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.iconImageView.image = image;
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - size.height)/2, size.width, size.height)];
        backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:backgroundView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        float imageW = image.size.width;
        float imageH = image.size.height;
        float percent = imageW / imageH;
        if (imageW > imageH) {
            imageHeight = size.height;
            imageWidth = imageHeight * percent;
            self.iconImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.scrollView.contentOffset = CGPointMake((imageWidth - size.width)/2, 0);
        }else{
            imageWidth = size.width;
            imageHeight = imageWidth / percent;
            self.iconImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.scrollView.contentOffset = CGPointMake(0, (imageHeight - size.height)/2);
        }

        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.contentSize = self.iconImageView.frame.size;
        self.scrollView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.scrollView.layer.borderWidth = 1;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 5;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.clearsContextBeforeDrawing = NO;
        self.scrollView.delegate = self;
        [self.scrollView addSubview:_iconImageView];
        
        
        [backgroundView addSubview:_scrollView];
        
        

        
        //上面背景
        UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - size.height)/2)];
        viewOne.backgroundColor = [UIColor whiteColor];
        viewOne.alpha = 0.6;
        
        //导航栏
        UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        navView.backgroundColor = [UIColor HexString:@"5890ff"];
        navView.backgroundColor = [UIColor clearColor];
        //返回按钮
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-44-10, 50, 44)];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //提示label: 移动和缩放
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
        tipsLabel.text = @"移动和缩放";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont boldSystemFontOfSize:17];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        
//        [navView addSubview:tipsLabel];
//        [navView addSubview:_backBtn];
        
        //底部透明背景
        UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
        viewTwo.backgroundColor = [UIColor darkGrayColor];
        viewTwo.alpha = 0.6;
        
        //底部黄色背景
        UIView *buttonBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        buttonBg.backgroundColor = [UIColor HexString:@"5890ff"];
        buttonBg.backgroundColor = [UIColor clearColor];

        //确认按钮
        _confirmBtn = [[UIButton alloc] initWithFrame:buttonBg.frame];
        _confirmBtn.frame = CGRectMake(SCREEN_WIDTH-50-10, SCREEN_HEIGHT-44-10, 50, 44);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_confirmBtn addTarget:self action:@selector(confirmIcon) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [self addSubview:viewOne];
        [self addSubview:viewTwo];
        [self addSubview:buttonBg];
        [self addSubview:_confirmBtn];
        [self addSubview:_backBtn];
        
    }
    
    return self;
}

-(void)confirmIcon
{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);

    CGContextRef con = UIGraphicsGetCurrentContext();
    
    _scrollView.layer.borderWidth = 0;
    
    [backgroundView.layer renderInContext:con];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    [self.delegate getSubImage:image];

}

-(UIImage*) OriginImage:(UIImage *)image
{
    
    CGSize size=image.size;
    float  p=3.0;
    UIGraphicsBeginImageContext(CGSizeMake(size.width/p,size.height/p));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width/p, size.height/p)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma  mark - scrollView delegate method
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _iconImageView;
}
-(void)draCirly:(UIView*)view withColor:(UIColor*)color{
    
    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = view.width/2;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [color CGColor];
    
}

//-(UIImage *)getSubImage{
//    CGRect squareFrame = self.scrollView.frame;
//    CGFloat scaleRatio = self.iconImageView.size.width / imageWidth;
//    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
//    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
//    CGFloat w = squareFrame.size.width / scaleRatio;
//    CGFloat h = squareFrame.size.width / scaleRatio;
//    if (self.latestFrame.size.width < self.cropFrame.size.width) {
//        CGFloat newW = self.originalImage.size.width;
//        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
//        x = 0; y = y + (h - newH) / 2;
//        w = newH; h = newH;
//    }
//    if (self.latestFrame.size.height < self.cropFrame.size.height) {
//        CGFloat newH = self.originalImage.size.height;
//        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
//        x = x + (w - newW) / 2; y = 0;
//        w = newH; h = newH;
//    }
//    CGRect myImageRect = CGRectMake(x, y, w, h);
//    CGImageRef imageRef = self.originalImage.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
//    CGSize size;
//    size.width = myImageRect.size.width;
//    size.height = myImageRect.size.height;
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, myImageRect, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    return smallImage;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
