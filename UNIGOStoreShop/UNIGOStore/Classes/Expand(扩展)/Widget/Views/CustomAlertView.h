//
//  CustomAlertView.h
//  ALPHA
//
//  Created by teelab2 on 15/1/12.
//  Copyright (c) 2015年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCGIFImageView.h"
@interface CustomAlertView : UIView


@property (retain, nonatomic)  UIImageView* gifImageView;
@property (retain, nonatomic)  UILabel* titleLabel;

@property (retain, nonatomic)  UIActivityIndicatorView * activityView ;


+ (id)shareCustom;
-(void)hiddenAlertView;

-(void)setGitImageFrame:(int)height;

-(void)backGrondColor:(UIColor*)col;

@end
