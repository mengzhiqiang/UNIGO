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
    
   
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASS_WORD];
//    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceUseInfornKey];
//    [[CommonVariable shareCommonVariable]setUserInfoo:nil];
//    //退出网易云信
//    [[AFNIMEngine sharedInstance] logoutNIMSDK];
//    
//    [AFCommonEngine removeBadiesData];
//    [AFCommonEngine removeBabiesRobotsData];
//    [AFCommonEngine removeBabaySelectRobotData];
//    
//    [[EaseMobEngine sharedInstance] logoutEasemobSDK];
//    
//    [AppDelegate postSwitchRootViewControllerNotificationWithIsLogin:YES];
#warning  阿里云推送设置关闭
//    [CloudPushSDK  unbindAccount:^(CloudPushCallbackResult *res) {
//          if (res.success) {
//              NSLog(@"====%@",res.data) ;
//          }
//          else {
//              NSLog(@"====%@",res.error);
//          }
//      }];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [AppDelegate createApplicationShortcutItem];
//    //通知更换根视图控制器
//    [AppDelegate postSwitchRootViewControllerNotificationWithIsLogin:YES];
}

#pragma mark - Data Request

/**
 *  获取宝贝机器人列表信息
 *
 *  @param guid    用户guid
 *  @param params  请求参数
 *  @param success 请求成功返回
 *  @param failure 请求失败返回
 */
+ (void)requestedBabiesRobotsWithGuid:(NSString *)guid
                               params:(NSDictionary *)params
                              success:(void(^)(NSDictionary *responseObject))success
                              failure:(void(^)(NSError *error))failure
{
    
    NSString *path = [NSString stringWithFormat:URLjettBabiesRobots,guid];
    NSString *urlString = [API_HOST stringByAppendingString:path];
    
    NSMutableDictionary *getDic = [[NSMutableDictionary alloc] init];
    getDic[@"guid"] = guid == nil ? @"" : guid;
    
    [HttpEngine requestGetWithURL:urlString params:getDic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSArray *robots = responseObject[@"data"];
        if (robots.count <= 0) {
            [self pushSlectedRobotInterface];
        }
        NSDictionary *JSONDic = (NSDictionary *)responseObject;
         !success ?  : success(JSONDic);
    } failure:^(NSError *error) {
        NSDictionary * info = error.userInfo;
        int code = [[info objectForKey:@"status_code"] intValue];
        if (code == 404) {
            if ([[info objectForKey:@"message"] isEqualToString:@"baby_robot_not_found"] || [[info objectForKey:@"message"] isEqualToString:@"baby_not_found"] || [[info objectForKey:@"message"] isEqualToString:@"user_baby_not_found"]) {
                [self pushSlectedRobotInterface];
                
            }
        }
        !failure ? :failure(error);
    }];
    
}

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
//
///**
// *  请求获取用户信息
// *
// *  @param param   请求参数
// *  @param success 请求成功返回
// *  @param failure 请求失败返回
// */
//+ (void)requestedAccountCacheWithParam:(NSDictionary *)param
//                               success:(void(^)(NSDictionary *responseObject))success
//                               failure:(void(^)(NSError *error))failure
//{
//     NSString *path = [API_HOST stringByAppendingString:URLjettAccountCache];
//    [HttpEngine requestGetWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
//        //绑定阿里云帐号
//        NSString * accout_id = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"id"]];
//#warning 阿里云绑定帐号
////        [CloudPushSDK bindAccount:accout_id withCallback:^(CloudPushCallbackResult *res) {
////            if (res.success) {
////                NSLog(@"=====绑定阿里云帐号=%@",res.data);
////            }else{
////                NSLog(@"=====绑定阿里云帐号-error=%@",res.error);
////            }
////        }];
//        
//        //保存当前用户信息
//        [AFAccountEngine saveAccountInformationWithUserInfo:responseObject];
//        //登录云信
//        [[AFNIMEngine sharedInstance] loginNIMSDKWithNIMInfo:responseObject[@"nim"]];
//        [AFCommonEngine saveBadiesDataWithResponseObject:[responseObject objectForKey:@"babies"]];
//        
//        if ([[responseObject objectForKey:@"babies"] count]>0) {
//            NSDictionary* dic = [[responseObject objectForKey:@"babies"] objectAtIndex:0];
//            [AFCommonEngine saveBadiesDataWithResponseObject:dic];
//        }
//        
//
//        
//        NSDictionary *JSONDic = (NSDictionary *)responseObject;
//        !success ?  : success(JSONDic);
//    } failure:^(NSError *error) {
//        
//        !failure ? :failure(error);
//    }];
//}



@end
