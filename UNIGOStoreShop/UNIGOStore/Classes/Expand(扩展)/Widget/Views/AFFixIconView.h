//
//  AFFixIconView.h
//  ALPHA
//
//  Created by teelab1 on 14-6-11.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFFixIconViewDelegate <NSObject>

-(void)getSubImage:(UIImage *)image;

@end

@interface AFFixIconView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) NSObject<AFFixIconViewDelegate> *delegate;

-(id)initWithImage:(UIImage *)image;
-(id)initWithImage:(UIImage *)image andImageSize:(CGSize)size;     ////图片 大小

@end
