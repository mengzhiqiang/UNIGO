//
//  CustomRefreshHeader.m
//  SmartDevice
//
//  Created by admin on 16/6/3.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "CustomRefreshHeader.h"

@implementation CustomRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<=59; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1X00%d.png", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<=59; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1X00%d.png", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
