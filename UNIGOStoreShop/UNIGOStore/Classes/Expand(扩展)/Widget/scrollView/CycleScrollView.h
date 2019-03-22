//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by teelab2 on 15-01-01.
//  Copyright (c) 2014年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (nonatomic , readonly) UIScrollView *scrollView;

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@property(strong,nonatomic) UIPageControl *pageControl;    ////page页码

-(void)configContentViewsWithView:(UIView*)contentView;

#pragma mark  只有2个封面时  直接添加到本view上
-(void)configContentViewsWithTWOView:(NSArray*)contentTwoViews;

-(void)stopAnimationDuration;  ///停止滚动

-(void)fireAnimationDuration;  ///开始滚动
@end
