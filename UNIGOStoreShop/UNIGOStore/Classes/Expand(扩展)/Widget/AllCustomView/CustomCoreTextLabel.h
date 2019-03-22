//
//  CustomCoreTextLabel.h
//  TextCoreText
//
//  Created by mzq on 15/6/4.
//  Copyright (c) 2015年 mzq. All rights reserved.
//
/*
 
 类似html页面可以点击任意字符
 
 */

#import <UIKit/UIKit.h>

#import <CoreText/CoreText.h>

@protocol CustomTextPushDelegate <NSObject>

-(void)pushTextOfMark:(NSString*)mark;

@end


@interface CustomCoreTextLabel : UIView
@property(strong,nonatomic) NSString *string;
@property(strong,nonatomic) NSString *code;

@property(strong,nonatomic) NSArray *string_array;
@property(strong,nonatomic) id<CustomTextPushDelegate>Delagate;

@property(strong,nonatomic) NSMutableArray *rang_array;


@property(assign,nonatomic) CTFrameRef frame_ref;

-(void)characterAttribute:(NSString*)str;

-(void)characterAttribute:(NSString*)str withCode:(NSString*)code;


@end
