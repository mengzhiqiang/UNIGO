//
//  AFEditeViewController.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/11.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "TitleOfHeardViewController.h"
//#import "AFPasswordTextField.h"
#import "AFCommonEngine.h"
@interface AFEditeNickNameViewController : TitleOfHeardViewController

@property (strong, nonatomic) NSString * nickName; ///用户昵称
@property (assign, nonatomic) int  type;//操作类型0昵称   20宝贝昵 30设备

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (strong, nonatomic) NSMutableDictionary * babyDic;   //宝贝信息
@property (copy, nonatomic) void (^backWithNickNameBlock)(NSString *nickName);

@end
