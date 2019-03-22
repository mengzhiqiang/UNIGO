//
//  AFCommonEngine.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFCommonEngine : NSObject

#pragma mark - 宝贝信息
//保存宝贝信息
+ (void)saveBadiesDataWithResponseObject:(NSDictionary *)responseObject;



#pragma mark - Robot Online


#pragma mark - 退出登录
+(void)logoutOfAFcommon;


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
                              failure:(void(^)(NSError *error))failure;

/**
 *  请求用户登录
 *
 *  @param username 用户名
 *  @param password 用户密码
 *  @param success  请求登录成功返回
 *  @param failure  请求登录失败返回
 */
+ (void)requestedAccountLoginWithUsername:(NSString *)username
                                 password:(NSString *)password
                                  success:(void(^)(NSDictionary *responseObject))success
                                  failure:(void(^)(NSError *error))failure;


/**
 *  请求获取用户信息
 *
 *  @param param   请求参数
 *  @param success 请求成功返回
 *  @param failure 请求失败返回
 */
+ (void)requestedAccountCacheWithParam:(NSDictionary *)param
                               success:(void(^)(NSDictionary *responseObject))success
                               failure:(void(^)(NSError *error))failure;
@end
