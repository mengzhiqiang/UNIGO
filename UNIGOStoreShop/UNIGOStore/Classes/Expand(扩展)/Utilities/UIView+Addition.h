//
//  UIView+Addition.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/1.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

/****************************************系统版本*******************************************/
#define iOS7_OR_LATER ( ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) ? YES : NO )

//#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
//#define isPAD_or_IPONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
//#define DEVICE_IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
//#define iPhone6plus ([[UIScreen mainScreen] bounds].size.height == 736)

#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SystemNavbarHeight                  self.navigationController.navigationBar.frame.size.height

//#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         (IOSVersion >= 7.0)

#define NavBarHeight                        (IsiOS7Later ? (SystemNavbarHeight + StatusBarHeight) : SystemNavbarHeight)

/* present过来高度变化 */
#define PresentNavBarHeight                        (IsiOS7Later ? (44 + StatusBarHeight) : 44)


#define TabBatHeight                        self.tabBarController.tabBar.frame.size.height
#define NavTopOffset                        (IsiOS7Later ?  StatusBarHeight : 0)

typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

@interface UIView (Addition)

/**
 
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (id)subviewWithTag:(NSInteger)tag;

- (UIViewController*)viewController;

- (void)setMenuActionWithBlock:(void (^)(void))block;

- (void)moveOrigin:(CGPoint)origin;
- (void)moveX:(CGFloat)x;
- (void)moveY:(CGFloat)y;

- (void)toLeft;
- (void)toTop;
- (void)toRight;
- (void)toBottom;

- (void)autoExpand;
- (void)fitInSize: (CGSize) aSize;



- (UIView*)subviewAtIndex:(NSInteger)index;
- (UIView*)prevView;
- (UIView*)nextView;
- (NSInteger)indexOfSubview:(UIView*)subview;
- (NSInteger)allSubviewsCount;

- (void)removeAllSubviews;

- (void)fadeInAnimationWithDuration:(NSTimeInterval)duration
                         completion:(void (^)(BOOL))completion;
- (void)fadeOutAnimationWithDuration:(NSTimeInterval)duration
                          completion:(void (^)(BOOL))completion;

- (UIImage*)capturedImageWithSize:(CGSize)size;


/*
 设置圆角
 */
-(void)draCirlywithColor:(UIColor*)color andRadius:(float)Radius;


/**
 设置view指定位置的边框
 
 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
+ (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType ;

@end
