//
//  BabyNickNameViewController.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/5/11.
//  Copyright © 2016年 ALPHA. All rights reserved.
//


#import "TitleOfHeardViewController.h"

@interface UNNickNameViewController : TitleOfHeardViewController

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (strong, nonatomic)  NSMutableDictionary  *baby_Dic;

@property (copy, nonatomic) void (^backBabyinforBlock)(NSDictionary *babyDic);

@end
