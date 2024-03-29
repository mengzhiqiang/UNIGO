//
//  Created by 刘超 on 15/4/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LCActionSheet.h"
//#import "UIImage+BoxBlur.h"

// 按钮高度
#define BUTTON_H 57.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define LC_ACTION_SHEET_TITLE_FONT  [UIFont systemFontOfSize:20.0f]

#define LC_DEFAULT_ANIMATION_DURATION 0.3f

#define LC_DEFAULT_BACKGROUND_OPACITY 0.2f

@interface LCActionSheet ()

/** 所有按钮 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

/** 暗黑色的view */
@property (nonatomic, strong) UIView *darkView;

/** 所有按钮的底部view */
@property (nonatomic, strong) UIVisualEffectView *bottomView;

/** 代理 */
@property (nonatomic, weak) id<LCActionSheetDelegate> delegate;

@property (nonatomic, strong) UIWindow *backWindow;
/**  按钮颜色（新增） */
@property (nonatomic, strong) UIColor *btn_color;



@end

@implementation LCActionSheet

#pragma mark - getter

- (NSString *)cancelText
{
    if (!_cancelText) {
        _cancelText = @"取消";
    }
    
    return _cancelText;
}

- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = LC_ACTION_SHEET_TITLE_FONT;
    }
    
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    
    return _textColor;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = LC_DEFAULT_ANIMATION_DURATION;
    }
    
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = LC_DEFAULT_BACKGROUND_OPACITY;
    }
    
    return _backgroundOpacity;
}

#pragma mark - methods
+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles redButtonIndex:(NSInteger)redButtonIndex delegate:(id<LCActionSheetDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles redButtonIndex:redButtonIndex delegate:delegate];
}

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles redButtonIndex:(NSInteger)redButtonIndex clicked:(LCActionSheetBlock)clicked {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles redButtonIndex:redButtonIndex clicked:clicked];
}
+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles ButtonIndex:(NSInteger)buttonIndex Color:(UIColor *)color clicked:(LCActionSheetBlock)clicked {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles ButtonIndex:buttonIndex Color:color clicked:clicked];
}
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                     delegate:(id<LCActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                      clicked:(LCActionSheetBlock)clicked {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.clickedBlock = clicked;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               ButtonIndex:(NSInteger)buttonIndex
                        Color:(UIColor *)color
                      clicked:(LCActionSheetBlock)clicked {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = buttonIndex;
        self.btn_color = color;
        self.clickedBlock = clicked;
    }
    
    return self;
}

- (void)setupMainView {
    
////    // 暗黑色的view
    UIView *darkView = [[UIView alloc] init];
    [darkView setAlpha:0];
    [darkView setUserInteractionEnabled:NO];
    [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
//    [darkView setBackgroundColor:LCColor(46, 49, 50)];
    [darkView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:darkView];
    _darkView = darkView;
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
//    [darkView addGestureRecognizer:tap];
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    //设置模糊透明度
    effectView.alpha = 1.f;
    _bottomView = effectView;
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [darkView addGestureRecognizer:tap];
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *seleteBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect2];
    seleteBgView.alpha = 0.1f;
    //添加到要有毛玻璃特效的控件中
    seleteBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
    UIImage *bottomBgImage = [self getImageFromView:seleteBgView];
    
    seleteBgView.alpha = 0.3f;
    UIImage *lineBgImage = [self getImageFromView:seleteBgView];
    
    if (self.title) {
        
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > SCREEN_SIZE.width - 30.0f) {
            vSpace = 15.0f;
        }
        
        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor clearColor];
        titleBgView.frame = CGRectMake(0, -vSpace, SCREEN_SIZE.width, BUTTON_H + vSpace);
        [_bottomView.contentView addSubview:titleBgView];
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor yellowColor];
        [label setText:self.title];
        [label setNumberOfLines:2.0f];
        [label setTextColor:LCColor(111, 111, 111)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
//        [label setBackgroundColor:[UIColor clearColor]];
        [label setFrame:CGRectMake(15.0f, 0, SCREEN_SIZE.width - 30.0f, titleBgView.frame.size.height)];

        [titleBgView addSubview:label];
    }
    
    NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"LCActionSheet" ofType:@"bundle"];
    
    if (self.buttonTitles.count) {
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            // 所有按钮
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            [[btn titleLabel] setFont:self.textFont];
            UIColor *titleColor = nil;
            if (i == self.redButtonIndex) {
                
                titleColor = LCColor(255, 10, 10);

                if (_btn_color) {
                    titleColor = _btn_color;
                }
                
            } else {
                
                titleColor = self.textColor ;
            }
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            
//            NSString *linePath = [bundlePath stringByAppendingPathComponent:@"bgImage_HL@2x.png"];
//            UIImage *bgImage = [UIImage imageWithContentsOfFile:linePath];
//            
            [btn setBackgroundImage:bottomBgImage forState:UIControlStateHighlighted];
            
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnY = BUTTON_H * (i + (self.title ? 1 : 0));
            [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
            [_bottomView.contentView addSubview:btn];
        }
        
        for (int i = 0; i < self.buttonTitles.count + 1; i++) {
            
            NSString *linePath = [bundlePath stringByAppendingPathComponent:@"cellLine@2x.png"];
            UIImage *lineImage = [UIImage imageWithContentsOfFile:linePath];
            
            // 所有线条
            UIImageView *line = [[UIImageView alloc] init];
            line.clipsToBounds = YES;
            [line setImage:lineImage];
            [line setContentMode:UIViewContentModeTop];
            CGFloat lineY = (i + (self.title ? 1 : 0)) * BUTTON_H;
            [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 0.5)];
//            line.backgroundColor=[UIColor colorWithHexString:@"e5e5e5"];
            line.backgroundColor=[UIColor clearColor];
            [_bottomView.contentView addSubview:line];
            if (i == self.buttonTitles.count) {
                [line setImage:lineBgImage];
                
                [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width,5)];
            }
        }
    }
    
    NSString *linePath = [bundlePath stringByAppendingPathComponent:@"bgImage_HL@2x.png"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:linePath];
    
    // 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTag:self.buttonTitles.count];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
    [[cancelBtn titleLabel] setFont:self.textFont];
    [cancelBtn setTitleColor:self.textColor forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnY = BUTTON_H * (self.buttonTitles.count + (self.title ? 1 : 0)) + 5.0f;
    [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
    [_bottomView.contentView addSubview:cancelBtn];
    
    CGFloat bottomH = (self.title ? BUTTON_H : 0) + BUTTON_H * self.buttonTitles.count + BUTTON_H + 5.0f;
    [_bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
    
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
    
    if (self.clickedBlock) {
        
        self.clickedBlock(btn.tag);
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
  
    } completion:^(BOOL finished) {
        
        if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            
            [_delegate actionSheet:self didClickedButtonAtIndex:self.buttonTitles.count];
        }
        
        if (self.clickedBlock) {
            
            __weak typeof(self) weakSelf = self;
            self.clickedBlock(weakSelf.buttonTitles.count);
        }
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)show {
    [self setupMainView];
    self.backWindow.hidden = NO;
    
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:self.backgroundOpacity];
        [_darkView setUserInteractionEnabled:YES];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
     
        
    } completion:nil];
}
-(void)showWithColor:(UIColor *)color{
    
    _btn_color =color;
    [self show];
}

- (void)addButtonTitle:(NSString *)button
{
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    
    [_buttonTitles addObject:button];
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
