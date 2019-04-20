//
//  AFApi.h
//  AFjettMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /** 故事 */
    StoryItems,
    /** 儿歌 */
    SongsItems,
    /** 英语 */
    EnglishItems,
    /** 喜马拉雅 */
    xmlyItems
} AlbumsStyle;

/*
API 地址

 生产环境版访问协议为https  @"https://lapi.oduola.com";      ///生产
 测试开发版访问协议为http   @"http://api.ledi.oduola.com";   /// 测试

*/

#pragma mark - ServerAddress

extern NSString * const API_HOST;   //测试
extern NSString * const NTE_cerName;   //云信证书名称
extern NSString * const NTES_APP_KEY;  //云信key

extern NSString * const login_appID;      //登录id
extern NSString * const login_appsecret;  //登录secret


#pragma mark - MOB API

#pragma mark 账号信息
extern NSString * const register_code;           //发送验证码 GET
extern NSString * const user_reg;                //创建帐号 POST
extern NSString * const user_login;              //登录鉴权 POST 、刷新 PUT 、DELETE
extern NSString * const user_refreshToken;              //刷新token
extern NSString * const user_update;             //基本信息 GET 、修改 PATCH
extern NSString * const user_findPassword ;      //重置密码
extern NSString * const user_info ;                //获取个人信息

extern NSString * const address_set ;            // 地址增改
extern NSString * const address_get ;            // 地址获取
extern NSString * const address_del ;            // 地址删除

extern NSString * const goodsCate_get;          //  商品获取
extern NSString * const siteInfo_get ;          //  店铺信息
extern NSString * const home_banner ;           // 首页banner
extern NSString * const goodDetail_get;         //  商品信息
extern NSString * const goodsList_get ;         //  商品列表

extern NSString * const recommendList_get;         // 首页推荐


//NIM Token 刷新网易云信Token
extern NSString * const URLjettNIMUserToken;

