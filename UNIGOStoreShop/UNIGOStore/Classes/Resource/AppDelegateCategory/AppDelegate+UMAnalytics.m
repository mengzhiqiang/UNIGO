//
//  AppDelegate+UMpush.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/24.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "AppDelegate+UMAnalytics.h"
//#import <UMMobClick/MobClick.h>

@implementation AppDelegate (UMAnalytics)

-(void)createUMAnalyticsApplication:(UIApplication *)application{

    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    
////    [MobClick setLogEnabled:YES];
//    UMConfigInstance.appKey = @"576a3cc867e58ef68f000f0a";
//    UMConfigInstance.secret = @"乐迪机器人";
//    UMConfigInstance.channelId = @"App Store";
//
//    //    UMConfigInstance.eSType = E_UM_GAME;
//    [MobClick startWithConfigure:UMConfigInstance];
    
//    [MobClick setLogEnabled:YES];
//    [self readDeverID]; ///设备识别信息 UM用来区分测试机和正常机；
}

//-(void)readDeverID
//{
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"UMANUtil==%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    
//}

@end
