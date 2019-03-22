//
//  AFProgressHUD.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFCoverView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@end

@interface AFProgressHUD : UIView
{
    
}

//隐藏loading
- (void)hide:(BOOL)animated;

/**
 *  显示加载loading
 *
 *  @param message  提示语
 *  @param animated 是否需要动画
 *
 *  @return 返回HUD对象
 */
+ (instancetype)showMessag:(NSString *)message;

/**
 *  隐藏加载loading
 *
 *  @param animated 是否动画
 *
 *  @return 返回是否隐藏成功
 */
+ (BOOL)hideForAnimated:(BOOL)animated;


/**
 *  显示加载loading
 *
 *  @param message  提示语
 *  @param view     加载的父视图
 *  @param animated 是否动画
 *
 *  @return 返回HUD对象
 */
+ (instancetype)showMessag:(NSString *)message toView:(UIView *)view;

/**
 *  隐藏加载loading
 *
 *  @param view     加载的父视图
 *  @param animated 是否动画
 *
 *  @return 返回是否隐藏成功
 */
+ (BOOL)hideForView:(UIView *)view animated:(BOOL)animated;

/***************************************************************************************************/

#pragma mark - Hide All HUD

+ (NSUInteger)hideAllHUDForAnimated:(BOOL)animated;

+ (NSUInteger)hideAllHUDForView:(UIView *)view animated:(BOOL)animated;


/***************************************************************************************************/

#pragma mark - Show Tip Message

/**
 *  显示提示语
 *
 *  @param message 提示语
 *
 *  @return 返回HUD对象
 */
+ (instancetype)showTipMessage:(NSString *)message;

+ (instancetype)showTipMessage:(NSString *)message delay:(NSTimeInterval)delay;


+ (instancetype)showTipMessage:(NSString *)message toView:(UIView *)view;

+ (instancetype)showTipMessage:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)delay;

//隐藏
+ (BOOL)hideTipForView:(UIView *)view;



/**
 *  显示提示语 新增 Window
 *
 *  @param message 提示语
 *
 *  @return 返回WU
 */
+ (void)showUpMessage:(NSString *)message ;

/**
 *  显示提示语 新增 Window
 *
 *  @param message 提示语  color 背景颜色
 *
 *  @return 返回WU
 */
+ (void)showUpMessage:(NSString *)message  backColor:(UIColor*)color;

/**
 *  显示提示语 新增 Window
 *
 *  @param message 中间弹框
 *
 *  @return 返回WU
 */
+ (void)showAleartMessage:(NSString *)message ;

+ (void)showAleartTitle:(NSString *)title;

+ (void)showAleartTitle:(NSString *)title andMessage:(NSString*)message;

@end
