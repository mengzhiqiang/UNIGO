//
//  AFCustomContent.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/9.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 

 */

#pragma mark - 发送自定义通知

/* 机器人型号  */

extern NSString * const RobotModel_Big_Jett ;
extern NSString * const RobotModel_small_Jett ;
extern NSString * const RobotModel_TV_Jett ;

extern NSString * const RobotModel_Box_Jett  ;


/**
 *  注：在项目主页需要时隔25s中发送查询机器人状态消息
 */

#pragma mark - 发送自定义通知

//查询机器人状态
extern NSString * const startCommunicationContent;

extern NSString * const stopCommunicationContent;

//Mob 在线
extern NSString * const JiaJiaMobOnlineContent;

//准备监控
extern NSString * const PrepareRemoteNureContent;

//控制机器人转动的方向
//左
extern NSString * const OperationRobotOrientationLeft;

//右
extern NSString * const OperationRobotOrientationRight;

//上
extern NSString * const OperationRobotOrientationUp;

//下
extern NSString * const OperationRobotOrientationDown;

//打开静音状态
extern NSString * const OpenMuteStatusContent;

//关闭静音状态
extern NSString * const CloseMutteStatusContent;

//移动佳佳到尽头
extern NSString * const RobotMoveToTheEndContent;

//准备休眠
extern NSString * const PrePareHibernateContent;

extern NSString * const StarHibernateCallbackContent;
//开始休眠
extern NSString * const StartHibernateContent;

//解除休眠
extern NSString * const RemoveHibernateContent;

//准备聊天
extern NSString * const PrepareChatContent;

//正在拨打中 占线
extern NSString * const CallingBusyLineContent;

//切换到语音聊天
extern NSString * const ChangeAudioChatContent;

//修改宝贝资料
extern NSString * const ModifyBabyRobotInfotmation;

//获取嘉佳的存储总量
extern NSString * const RobotStorageTotalContent;

//Mob 互踢
extern NSString * const MonKickReasonContent;




#pragma mark - 接收到自定义通知  接收Robot的发送的透传消息
//开始监控
extern NSString * const StartRemoteNureContent;

//RBT回复确认可以聊天的透传

extern NSString * const ReplyConfirmChatContent;

//RBT向Mob发起音视频聊天发送透传消息
extern NSString * const ReceiveChatCallContent;

//摇一摇RBT回调
extern NSString *const ReceiveShakeFiinishCallContent;


//嘉佳正在使用状态
//心跳
extern NSString * const JiaJiaRobotOperationStateHeartbeat;

//正在使用与嘉佳聊天
extern NSString * const JiaJiaRobotOperationStateChat;

//正在使用视频聊天
extern NSString * const JiaJiaRobotOperationStateVideoChat;

//正在使用语音聊天
extern NSString * const JiaJiaRobotOperationStateAudioChat;

//正在使用其他应用
extern NSString * const JiaJiaRobotOperationStateUsedApp;

//正在看动画
extern NSString * const JiaJiaRobotOperationStateWatching;

//正在学知识
extern NSString * const JiaJiaRobotOperationStateSduty;

//正在听音乐
extern NSString * const JiaJiaRobotOperationStateMusic;

//正在听故事
extern NSString * const JiaJiaRobotOperationStateStory;



