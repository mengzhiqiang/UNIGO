//
//  Define.h
//  tp_self_help
//
//  Created by cloudpower on 13-7-22.
//  Copyright (c) 2013年 cloudpower. All rights reserved.
//

#define  fileIPAddress  @"fileSystemAddress"    ////图片文件地址


#define id_certificateNo    @"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"


#define EMAILE_ZH  @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"  ///邮箱正则
#define NickName_ZH  @"[a-zA-Z0-9\u4e00-\u9fa5]+$"   //// 只含有汉字、数字、字母


#define PASSWORKZ_ZH  @"[A-Za-z0-9_]{6,40}"
#define  PHONE  @"(0[0-9]{2,3})+([2-9][0-9]{6,7})"
#define  phone_zh @"^[1][3-8]+\\d{9}"

#ifndef tp_self_help_Define_h
#define tp_self_help_Define_h

#define isPAD_or_IPONE4  (iPhone4Retina ||isPad)

// 该方法不能识别出ipad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
// 暂用该方法判断是否为ipad
#define isPad (([[UIScreen mainScreen] currentMode].size.width/[[UIScreen mainScreen] currentMode].size.height==(float)3/4) && SCREEN_WIDTH !=375.0)

#define iPhone4Retina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6         (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)||(SCREEN_HEIGHT==667.0 &&SCREEN_WIDTH==375.0))

#define iPhone6plus        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

///尺寸比率
#define  RATIO  (SCREEN_WIDTH/320)
#define  RATIO_IPHONE6  (SCREEN_WIDTH/375)
#define SCREEN_top    (iPhoneX?88:64)
#define iphoneXTop    (iPhoneX?24:0)

#define  Landscape_RATIO  (SCREEN_HEIGHT/320)

/* steam */
#define  STEAM_editor_With  81*Landscape_RATIO
#define  STEAM_editor_Hight  66*Landscape_RATIO

#define  STEAM_Image_With  72*Landscape_RATIO
#define  STEAM_Image_Hight  54*Landscape_RATIO

#define  STEAM_BackG_With  77*Landscape_RATIO
#define  STEAM_BackG_Hight  59*Landscape_RATIO

/*  全局列表高度 背景颜色 */
#define  Cell_Height  50
#define  BackGroundColor [UIColor HexString:@"f2f2f2"]
#define  BackGreenGColor_Nav [UIColor HexString:@"53c81a"]
#define  PersonBackGroundColor [UIColor HexString:@"f5f4f9"]
#define  PersonsubTextColor [UIColor HexString:@"8c8b90"]
#define  PersonTitleTextColor [UIColor HexString:@"353535"]

//颜色设置
#define  greenONE  @"3dc2ed"

#define  backGroundColor  @"f1f5f8"

#define  textTitleColor  @"353535"
#define  textSubTitleColor  @"d3d3d4"

#define  ButtonSelectColor  @"347ff1"
#define  ButtonNormalColor  @"bbbfc8"
////通用颜色
#define  NormalColor  @"597bf2"
////steam  可编辑时颜色
#define  STEAM_editor_Color [UIColor HexString:@"fafafa"]

#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define  tabHeight   self.navigationController.navigationBar.height+20

/********************  userdefault中的信息key  ****************************/
#define FIRST_lOAD            @"firstLoad"    ///第一次进入
#define FIRST_REGISTER            @"FirstRegister"    ///第一次注册

#define KEY_USER_NAME            @"userName"    ///用户名
#define KEY_PASS_WORD            @"passWord"   ////密码

static NSString * const kSmartEaseMobUsername = @"smart.easeMob.username.key";
static NSString * const kSmartEaseMobPassword = @"smart.easeMob.password.key";
static NSString * const kSmartDeviceLoginNotification = @"key.smart.device.login.notification";

#define KEY_ALERT_HOME            @"alertHome"   ////首页进入前五次给提示信息

#define ScreenRect                          [[UIScreen mainScreen] bounds]

#define IOS7 if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))\
{self.edgesForExtendedLayout=UIRectEdgeNone;\
self.navigationController.navigationBar.translucent = NO;}


#define RECT(x,y,witdh,height) CGRectMake(x, y, witdh, height)


/****************云信服务************************************/

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define AFJiaJiaMob_Dispatch_Sync_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define AFJiaJiaMob_Dispatch_Async_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif
