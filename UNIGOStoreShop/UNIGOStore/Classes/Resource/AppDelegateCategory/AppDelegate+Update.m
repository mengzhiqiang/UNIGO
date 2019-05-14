//
//  AppDelegate+Update.m
//  SmartDevice
//
//  Created by singelet on 16/6/20.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AppDelegate+Update.h"
#import "HttpEngine.h"
#import "AdvertisingView.h"
@implementation AppDelegate (Update)

- (void)checkAppVersion
{
    [self checkAppVersionWithAppId:@"1462755665"];
    
   AdvertisingView*adView = [[AdvertisingView alloc ]initWithFrame:CGRectZero];
    
}

- (void)checkAppVersionWithAppId:(NSString*)appid
{
    NSString* path = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",appid];
    [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        NSDictionary *resDict   = (NSDictionary*)responseObject;
        [self  checkAppVersionWithInfo:resDict];
    } failure:^(NSError *error) {
        NSDictionary *resDict   = [[NSDictionary alloc]initWithObjectsAndKeys:@"服务器连接异常，请重新再试",@"msg",@"100",@"code", nil];
        [self  checkAppVersionWithInfo:resDict];
    }];
}

- (void)checkAppVersionWithInfo:(NSDictionary *)info
{
    AppDelegate *appdelegate = [AppDelegate delegateGet];
    if ([info objectForKey:@"code"]) {
        return;
    }
    else {
        if ([[info objectForKey:@"results"] count]==0) {
            return;
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *OldVersionID = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSString *NewversonID=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
        NSString *NewversonNotes=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"releaseNotes"];
//        NSString *newVerson= [NewversonID  stringByReplacingOccurrencesOfString:@"." withString:@""];
//        NSString *oldVersion=[OldVersionID  stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSArray * newArray = [NewversonID componentsSeparatedByString:@"."];
        NSArray * oldArray = [OldVersionID componentsSeparatedByString:@"."];
        if ([newArray count]>=3 &&[oldArray count]>=3) {
            
            int newX = [[newArray objectAtIndex:0] intValue];
            int newY = [[newArray objectAtIndex:1] intValue];
            int newZ = [[newArray objectAtIndex:2] intValue];
            int oldX = [[oldArray objectAtIndex:0] intValue];
            int oldY = [[oldArray objectAtIndex:1] intValue];
            int oldZ = [[oldArray objectAtIndex:2] intValue];
            
            if (newX>oldX) {
                
            }else if (newX==oldX) {
                     if (newY>oldY) {
                    
                    }else  if (newY==oldY) {
                            if (newZ>oldZ) {
                        
                           }else{
                           return ;
                           }
                }else{
                    return ;
                }
            }else{
                return ;
            }
        }

//            if ([[newArray objectAtIndex:0] intValue]>[[oldArray objectAtIndex:0] intValue]) {
//                appdelegate.refreshUrl=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
//                appdelegate.refreshUrl=  [appdelegate.refreshUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"itms-apps://"];
//                UIAlertView *aler=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"已有新版本%@，现在去AppStore更新吧！",NewversonID] message:NewversonNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [aler show];
//                return;
//            }
//
//        }
//
//        if ([newVerson intValue]/pow(10, [newVerson length])<=[oldVersion intValue]/pow(10, [oldVersion length])) {
//            return;
//        }
       
        
        if (![OldVersionID isEqualToString:NewversonID]) {
            appdelegate.refreshUrl=[[[info objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
            appdelegate.refreshUrl=  [appdelegate.refreshUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"itms-apps://"];
            UIAlertView *aler=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"已有新版本%@，现在去AppStore更新吧！",NewversonID] message:NewversonNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [aler show];
        }
        else {
            return;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     AppDelegate *appdelegate = [AppDelegate delegateGet];
    if (buttonIndex == 1) {//更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appdelegate.refreshUrl]];
    }
}



@end
