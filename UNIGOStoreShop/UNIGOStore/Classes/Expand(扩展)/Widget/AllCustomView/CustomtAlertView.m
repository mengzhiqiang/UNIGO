//
//  CustomtAlertView.m
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/14.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import "CustomtAlertView.h"

@interface CustomtAlertView ()
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *CreenView;

@end

@implementation CustomtAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CustomtAlertView*)sharedView {
    static dispatch_once_t once;
    static CustomtAlertView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
//        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}



- (UILabel *)stringLabel {
    if (_stringLabel == nil) {
        _stringLabel = [[UILabel alloc] init];
//        _stringLabel.backgroundColor = [UIColor redColor];
        _stringLabel.adjustsFontSizeToFitWidth = YES;
        _stringLabel.textAlignment = NSTextAlignmentCenter;
        _stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _stringLabel.textColor = [UIColor whiteColor];
        _stringLabel.font = [UIFont systemFontOfSize:16 weight:16];
        _stringLabel.numberOfLines = 0;
    }

    
    return _stringLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil)
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_CreenView.width-55)/2, 23, 55, 55)];
    _imageView.opaque =YES;
    
    return _imageView;
}

-(void)settingSuccessWith:(NSString*)title{
    
    if (!_CreenView) {
        _CreenView =[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-135)/2,SCREEN_HEIGHT/2-100, 135 , 135)];
        _CreenView.backgroundColor =[UIColor HexString:@"728095"];
        [_CreenView draCirlywithColor:nil andRadius:10];
    }
    
    _CreenView.frame = CGRectMake((SCREEN_WIDTH-135)/2,SCREEN_HEIGHT/2-100, 135 , 135);
    [self.imageView setImage:[UIImage imageNamed:@"volum_image_changeBig"]];
    self.stringLabel.text = title;

    if ([title isEqualToString:@"音量已增大"]) {
        [self.imageView setImage:[UIImage imageNamed:@"volum_image_changeBig"]];
    }else if ([title isEqualToString:@"音量已减小"]){
        [self.imageView setImage:[UIImage imageNamed:@"volum_image_changeSmall"]];
    }
    
    _stringLabel.frame = CGRectMake(0, self.imageView.bottom+9, _CreenView.width, 20);
    
    [_CreenView addSubview:_imageView];
    [_CreenView addSubview:_stringLabel];
    self.hidden = NO;
    [self.overlayView addSubview:_CreenView];
    [self addSubview:_overlayView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];

}

-(void)settingFailWith:(NSString*)title{
    
    if (!_CreenView) {
        _CreenView =[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-136)/2,SCREEN_HEIGHT/2-80, 136 , 63)];
        _CreenView.backgroundColor =[UIColor HexString:@"728095"];
        [_CreenView draCirlywithColor:nil andRadius:10];
    }
    if (_imageView) {
        [_imageView removeFromSuperview];
    }
    
    _CreenView.frame = CGRectMake((SCREEN_WIDTH-136)/2,SCREEN_HEIGHT/2-80, 136 , 63);
    self.stringLabel.text = title;
    _stringLabel.frame = CGRectMake(0, 23, _CreenView.width, 20);
    [_CreenView addSubview:_stringLabel];
    self.hidden = NO;
    [self.overlayView addSubview:_CreenView];
    [self addSubview:_overlayView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    
}



- (void)delayMethod{
    
    for (UIView*view in [[[UIApplication sharedApplication] keyWindow] subviews]) {
        if ([view isKindOfClass:[CustomtAlertView class]]) {
            view.hidden = YES;
        }
    }

}


@end
