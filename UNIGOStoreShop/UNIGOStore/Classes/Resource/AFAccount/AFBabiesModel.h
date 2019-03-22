//
//  AFBabiesModel.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/25.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFBabyData;
@class AFBabyAvatar;
@class AFCtx;

@interface AFBabiesModel : NSObject<NSCoding>

@property (nonatomic, strong) NSArray *data;

@end

@interface AFBabyData : NSObject<NSCoding>

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) AFBabyAvatar *avatar;
@property (nonatomic, copy) NSString *readable_gender;
@property (nonatomic, assign) CGFloat identifier;
@property (nonatomic, copy) NSString *dob;
@property (nonatomic, assign) CGFloat age;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) AFCtx *ctx;

@end

@interface AFBabyAvatar : NSObject<NSCoding>

@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;

//@property (nonatomic, strong) UIImage *smallImage;
//@property (nonatomic, strong) UIImage *largeImage;
//@property (nonatomic, strong) UIImage *mediumImage;

@end

@interface AFCtx : NSObject<NSCoding>

@property (nonatomic, copy) NSString *readable_relation;
@property (nonatomic, copy) NSString *relation;
//@property (nonatomic, assign) CGFloat is_admin;
@property (nonatomic, copy) NSString *alias;


@end

