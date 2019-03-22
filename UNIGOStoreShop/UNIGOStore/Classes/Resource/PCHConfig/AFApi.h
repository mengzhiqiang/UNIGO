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
extern NSString * const user_update;             //基本信息 GET 、修改 PATCH
extern NSString * const user_findPassword ;      //重置密码
extern NSString * const user_info ;                //获取个人信息


extern NSString * const address_set ;         // 地址增改
extern NSString * const address_get ;         // 地址获取
extern NSString * const goodsCate_get;         //  商品获取

extern NSString * const siteInfo_get ;         //  店铺信息


extern NSString * const jett_user;               //基本信息 POST 、修改 PATCH

extern NSString * const jett_user_password  ;    ///修改密码 PATCH
extern NSString * const jett_user_passwordOtt ;  ///修改密码获取ott

extern NSString * const jett_babies;             //创建宝贝 POST
extern NSString * const jett_connect;             //绑定设备 POST
extern NSString * const jett_connect_ott2sn;     //验证码获取设备信息
extern NSString * const jett_2factor;             //解绑二次确认

extern NSString * const jett_Sign_policy;             //表单上传策略 GET
extern NSString * const jett_image_Upload;            //图片上传  POST
extern NSString * const jett_inbox_messages ;   //消息列表  GET
extern NSString * const jett_robots_configs;  ///机器人配置
extern NSString * const jett_user_management;   //管理信息
extern NSString * const jett_robot_applistions;   //robot应用列表

extern NSString * const URLjettAccountCache;
//宝贝机器人列表
extern NSString * const URLjettBabiesRobots;
//NIM Token 刷新网易云信Token
extern NSString * const URLjettNIMUserToken;
//获取扫描绑定令牌
extern NSString * const URLjettScanBindingToken;
//获取宝贝家人
extern NSString * const URLjettBabyFamily;
//主帐号解除副帐号与宝贝的关联
extern NSString * const URLMasterAccountRemoveFamily;



// MOB 网址信息
extern NSString * const URL_Privacy_Provision;  //隐私条款
extern NSString * const URL_User_Protocol;  //用户协议
extern NSString * const URL_jett_shake ;  //摇一摇帮助

extern NSString * const URL_jett_myServer ;
extern NSString * const URL_jett_service_menu ;
extern NSString * const URL_jett_Help_wifi ;

extern NSString * const jett_helpMe_corpusOtt ;

#pragma mark steam
extern NSString * const jett_steam_babies ;  //steam Get Post
extern NSString * const jett_steam_babies_uuid ;  //steam GET  PATCH DELETE


/*
 广告
 */
extern NSString * const jett_AD_splash ;     //启动广告

/* 微聊 */
extern NSString * const SRA_feed_list;
