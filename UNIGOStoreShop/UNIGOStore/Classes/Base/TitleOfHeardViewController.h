//
//  TitleOfHeardViewController.h
//  ALPHA
//
//  Created by teelab2 on 14-7-8.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExtendClass.h"
#import "Define.h"

@interface TitleOfHeardViewController : UIViewController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>{

   
}
//////数据

@property (strong, nonatomic)  UIButton*  headLeftButton;    ////
@property (strong, nonatomic)  UIImageView*  headimageView;    ////


@property (strong, nonatomic)  UILabel*  headLabel;    ////
@property (strong, nonatomic)  UILabel*  headSubLabel;    ////

@property (strong, nonatomic)  UIButton*  headMessageButton;    ////
@property (strong, nonatomic)  UIButton*  leftShutDownButton;    ////
@property (strong, nonatomic)  UIImageView *     HeadView;    ////
@property (strong, nonatomic)  UIView    *    PromptView_Nav;    ////
@property (strong, nonatomic)  UILabel    *   PromptLabel_Nav;    ////

@property (strong, nonatomic)  UIView    *    hubView;    ////
@property (strong, nonatomic)  UILabel    *    hublabel;    ////
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;


@property (strong, nonatomic)  UIImageView  *  backgroundImageView;    ////

+ (instancetype)buildWithNibFile ;
-(void)backBtnClicked;  /// 返回上一页

-(void)ShutDownVc;  ///关闭当前vc 返回上一页

-(void)promtNavHidden:(NSString*)title;   ///标题栏错误提示
-(void)RightMessageOfTableView;
-(UIView*)headerViewWithTitle:(NSString*)title target:(id)sender colour:(UIColor *)colour Landscape:(BOOL)isLandscape;

-(void)changeLandscap;

/* 副标题 */
-(void)setHeadSubTitle:(NSString*)title ;
@end
