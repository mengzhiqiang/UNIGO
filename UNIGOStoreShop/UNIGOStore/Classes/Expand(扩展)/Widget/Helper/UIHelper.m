//
//  UIHelper.m
//  tp_self_help
//
//  Created by cloudpower on 13-7-23.
//  Copyright (c) 2013年 cloudpower. All rights reserved.
//

#import "UIHelper.h"
#import "CustomAlertView.h"
#import "SVProgressHUD.h"
#import "ExtendClass.h"
#import "CustomtAlertView.h"
#import "AFToolTipOfHead.h"
//#import "AppDelegate+Notification.h"
#import "HttpRequestToken.h"
#import "HttpEngine.h"
#import "CheckNetwordStatus.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "LogInmainViewController.h"
#import "UIViewController+Extension.h"
@implementation UIHelper

/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param plaintext 要加密的文本
 *  @param key       秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

/**************************************************************
 ** 功能:     网络判断
 ** 参数:     wu
 ** 返回:     网络是否可用
 **************************************************************/
+(BOOL)isNetworking{
    
    if (![CheckNetwordStatus sharedInstance].isNetword) {
        [AFAlertViewHelper alertViewWithTitle:nil message:@"当前网络不可用，请检查手机的网络设置" delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
            //
        }];
        return NO;
    }
    
    return YES;
}

/**************************************************************
 ** 功能:     弹出toast提示    警告提示
 ** 参数:     nsstring
 ** 返回:     无
 **************************************************************/
+ (void)alertWithTitle:(NSString*)title{
    
    if ([title isEqualToString:@"音量已增大"]|| [title isEqualToString:@"音量已减小"]) {
        [[CustomtAlertView sharedView] settingSuccessWith:title];
        return;
    } else if ([title isEqualToString:@"设置失败"]){
        [[CustomtAlertView sharedView] settingFailWith:title];
        return;
    }else {
        [SVProgressHUD showErrorWithStatus:title];

    }
 }
/**************************************************************
 ** 功能:     弹出顶部提示    警告提示
 ** 参数:     nsstring
 ** 返回:     无
 **************************************************************/
+ (void)showUpMessage:(NSString *)message{
    
    [[AFToolTipOfHead sharedInstance ]addViewOfHeadWithTitle:message BackColor:nil];
}
/**************************************************************
 ** 功能:     弹出顶部提示    警告提示
 ** 参数:     nsstring 提示语  背景颜色
 ** 返回:     无
 **************************************************************/
+ (void)showUpMessage:(NSString *)message withColor:(UIColor*)color{
    
    if (!color) {
        color = BackGreenGColor_Nav ;
    }
    [[AFToolTipOfHead sharedInstance ]addViewOfHeadWithTitle:message BackColor:color];
}

/**************************************************************
 ** 功能:     alert提示
 ** 参数:     nsstring（提示内容内容）、代理对象
 ** 返回:     无
 **************************************************************/
+ (void)alertWithTitle:(NSString*)title
            WithMsg:(NSString*)msg
            delegate:(id)sender
            BtnTitle:(NSString*)btnTitle
          otherTitle:(NSString*)otherTitle
              andTag:(NSInteger)tag
          backHander:(void(^)())back
          otherHander:(void(^)())otherback
          {
    
    if (IOS_VERSION>=9.0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (back) {
                back();
            }
        }];
        
        [alertController addAction:cancelAction];

        if ([otherTitle length]>0) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (otherback) {
                    otherback();
                }
            }];
            
            [alertController addAction:otherAction];

        }
       
        // Add the actions.
        [sender presentViewController:alertController animated:YES completion:nil];
    }else{
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:title message:msg delegate:sender cancelButtonTitle:btnTitle otherButtonTitles:otherTitle, nil];
        view.tag = tag;
        [view show];
    }
    
}

/**************************************************************
 ** 功能:     加loading view  (新加)
 ** 参数:     cgrect(loadingview的frame)、id（加在此对象上）
 ** 返回:     无
 **************************************************************/
+ (void)addLoadingViewTo:(UIView*)targetV  andText:(NSString*)text{
    
    CustomAlertView *alert=[[CustomAlertView alloc]initWithFrame:targetV.bounds];
    
    [targetV addSubview:alert];
    [[alert gifImageView] startAnimating];
    [alert setHidden:NO];

}

/**************************************************************
 ** 功能:     加loading view
 ** 参数:     cgrect(loadingview的frame)、id（加在此对象上） 新
 ** 返回:     无
 **************************************************************/
+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(int)height {

    CGRect rect=CGRectMake(0, 64+height, SCREEN_WIDTH, SCREEN_HEIGHT-(64+height));
    if (iPhoneX && IsPortrait) {
        rect.origin.y = 88+height;
    }
    
    CustomAlertView *alert=[[CustomAlertView alloc]initWithFrame:rect];
    [targetV addSubview:alert];
    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window addSubview:alert];
//    [alert backGrondColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [[alert gifImageView] startAnimating];
    [alert setHidden:NO];
    
    
    
}
/**************************************************************
 ** 功能:     加loading view 设置背景颜色
 ** 参数:     cgrect(loadingview的frame)、
 ** 返回:     无
 **************************************************************/
+ (void)addLoadingViewTo:(UIView*)targetV withFrame:(int)height withcolor:(UIColor*)color{
    CGRect rect=CGRectMake(0, 64+height, SCREEN_WIDTH, SCREEN_HEIGHT-(64+height));
    
    CustomAlertView *alert=[[CustomAlertView alloc]initWithFrame:rect];
    [targetV addSubview:alert];
    [alert backGrondColor:[UIColor colorWithHexValue:0xfafafa]];
    [[alert gifImageView] startAnimating];
    [alert setHidden:NO];

}

+(BOOL)TitleMessage:(NSDictionary *)Dic_data{
    
    int code=[[Dic_data objectForKey:@"status"] intValue];
    
    NSString * msg=[Dic_data objectForKey:@"msg"];


     if (msg.length>0){
         [self showUpMessage:msg];
         return NO ;
    }
    
    else if (code == 100) {
        
        [AFAlertViewHelper alertViewWithTitle:nil message:@"当前网络不可用，请检查手机的网络设置" delegate:nil cancelTitle:@"我知道了" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
//
            }];
        return NO;
    }
  
    return YES;
}

+(void)pushLoinViewContrlller{
    
    
    LogInmainViewController * loginVC = [[LogInmainViewController alloc]init];
    [[UIViewController getCurrentController] presentViewController:loginVC animated:YES completion:nil];
    
}


+(void)hiddenAlertWith:(UIView*)targetV{

//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    for (UIView *view in [targetV subviews]) {
        if ([view isKindOfClass:[CustomAlertView class]]) {
            view.hidden=YES;
            [view removeFromSuperview];
        }
    }
}

+(CGSize) makeNewRectView:(UILabel*)mylabel oldSize:(CGSize) oldsize{
    
    
    NSMutableDictionary *dic_font=[[NSMutableDictionary alloc]init];
    [dic_font  setValue:mylabel.font forKey:NSFontAttributeName];
    // 计算文本的大小
    CGSize textSize = [mylabel.text boundingRectWithSize:oldsize // 用于计算文本绘制时占据的矩形块
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                              attributes:dic_font        // 文字的属性
                                                 context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil

    
    CGSize newRect= CGSizeMake(textSize.width, textSize.height);
    return newRect;
    
}

/**************************************************************
 ** 功能:     清除ui数据
 ** 参数:     uiview
 ** 返回:     无
 **************************************************************/
+(void)ClearViewOFView:(UIView*)view{
    @try{
        if ([[view subviews] count]>1) {
            for (UIView*view0 in [view subviews]) {
                [self ClearViewOFView:view0];
            }
        }else{
            view=nil;
            [view removeFromSuperview];
            
        }
        
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
    
}



@end
