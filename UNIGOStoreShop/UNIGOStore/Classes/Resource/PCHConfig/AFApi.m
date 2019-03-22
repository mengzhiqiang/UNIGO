//
//  AFApi.m
//  AFjettMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFApi.h"

/*
 API 地址
 生产环境版访问协议为https  @"https://lapi.oduola.com";      ///生产
 测试开发版访问协议为http   @"http://api.ledi.oduola.com";   /// 测试
 
 2017总结
 
 上半年主要是
 1、上线嘉佳智能APP并进行版本迭代更新；
 2、乐迪机器人海外版上架；
 3、乐迪智能版本小范围迭代更新；
 
 下半年
 1、乐迪早教APP的研发并上架；
 2、乐迪机器人添加小乐迪并更名为乐迪智能；
 3、乐迪智能APP研发Steam功能并上架；
 4、乐迪智能版本持续迭代更新。
 
 */

#pragma mark - ServerAddress

//#ifdef RELEASE_jettMOB_DEVELOP
////开发环境
//NSString * const API_HOST = @"https://rsdb.oduola.com";
//
//#elif RELEASE_jettMOB_TEST
//
////测试环境
//NSString * const API_HOST = @"https://rsdb.oduola.com";
//
//#elif RELEASE_jettMOB_PRODUCTION
//
////生产环境 生产包域名
//NSString * const API_HOST = @"https://rapi.oduola.com";
//
//#endif
//nim =     {
//    accid = 000001D1;
//    token = Qb4nJZKo405Y4hHXA7PoYzrWS6RpwJJz;
//};
//测试环境
NSString * const API_HOST = @"http://unigo.itpang.com/api/";
NSString * const NTE_cerName = @"lediDeveloper";      //云信证书名称
NSString * const NTES_APP_KEY = @"d9d6e917ea9699ee4fe588d8948b545e";      //云信key

//生产环境
//NSString * const API_HOST = @"https://lapi.oduola.com";
//NSString * const NTE_cerName = @"lediDistribution";      //云信证书名称
//NSString * const NTES_APP_KEY = @"d9d6e917ea9699ee4fe588d8948b545e";   //云信key


NSString * const login_appID     = @"tp5unigo2019";      //登录id
NSString * const login_appsecret = @"unigo";     //登录secret
#pragma mark -  MOB API

NSString * const register_code     = @"sms/send";                     //发送验证码  POST
NSString * const user_reg          = @"user/reg";                     //创建帐号 POST
NSString * const user_login        = @"user/login";                   //登录鉴权 POST
NSString * const user_update       = @"user/updateUserInfo";           //基本信息 修改
NSString * const user_info         = @"user/getuserinfo";              //获取个人信息
NSString * const user_findPassword = @"user/findBackPassword";         //重置密码  address/set


NSString * const address_set = @"address/set";             // 地址增改
NSString * const address_get = @"address/get";             // 地址获取
NSString * const goodsCate_get = @"goodsCate/get";         //  商品获取

NSString * const siteInfo_get = @"/site/info";         //  店铺信息



NSString * const jett_password_code = @"/m/password/code"; //验证码GET(发送) POST(验证)
NSString * const jett_user  = @"/m/user";               //基本信息 GET 、修改 PATCH

NSString * const jett_user_password  = @"/m/user/password";    ///修改密码 PATCH
NSString * const jett_user_passwordOtt  = @"/m/user/password/ott";  ///修改密码获取ott

NSString * const jett_babies = @"/m/babies";            //创建宝贝 POST
NSString * const jett_connect = @"/m/connect";             //绑定设备 POST
NSString * const jett_connect_ott2sn = @"/m/connect/ott2sn";             //绑定设备 验证码oot

NSString * const jett_Sign_policy = @"/m/sign/";             //表单上传策略 GET
NSString * const jett_image_Upload = @"/m/upload/";            //图片上传  POST
NSString * const URLjettAccountCache  = @"/m/cache/user";   //聚合信息 GET

//宝贝机器人列表
NSString * const URLjettBabiesRobots = @"/m/babies/%@/robots";
//NIM Token 刷新网易云信Token
NSString * const URLjettNIMUserToken = @"/m/user/nim";

NSString * const jett_helpMe_corpusOtt = @"/m/corpus/tts";  //自定义TTS语料 GET

#pragma mark steam
NSString * const jett_steam_babies = @"/m/babies/%@/steam";  //steam Get Post
NSString * const jett_steam_babies_uuid = @"/m/babies/%@/steam/%@";  //steam GET  PATCH DELETE

/*
 影音资源api
 */
NSString * const jett_media_Meta = @"/m/media/meta";     //首页推荐分类

NSString * const jett_media_Home = @"/m/columns";     //首页推荐分类

NSString * const jett_media_items = @"/3rd/media/items";     //影音列表
NSString * const jett_media_albums = @"/3rd/media/albums";     //专辑列表
NSString * const jett_media_albums_id = @"/3rd/media/albums/%@";     //单个专辑详情
/*
 广告
 */
NSString * const jett_AD_splash    = @"/m/ads/splash";     //启动广告

/* 微聊 */
NSString * const SRA_feed_list     = @"/m/babies/%@/feedlist";                   //
