//
//  UNmanagerController

//  SmartDevice
//
//  Created by mengzhiqiang on 16/3/15.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

//#import "TitleOfHeardViewController.h"

#import "DCBaseSetViewController.h"


@interface UNmanagerController : UIViewController<UITextFieldDelegate>



@property (strong, nonatomic) IBOutlet UITableView *rootTableView;

@property (strong, nonatomic)  UIImage *headImage;


@property (strong, nonatomic)  NSMutableDictionary *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyIDlabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic)  NSString * userNickName;
@property (strong, nonatomic)  NSString * userTrueName;

@property (strong, nonatomic)  NSString * userBirth;
@property (strong, nonatomic)  NSString * userOld;   ////年龄
@property (strong, nonatomic)  NSString * userUrl;   ////头像
@property (strong, nonatomic)  NSString * userSex;
@property (strong, nonatomic)  NSString * userId;
@property (strong, nonatomic)  NSString * userPhone;


@end
