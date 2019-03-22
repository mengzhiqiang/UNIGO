//
//  AmendPWViewController.h
//  ALPHA
//
//  Created by teelab2 on 15/1/27.
//  Copyright (c) 2015年 ALPHA. All rights reserved.
//


#import "TitleOfHeardViewController.h"
@interface AmendPWViewController : TitleOfHeardViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *PassWTestField;
@property (assign, nonatomic)  int  settingPW;


@property (strong, nonatomic)  NSString * oldPassWord;

- (IBAction)commintPassWord:(UIButton *)sender;

@end
