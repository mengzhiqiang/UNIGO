//
//  AFConstantKey.h
//  AFJettMob
//
//  Created by singelet on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 全局数据存储 key or 路径
 
 */
/*
 资源存储  儿歌 故事 英语
 */
extern NSString * const kMediaMetaAblumsData ;
extern NSString * const kHomeMediaMetaAblumsData;
extern NSString * const kRecordMediaMetaData ;

extern NSString * const kMediaMetaAblumsPlayingList;
extern NSString * const kMediaHotWordRecommend;

extern NSString * const kMediaNotionRefreshTableView;


/*
 资源存储  儿歌 故事 英语
 */
extern NSString * const kMediaAllAblumslist;

extern NSString * const kMediaSonglist ;
extern NSString * const kMediaStorylist ;
extern NSString * const kMediaEnglishlist ;
//乐点播通知
extern NSString * const AlbumsViewControllerRequestFailNotification;


/*登录 token  
 用户信息存储
 */
extern NSString * const kSmartDeviceLoginTokenKey;
extern NSString * const kSmartDeviceUseInfornKey;

/* 个人 宝贝信息 机器人保存key */
extern NSString * const kJettMobAccountInformation ;
extern NSString * const kJettMobBabiesInformation ;  ///宝贝信息保存key
extern NSString * const kJettMobBabiesRobotsInformation ; //机器人信息
extern NSString * const kJettMobSingleBabyInformation ;  ///单个宝贝信息
extern NSString * const kJettMobBabyRobotSelect ;      ///当前选中的设备

extern NSString * const kJettMobShowRobot ;      ///无设备时 需要显示设备标记

extern NSString * const kJettRobotState ;      ///设备设置信息（防沉迷）
extern NSString * const kJettRobotMovemnet ;

/*网易云信帐号和token 保存Key*/
extern NSString * const kJiaJiaMobNimSDKLoginData;



/*
    通知名称
 */
extern NSString * const kMobPushLoginVCNotification;
extern NSString * const kMobPopRootVCNotification;
extern NSString * const kMobPuhsBindVCNotification;

/*
    当前网络切换通知提示
 */
extern NSString * const KmobNotionCheckNetwordStatus;
extern NSString * const KmobNotionWifiTypeIn ;
extern NSString * const KmobNotionWifiBackSuccess;

/*
 透传接收通知
 */
extern NSString * const kRobotNIMHeart ;
extern NSString * const kRobotNIMDemandVoice;
extern NSString * const kRobotNIMDemandHelpMeSay;
extern NSString * const kRobotNIMVoiceSize ;

extern NSString * const kRobotSelectSetting ;

/*
 STEAM
 */
extern NSString * const kRobotSteamSend ;
extern NSString * const kRobotSteamStopPlaying ;

extern NSString * const SRA_feed_list_data  ;
extern NSString * const SRA_chat_Data  ;
