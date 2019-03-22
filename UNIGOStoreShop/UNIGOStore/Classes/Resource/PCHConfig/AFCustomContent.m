//
//  AFCustomContent.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/8/9.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFCustomContent.h"

/* 机器人型号  */
NSString * const RobotModel_Big_Jett       = @"ZN22101";
NSString * const RobotModel_small_Jett     = @"ZN322311";
NSString * const RobotModel_TV_Jett        = @"ZN322321";

NSString * const RobotModel_Box_Jett       = @"ZN322331";    ///音箱


//查询机器人状态
NSString * const startCommunicationContent = @"27";
NSString * const stopCommunicationContent = @"26";

//Mob 在线
NSString * const JiaJiaMobOnlineContent = @"29";

//准备监控
NSString * const PrepareRemoteNureContent = @"12";

//控制机器人转动的方向
//左
NSString * const OperationRobotOrientationLeft = @"07";

//右
NSString * const OperationRobotOrientationRight = @"08";

//上
NSString * const OperationRobotOrientationUp = @"09";

//下
NSString * const OperationRobotOrientationDown = @"10";

//打开静音状态
NSString * const OpenMuteStatusContent = @"14";

//关闭静音状态
NSString * const CloseMutteStatusContent = @"13";

//移动佳佳到尽头
NSString * const RobotMoveToTheEndContent = @"15";


//准备休眠
NSString * const PrePareHibernateContent = @"38?00?%zd";
//休眠回调
NSString * const StarHibernateCallbackContent = @"38";
//开始休眠
NSString * const StartHibernateContent = @"38?01?%zd";

//解除休眠
NSString * const RemoveHibernateContent = @"39";

//准备聊天
NSString * const PrepareChatContent = @"21";

//正在拨打中 占线
NSString * const CallingBusyLineContent = @"I_am_calling";

//切换到语音聊天
NSString * const ChangeAudioChatContent = @"30";

//修改宝贝资料
NSString * const ModifyBabyRobotInfotmation = @"34";

//获取嘉佳的存储总量
NSString * const RobotStorageTotalContent = @"43";

NSString * const MonKickReasonContent = @"99";


#pragma mark - 接收到自定义通知  接收Robot的发送的透传消息
//开始监控
NSString * const StartRemoteNureContent = @"11";

NSString * const ReplyConfirmChatContent = @"20";

NSString * const ReceiveChatCallContent = @"28";

NSString *const ReceiveShakeFiinishCallContent = @"100";
//嘉佳正在使用状态
//心跳
NSString * const JiaJiaRobotOperationStateHeartbeat = @"05";

//正在使用与嘉佳聊天
NSString * const JiaJiaRobotOperationStateChat = @"40";

//正在使用视频聊天
NSString * const JiaJiaRobotOperationStateVideoChat = @"31";

//正在使用语音聊天
NSString * const JiaJiaRobotOperationStateAudioChat = @"32";

//正在使用其他应用
NSString * const JiaJiaRobotOperationStateUsedApp = @"33";

//正在看动画
NSString * const JiaJiaRobotOperationStateWatching = @"01";

//正在学知识
NSString * const JiaJiaRobotOperationStateSduty = @"02";

//正在听音乐
NSString * const JiaJiaRobotOperationStateMusic = @"03";

//正在听故事
NSString * const JiaJiaRobotOperationStateStory = @"04";




