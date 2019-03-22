//
//  AFToolTipOfHead.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 17/4/12.
//  Copyright © 2017年 Auric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFToolTipOfHead : NSObject

//单例
+ (instancetype)sharedInstance;

/*
    title  提示内容 
    color  背景颜色
 */
-(void)addViewOfHeadWithTitle:(NSString*)title BackColor:(UIColor*)color;

@end
