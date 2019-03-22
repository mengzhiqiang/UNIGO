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


@interface AFAccount : NSObject<NSCoding>

@property (nonatomic, assign) CGFloat mobile_verify;
@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) int useID;

@property (nonatomic, copy) NSString  * mobile;
@property (nonatomic, copy) NSString  * nickName;
@property (nonatomic, copy) NSString  * tureName;
@property (nonatomic, copy) NSString  * old;
@property (nonatomic, copy) NSString  * sex;
//@property (nonatomic, copy) NSString  * tureName;

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
