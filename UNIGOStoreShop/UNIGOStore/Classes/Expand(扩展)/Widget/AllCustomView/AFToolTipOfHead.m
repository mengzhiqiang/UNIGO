//
//  AFToolTipOfHead.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 17/4/12.
//  Copyright © 2017年 Auric. All rights reserved.
//

#import "AFToolTipOfHead.h"


static AFToolTipOfHead *sharedInstance = nil;

@interface AFToolTipOfHead()

@property (nonatomic, strong) UIView *HeaderView;
@property (nonatomic, strong) UILabel *HeaderLabel;
@property (nonatomic, strong) UIButton *HiddenButton;

@end

@implementation AFToolTipOfHead

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AFToolTipOfHead alloc] init];
    });
    return sharedInstance;
}

-(void)addViewOfHeadWithTitle:(NSString*)title BackColor:(UIColor*)color{
    
    if (color) {
      self.HeaderView.backgroundColor = color;
    }else{
        self.HeaderView.backgroundColor = [UIColor HexString:@"fc4349"];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//取消全部 延迟方法。

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.HeaderView.frame = CGRectMake(0, -SCREEN_top, SCREEN_WIDTH, SCREEN_top);
    self.HeaderLabel.text = title;
    [self.HeaderView addSubview:self.HiddenButton];
    window.windowLevel = UIWindowLevelAlert ;
    [window addSubview:self.HeaderView];
    
    if (isPAD_or_IPONE4 ||iPhone5) {
        self.HeaderLabel.font =[UIFont systemFontOfSize:12];
    }
    
//    CGSize titleSize =[UIHelper makeNewRectView:_HeaderLabel oldSize:CGSizeMake(SCREEN_WIDTH-40, _HeaderLabel.height)];
//    _HeaderLabel.width = titleSize.width;
//    _HiddenButton.left = _HeaderLabel.right+0;
    
//    [[UIApplication sharedApplication].keyWindow addSubview:_HeaderView];
    CGFloat headTop = 0 ;
//    if (iPhoneX) {
//        headTop = 20 ;
//    }
    [UIView animateWithDuration:0.3 animations:^{
        if (!IsPortrait && iPhoneX) {
            _HeaderView.frame = CGRectMake(0, headTop-24, SCREEN_WIDTH, SCREEN_top);
        }else{
            _HeaderView.frame = CGRectMake(0, headTop, SCREEN_WIDTH, SCREEN_top);
        }
    }];
    
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:2.0f];
    
}

-(UIView*)HeaderView{

    if (!_HeaderView) {
        _HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_top)];
        _HeaderView.backgroundColor = [UIColor HexString:@"fc4349"];
    }
//    _HeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_top);
    return _HeaderView ;
}

-(UILabel*)HeaderLabel{
    
    if (!_HeaderLabel) {
        _HeaderLabel = [[UILabel alloc]init];
        _HeaderLabel.frame = CGRectMake(46+4, 20, SCREEN_WIDTH-46*2-8, 24);
        _HeaderLabel.textAlignment = NSTextAlignmentCenter ;
        _HeaderLabel.textColor = [UIColor whiteColor];
        _HeaderLabel.font = [UIFont boldSystemFontOfSize:14];
        _HeaderLabel.numberOfLines = 0 ;
        
        [_HeaderView addSubview:_HeaderLabel];
    }
    _HeaderLabel.frame = CGRectMake(36+4, 20, SCREEN_WIDTH-36*2-8, 24);

    if (SCREEN_WIDTH<=320) {
        _HeaderLabel.font = [UIFont boldSystemFontOfSize:12];
        _HeaderLabel.frame = CGRectMake(16, 20, SCREEN_WIDTH-6*2-8, 24);
//        _HeaderLabel.textAlignment = NSTextAlignmentLeft ;
    }
    if (iPhoneX) {
        _HeaderLabel.top = 24+20;
    }
    return _HeaderLabel;
}

-(UIButton*)HiddenButton{

    if (!_HiddenButton) {
        _HiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_HiddenButton setBackgroundImage:[UIImage imageNamed:@"icon__notification_close"] forState:UIControlStateNormal];
        [_HiddenButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        [_HeaderView addSubview:_HiddenButton];
//        _HiddenButton.backgroundColor = [UIColor redColor];
    }
    _HiddenButton.frame = CGRectMake(SCREEN_WIDTH-30-15, 17, 30, 30);
    if (iPhoneX) {
        _HiddenButton.top = 24+17;
    }
    return  _HiddenButton;
}

-(void)hiddenView{

    [UIView animateWithDuration:0.5 animations:^{
        _HeaderView.frame = CGRectMake(0, -SCREEN_top, SCREEN_WIDTH, SCREEN_top);
    }];
    
    [self performSelector:@selector(showStateBar) withObject:nil afterDelay:0.3];
}

-(void)showStateBar{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.windowLevel = UIWindowLevelNormal ;
}

@end
