//
//  Unification.m
//  ALPHA
//
//  Created by teelab2 on 14-9-17.
//  Copyright (c) 2014年 ALPHA. All rights reserved.
//

#import "Unification.h"
#import "ExtendClass.h"
@implementation Unification
static Unification *commUnifi = nil;



- (id)init{
    
    if (self = [super init]) {
        
        [self loadStatesOfCode];
    }
    return self;
}



-(void)loadStatesOfCode{
    
    _token_Status = [[NSDictionary  alloc]initWithObjectsAndKeys:@"手机号码未注册",@"user_not_found",@"帐号或密码不正确",@"invalid_credentials",@"密码过期",@"token_expired",@"密码无效",@"token_invalid",@"密码不正确",@"token_not_provided", nil];
    
    _account_Status = [[NSDictionary  alloc]initWithObjectsAndKeys:@"账户已存在",@"account_exists",@"短信验证失败",@"invalid_credentials",@"短信验证码已过期",@"sms_code_expired", nil];

    _password_Status = [[NSDictionary  alloc]initWithObjectsAndKeys:@"(重置密码)短信验证失败",@"invalid_credentials",@"(修改密码)旧密码输入不正确",@"invalid_credentials",@"短信验证码已过期",@"sms_code_expired",@"新旧密码相同,请重试",@"require_different_password",@"找不到用户！",@"user_not_found", nil];
    
    _baby_Status = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"没有找到宝贝",@"baby_not_found",@"机器人没有找到宝贝",@"baby_robot_not_found",@"当前用户无绑定任何宝贝信息",@"user_baby_not_found", nil];

    [_baby_Status  addEntriesFromDictionary:_token_Status];
    _account_robot_Status = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"机器人找不到帐号",@"account_robot_not_found", nil];
    [_account_robot_Status  addEntriesFromDictionary:_baby_Status];
    

    _robot_Status = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"机器人当前绑定的账户与宝贝账户不一致，解绑失效。",@"guid_not_match",@"验证码无效",@"invalid_binding_code",@"绑定失败",@"binding_service_unavailable",@"找不到宝贝信息！",@"baby_guid_not_found",@"机器人和手机必须连接相同的Wi-Fi！",@"ssid_not_match",@"机器人已被其他用户绑定",@"robot_already_binded",@"机器人找不到帐号",@"account_robot_not_found",nil];
    [_robot_Status addEntriesFromDictionary:_baby_Status];
    
    
    _Item_Status = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"机器人不属于该用户",@"robot_not_match",@"找不到对应的媒体",@"item_not_found",@"找不到对应的机器人",@"robot_not_found",@"找不到对应的机器人操作",@"robot_command_not_found", nil];
    [_Item_Status  addEntriesFromDictionary:_token_Status];

    
    _HelpMe_Status = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"机器人不属于该用户",@"robot_not_match",@"找不到对应的命令",@"speaker_order_not_found",@"找不到对应的机器人",@"robot_not_found",@"找不到对应的机器人操作",@"robot_command_not_found", nil];
    [_HelpMe_Status  addEntriesFromDictionary:_token_Status];

    
    
}




/**************************************************************
 ** 功能:     获取单例
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareUnification{
    if (!commUnifi) {
        commUnifi = [[Unification alloc] init];
    }
    return commUnifi;
}

@end
