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
NSString * const user_refreshToken      = @"user/refresh";              //刷新token

NSString * const user_update       = @"user/updateUserInfo";           //基本信息 修改
NSString * const user_info         = @"user/getuserinfo";              //获取个人信息
NSString * const user_findPassword = @"user/findBackPassword";         //重置密码  address/set

NSString * const address_set = @"address/set";             // 地址增改
NSString * const address_get = @"address/get";             // 地址获取
NSString * const address_del = @"address/del";             // 地址删除

NSString * const home_banner = @"slider/sliderList";         //  首页banner
NSString * const goodsCate_get = @"goodsCate/get";           //  商品分类
NSString * const goodsList_get = @"goods/goodsList";         //  商品列表
NSString * const siteInfo_get = @"/site/info";               //  店铺信息
NSString * const goodDetail_get = @"/goods/details";         //  商品信息

NSString * const goodsCart_list       = @"/goodsCart/lists";          //  购物车列表
NSString * const goodsCart_add        = @"/goodsCart/add";            //  添加购物车
NSString * const goodsCart_modify     = @"/goodsCart/modify";         //  编辑购物车

NSString * const order_add         = @"/order/add";             //  提交订单
NSString * const order_lists       = @"/order/lists";           //  订单列表
NSString * const order_details     = @"/order/details";         //  订单详情
NSString * const order_pay     = @"/order/pay";                //  支付接口
NSString * const order_cancel     = @"/order/cancel";          //  取消订单





NSString * const recommendList_get = @"recommend/lists";         // 首页推荐



//NIM Token 刷新网易云信Token
NSString * const URLjettNIMUserToken = @"/m/user/nim";

