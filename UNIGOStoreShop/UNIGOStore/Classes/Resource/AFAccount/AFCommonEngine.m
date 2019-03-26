//
//  AFCommonEngine.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//
/*
 宝贝信息页面  
  两张情况
 1 有guid  直接根据 guid 获取用户信息 
 
 2 无guid 添加宝贝
 
 */

#import "AFCommonEngine.h"

#import "HttpRequestToken.h"

#import "CommonVariable.h"

#import "AFAccountEngine.h"
#import "AppDelegate+Notification.h"

#import "AFBabiesModel.h"
#import "AFCustomContent.h"

@implementation AFCommonEngine

#pragma mark - 宝贝信息

+ (void)saveBadiesDataWithResponseObject:(NSDictionary *)responseObject
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:kJettMobBabiesInformation];
    
    AFBabiesModel *babiesModel = [AFBabiesModel mj_objectWithKeyValues:responseObject];
    if (babiesModel) {
        //归档保存数据
        BOOL isKeyed = [NSKeyedArchiver archiveRootObject:babiesModel toFile:filePath];
        if (isKeyed) {
            NSLog(@"保存成功");
        }
    }
}





#pragma mark - Robot Online

//保存RBT是否在线
+ (void)setRobotOnline:(BOOL)online
{
    [[NSUserDefaults standardUserDefaults] setBool:online forKey:@"kJiaJiaRobotOline"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getRobotOnline
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kJiaJiaRobotOline"];
}


#pragma mark - 退出登录
+(void)logoutOfAFcommon{
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - Data Request


+ (void)pushSlectedRobotInterface
{
    
//    [AFCommonEngine removeBadiesData];
    UINavigationController *navi  =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *visibleController = navi.visibleViewController;
//    UIViewController *topController = navi.topViewController;
//    UIViewController *currentController = [[navi viewControllers] lastObject];
    
    [visibleController.navigationController popToRootViewControllerAnimated:YES];
    
}


///**
// *  请求用户登录
// *
// *  @param username 用户名
// *  @param password 用户密码
// *  @param success  请求登录成功返回
// *  @param failure  请求登录失败返回
// */
+ (void)requestedAccountLoginWithUsername:(NSString *)username
                                 password:(NSString *)password
                                  success:(void(^)(NSDictionary *responseObject))success
                                  failure:(void(^)(NSError *error))failure
{
//    AFAccount *account = [AFAccountEngine sharedInstance].currentAccount;
//    if (username.length <= 0) {
//        username = account.mobile;
//    }
    NSString *path = [API_HOST stringByAppendingString:user_login];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    postDic[@"mobile"] = username == nil ? @"" : username;    
    postDic[@"password"] = password == nil ? @"" : password;
    [HttpEngine requestPostWithURL:path params:postDic isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"];
        [HttpRequestToken saveToken:JSONDic[@"access_token"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:password  forKey:KEY_PASS_WORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSmartDeviceLoginNotification object:nil];
        
        !success ?  : success(JSONDic);
    } failure:failure];
}


@end
