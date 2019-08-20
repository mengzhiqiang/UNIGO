//
//  DCSlideshowHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCSlideshowHeadView.h"

// Controllers

// Models

// Views

// Vendors
#import <SDCycleScrollView.h>
// Categories

// Others

@interface DCSlideshowHeadView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@property (strong , nonatomic)UIButton *searchButton;


@end

@implementation DCSlideshowHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}


-(UIButton *)searchButton{
    
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _searchButton.frame = CGRectMake(50, 20+iphoneXTop, SCREEN_WIDTH - 80, 40);
        
        [_searchButton setTitle:@"搜索商品" forState:0];
        [_searchButton setTitleColor:[UIColor grayColor] forState:0];
        _searchButton.titleLabel.font = PFR14Font;
        [_searchButton setImage:[UIImage imageNamed:@"group_home_search_gray"] forState:0];
        [_searchButton adjustsImageWhenHighlighted];
        _searchButton.tag = 100 ;
        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, _searchButton.width/2-20, 0, 0);
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, _searchButton.width/2-30, 0, 0);
        [_searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton draCirlywithColor:[UIColor lightGrayColor] andRadius:15];
        _searchButton.backgroundColor = [UIColor HexString:@"f2f2f2"];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_top)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:_searchButton];
        [self addSubview:view];
        
        UIButton * styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        styleButton.frame = CGRectMake(5, 20+iphoneXTop, 40, 40);
        [styleButton setImage: [UIImage imageNamed:@"ptgd_icon_fenlei"] forState:UIControlStateNormal];
        [styleButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        styleButton.tag = 101 ;

        [view addSubview:styleButton];
    }
    
    return  _searchButton ;
}

-(void)searchButtonClick:(UIButton*)sender{
    if (_backIndex) {
        _backIndex(sender.tag);
    }
}

- (void)setUpUI
{
    [self.searchButton draCirlywithColor:nil andRadius:self.searchButton.height/2]; ;
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SCREEN_top, ScreenW, 188) delegate:self placeholderImage:nil];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:_cycleScrollView];
}

- (void)setImageGroupArray:(NSArray *)imageGroupArray
{
    _imageGroupArray = imageGroupArray;
//    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"default_160"];
    if (imageGroupArray.count == 0) return;
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;

}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    if (_backIndex) {
        _backIndex(index);
    }
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Setter Getter Methods


@end
