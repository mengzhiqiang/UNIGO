//
//  LogInmainViewController.h
//  ALPHA
//
//  Created by teelab2 on 14-4-2.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UMSocial.h"
//#import "WXApi.h"
//#import <TencentOpenAPI/QQApiInterface.h>   <UMSocialUIDelegate>

#import "TitleOfHeardViewController.h"


@interface LogInmainViewController : TitleOfHeardViewController<UITextFieldDelegate>{

    UIScrollView  * _ad_scrollView;

}

@property (strong, nonatomic) IBOutlet UIButton *loginForUseId;

@property (strong, nonatomic) IBOutlet UITextField *UserName;
@property (strong, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UILabel *lineEmail;

@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic)  UIViewController * popVc;    //// 返回vc

@property (assign, nonatomic)  int  regist;  ///登录进来的
@property (assign, nonatomic)  int  netWoring;  ///判断



@end
