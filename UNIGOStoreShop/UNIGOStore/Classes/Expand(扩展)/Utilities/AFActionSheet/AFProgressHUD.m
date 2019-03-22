//
//  AFProgressHUD.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFProgressHUD.h"
#import "NSString+Regular.h"
#import "AFToolTipOfHead.h"
#import "AFAlertViewHelper.h"

@implementation AFCoverView

#pragma mark - life init setup

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCommonInit];
    }
    return self;
}

#pragma mark - commont Init

- (void)setupCommonInit
{
    self.backgroundColor = [UIColor clearColor];
    [self setupSubviews];
}

#pragma mark -
#pragma mark - Setup UI createSubviews

- (void)setupSubviews
{
    
}

@end


static CGFloat const ProgressMaxWidth = 200;
static CGFloat const ProgressMinWidth = 100;


//static CGFloat const ProgressTipMaxWidth = 240;

@interface AFProgressHUD()
{
    
}
@property (nonatomic, assign) BOOL rotate;
@property (nonatomic, copy) NSString *message;

//@property (nonatomic, strong) UIImageView *rotateImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation AFProgressHUD

#pragma mark - life init setup

- (instancetype)initWithView:(UIView *)view rotate:(BOOL)rotate
{
    self = [super init];
    if (self) {
        [self setupCommonInitWithView:view rotate:rotate];
    }
    return self;
}

#pragma mark - commont Init
- (void)setupCommonInitWithView:(UIView *)view rotate:(BOOL)rotate
{
    self.rotate = rotate;
    if (rotate) {
        self.frame = CGRectMake(0, 0, 100.0f, 100.0f);
    }else{
        self.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    }
    self.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1 alpha:0.8f];
    self.center = view.center;
    self.alpha = 0.0f;
    self.layer.masksToBounds = YES;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView*naviEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    naviEffectView.frame = self.bounds;
    naviEffectView.userInteractionEnabled = YES;
    [self addSubview:naviEffectView];
    
    if (self.rotate) {
        self.layer.cornerRadius = 6.0f;
        [self registerAppDelegateNotifications];
    }
    else {
//        self.layer.cornerRadius = self.height / 2.0f;
        self.layer.cornerRadius = 6.0f;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self setupSubviews];
}

#pragma mark - Create Subviews
- (void)setupSubviews
{
    if (self.rotate) {
        [self addSubview:self.activityIndicatorView];
    }
    [self addSubview:self.messageLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _messageLabel.text = _message;
    if (self.rotate) {
        _activityIndicatorView.frame = CGRectMake((self.width-40.0)/2, 14, 40.0, 40.0);
        if (_message && ![_message isEqualToString:@""]) {
            CGFloat width = [_message widthOfStringFont:_messageLabel.font];
            if (width < ProgressMaxWidth) {
                if (width<ProgressMinWidth) {
                    self.width = ProgressMinWidth ;
                    _messageLabel.frame = CGRectMake(0,_activityIndicatorView.bottom+12, ProgressMinWidth, 30);
                }else{
                    self.width = width + 40;
                    _messageLabel.frame = CGRectMake(20,_activityIndicatorView.bottom+12, width, 30);
                }
                
            }
            else {
                self.width = ProgressMaxWidth;
                _messageLabel.frame = CGRectMake(5, _activityIndicatorView.bottom+12, ProgressMaxWidth-10, 30);
            }
            self.left = (self.superview.width - self.width) / 2.0f;
        }
        else {
            _activityIndicatorView.left = (self.width - _activityIndicatorView.width) / 2.0f;
            _activityIndicatorView.top = (self.height - _activityIndicatorView.height) / 2.0f;
        }
        [self addRotateAnimated];
        _activityIndicatorView.frame = CGRectMake((self.width-40.0)/2, 14, 40.0, 40.0);

    }
    else {
        if (_message && ![_message isEqualToString:@""]) {
            CGFloat width = [_message widthOfStringFont:_messageLabel.font];
//            CGSize size = [_message sizeOfStringFont:_messageLabel.font];
            
            if (width - 40 > SCREEN_WIDTH - 40) {
                 self.width = SCREEN_WIDTH - 40;
            }
            else {
                self.width = width + 40;
            }
            
            self.left = (self.superview.width - self.width) / 2.0f;
            self.top = (self.superview.height - self.height) / 2.0f;
//            if (SCREEN_WIDTH > ScreenHeight) {
//                self.top = (self.superview.height - self.height) / 2.0f;
//            }
//            else {
//                self.top = self.superview.height - 215;
//            }
            _messageLabel.frame = CGRectMake(20, (self.height - 30) / 2.0f, self.width - 40, 30);
        }
    }
    

}

- (void)addRotateAnimated
{
     [self.activityIndicatorView startAnimating];
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = HUGE_VALF;
//    [_rotateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark Notification

- (void)registerAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}
//进如后台
- (void)appDidEnterBackground:(NSNotification*)notification
{
//    [self.rotateImageView.layer removeAnimationForKey:@"rotationAnimation"];
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
}

//进入前台
- (void)appWillEnterForeground:(NSNotification*)notification
{
    [self addRotateAnimated];
}

- (void)orientationChange:(NSNotification *)notification
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
+ (instancetype)showMessageAddedToView:(UIView *)toView animated:(BOOL)animated rotate:(BOOL)rotate
{
    AFProgressHUD *hud = [[AFProgressHUD alloc] initWithView:toView rotate:rotate];
    
    if (rotate) {
        [self addCoverViewToView:toView];
    }
    [toView addSubview:hud];
    [hud showWithAnimated:animated];
    return hud;
}

+ (void)addCoverViewToView:(UIView *)toView
{
    AFCoverView *coverView = [[AFCoverView alloc] initWithFrame:CGRectMake(0, 64.0f, toView.width, toView.height - 64.0f)];
    [toView addSubview:coverView];
}

#pragma mark - Show Loading HUD
+ (instancetype)showMessag:(NSString *)message
{
    return [self showMessag:message toView:nil];
}

+ (instancetype)showMessag:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
        //view = [[[UIApplication sharedApplication] delegate] window];
    }
    
    AFProgressHUD *hud = [AFProgressHUD showMessageAddedToView:view animated:YES rotate:YES];
    hud.message = message;
    return hud;
}


#pragma mark - Show Tip Message

+ (instancetype)showTipMessage:(NSString *)message
{
    return [self showTipMessage:message toView:nil];
}

+ (instancetype)showTipMessage:(NSString *)message delay:(NSTimeInterval)delay
{
    return [self showTipMessage:message toView:nil delay:delay];
}

+ (instancetype)showTipMessage:(NSString *)message toView:(UIView *)view
{
    return [self showTipMessage:message toView:view delay:1.5];
}

+ (instancetype)showTipMessage:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
        //view = [[[UIApplication sharedApplication] delegate] window];
    }
    
//    [self hideForView:view animated:YES];
    AFProgressHUD *hud = [AFProgressHUD showMessageAddedToView:view animated:YES rotate:NO];
    hud.message = message;
    [hud hideWithAnimated:YES afterDelay:delay];
    return hud;
}

+ (BOOL)hideTipForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
        //view = [[[UIApplication sharedApplication] delegate] window];
    }
    
    AFProgressHUD *hub = [self hudForView:view];
    if (hub) {
        [hub hide:YES];
        return YES;
    }
    return NO;
}

- (void)hideWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hideDelayedWithAnimation:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayedWithAnimation:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

#pragma mark - Show And Hide Animated
- (void)showWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hide:(BOOL)animated
{
    if (self.rotate) {
//        [self.rotateImageView.layer removeAnimationForKey:@"rotationAnimation"];
        if ([self.activityIndicatorView isAnimating]) {
            [self.activityIndicatorView stopAnimating];
        }
    }
    // Fade out
    if (animated) {
        [UIView animateWithDuration:0.30 animations:^{
            self.alpha = 0.02f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else {
        self.alpha = 0.0f;
        [self removeFromSuperview];
    }
}

#pragma mark - Hide Loading HUD

+ (BOOL)hideForAnimated:(BOOL)animated
{
    return [self hideForView:nil animated:animated];
}

+ (BOOL)hideForView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
        //view = [[[UIApplication sharedApplication] delegate] window];
    }
    AFCoverView *cover = [self coverViewForView:view];
    if (cover) {
        [cover removeFromSuperview];
    }
    AFProgressHUD *hub = [self hudForView:view];
    if (hub) {
        [hub hide:animated];
        return YES;
    }
    return NO;
}

+ (instancetype)hudForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (AFProgressHUD *)subview;
        }
    }
    return nil;
}

+ (AFCoverView *)coverViewForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[AFCoverView class]]) {
            return (AFCoverView *)subview;
        }
    }
    return nil;
}

#pragma mark - Hide All Hud 
+ (NSUInteger)hideAllHUDForAnimated:(BOOL)animated
{
    return [self hideAllHUDForView:nil animated:YES];
}

+ (NSUInteger)hideAllHUDForView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    NSArray *covers = [self allCoverViewForView:view];
    for (AFCoverView *cover in covers) {
        [cover removeFromSuperview];
    }
    
    NSArray *huds = [self allHUDForView:view];
    for (AFProgressHUD *hud in huds) {
        [hud hide:animated];
    }
    return [huds count];
}

+ (NSArray *)allHUDForView:(UIView *)view
{
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

+ (NSArray *)allCoverViewForView:(UIView *)view
{
    NSMutableArray *covers = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[AFCoverView class]]) {
            [covers addObject:subview];
        }
    }
    return [NSArray arrayWithArray:covers];;
}

#pragma mark - Setters
- (void)setMessage:(NSString *)message
{
    _message = message;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Lazy Init

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        _activityIndicatorView.backgroundColor=[UIColor redColor];
        _activityIndicatorView.color = [UIColor HexString:@"656565"];
    }
    return _activityIndicatorView;
}


- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = [UIFont boldSystemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor colorWithHexValue:0x464646];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}


/**
 *  显示提示语 新增 Window
 *
 *  @param message 提示语
 *
 *  @return 返回WU
 */
+ (void)showUpMessage:(NSString *)message{
    
    [[AFToolTipOfHead sharedInstance ]addViewOfHeadWithTitle:message BackColor:nil];
}

/**
 *  显示提示语 新增 Window
 *
 *  @param message 提示语  color 背景颜色
 *
 *  @return 返回WU
 */
+ (void)showUpMessage:(NSString *)message  backColor:(UIColor*)color{
    [[AFToolTipOfHead sharedInstance ]addViewOfHeadWithTitle:message BackColor:color];
}

/**
 *  显示提示语 新增 Window
 *
 *  @param message 中间弹框
 *
 *  @return 返回WU
 */
+ (void)showAleartMessage:(NSString *)message{
    
    [AFAlertViewHelper  alertViewWithTitle:@"" message: message delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
        
    }];
    
}
+ (void)showAleartTitle:(NSString *)title{
    
    [AFAlertViewHelper  alertViewWithTitle:title message: @"" delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
        
    }];
    
}
+ (void)showAleartTitle:(NSString *)title andMessage:(NSString*)message{
    [AFAlertViewHelper  alertViewWithTitle:title message: message delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
        
    }];

}
@end
