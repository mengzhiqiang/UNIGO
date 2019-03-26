//
//  AFAccount.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/9/19.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AFAccountNim;
@class AFAccountAvatar;
@class AFAccountConfig;
@class AFAppCover;
@class UNClient;

@interface AFAccount : NSObject<NSCoding>


@property (nonatomic, copy) NSString  * refresh_expires_time;  ////刷新到期
@property (nonatomic, copy) NSString  * refresh_token;          ///刷新token
@property (nonatomic, copy) NSString  * access_token;            /// 授权token
@property (nonatomic, copy) NSString  * expires_time;            ///授权到期


@property (nonatomic, strong) UNClient *client;

@end

@interface UNClient : NSObject<NSCoding>

@property (nonatomic, assign) int identifier;

@property (nonatomic, assign) int   sex;
@property (nonatomic, copy) NSString  * phone;
@property (nonatomic, copy) NSString  * nickname;
@property (nonatomic, copy) NSString  * truename;
@property (nonatomic, copy) NSString  * birthday;
@property (nonatomic, copy) NSString  * headimgurl;

@property (nonatomic, assign) int  create_time;

@property (nonatomic, strong) AFAccountNim *nim;
@property (nonatomic, strong) AFAccountAvatar *avatar;
@property (nonatomic, strong) AFAccountConfig *config;


@end


@interface AFAccountAvatar : NSObject<NSCoding>

@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;

@end

@interface AFAccountNim : NSObject<NSCoding>

@property (nonatomic, copy) NSString *accid;
@property (nonatomic, copy) NSString *token;

@end

@interface AFAccountConfig : NSObject<NSCoding>

@property (nonatomic, strong)AFAppCover *app_cover;

@end

@interface AFAppCover : NSObject<NSCoding>

@property (nonatomic, copy) NSString *tiny;
@property (nonatomic, copy) NSString *original;

@end
