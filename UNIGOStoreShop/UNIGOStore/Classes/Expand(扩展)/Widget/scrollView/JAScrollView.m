//
//  JAScrollView.m
//  AutomobileAccessories
//
//  Created by JA on 2017/3/17.
//  Copyright © 2017年  All rights reserved.
//  微信交流:YuChuan0525
//  简书地址：http://www.jianshu.com/p/036be4a428e9
//

#import "JAScrollView.h"
#import "UIImageView+AFNetworking.h"

typedef enum : NSUInteger {
    ScrollViewDirectionRight,           /** 向右滚动*/
    ScrollViewDirectionLeft,            /** 向左滚动*/
}ScrollViewDirection;
@interface JAScrollView() <UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *dataArry;
@property (nonatomic,assign)NSInteger currentImageIndex;
//@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)CGFloat lastContentOffset;
@property (nonatomic,assign)ScrollViewDirection scrollDirection;
@property (nonatomic,strong)NSMutableArray *imageViews;
@property (nonatomic,assign)NSInteger imageCount;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)BOOL isLoacl;//

@end
@implementation JAScrollView
@synthesize color_currentPageControl = _color_currentPageControl ,
color_pageControl = _color_pageControl ;
- (instancetype)initWithFrame:(CGRect)frame
                   withImages:(NSArray *)images
                withIsRunloop:(BOOL)isRunloop
                withIsLoacl:(BOOL)isLoacl
                    withBlock:(ImageViewClick)block;
{
   self = [super initWithFrame:frame];
    if (self) {
        self.dur = 5.0;
        self.imageCount =  images ? images.count : 0;
        self.isRunloop = isRunloop;
        self.dataArry = images;
        self.click = block;
        self.isLoacl = isLoacl;
        if (isLoacl) {
            [self loadLocalBaseView];
        }else{
            [self loadBaseView];
        }
    }
    return self;
}

- (void)loadBaseView
{
  
    self.currentImageIndex =0;
//    self.currentPage = 1;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
//    for (int i = 0; i < 100; i ++) {
//        [self.dataArry addObject:RGBColor(arc4random()%255, arc4random()%255, arc4random()%255)];
//    }
    
    for (int i = 0; i<3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        NSString *imge_str ;

        if (i == 0 && self.dataArry!=nil && self.dataArry.count > 1) {
            imge_str = [NSString getImageUrlWithCover:[[self.dataArry objectAtIndex:self.dataArry.count - 1] objectForKey:@"cover"]];
        }
        if (i == 1 && self.dataArry!=nil && self.dataArry.count > 0) {
            imge_str = [NSString getImageUrlWithCover:[[self.dataArry objectAtIndex:0] objectForKey:@"cover"]];
        }
        if (i == 2 && self.dataArry !=nil && self.dataArry.count > 1) {
            imge_str = [NSString getImageUrlWithCover:[[self.dataArry objectAtIndex:1] objectForKey:@"cover"]];

        }
        
        [imageView setImageWithURL:[NSURL URLWithString:imge_str] placeholderImage:[UIImage imageNamed:@"默认图片"]];

        [self.imageViews addObject:imageView];
        [self.scrollView addSubview:imageView];
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
       
    
}

- (void)loadLocalBaseView
{
    self.currentImageIndex =0;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    for (int i = 0; i<3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        UIImage *imge_str ;
        
        if (i == 0 && self.dataArry!=nil && self.dataArry.count > 1) {
            imge_str = [self.dataArry objectAtIndex:self.dataArry.count - 1] ;
        }
        if (i == 1 && self.dataArry!=nil && self.dataArry.count > 0) {
            imge_str = [self.dataArry objectAtIndex:0] ;
        }
        if (i == 2 && self.dataArry !=nil && self.dataArry.count > 1) {
            imge_str = [self.dataArry objectAtIndex:1] ;
        }
        [imageView setImage:imge_str];
        [self.imageViews addObject:imageView];
        [self.scrollView addSubview:imageView];
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
//    [self addSubview:self.pageControl];
//    
//    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor] ;

}

#pragma mark -
#pragma mark - set
- (void)setImageCount:(NSInteger)imageCount
{
    _imageCount = imageCount;
    if (_imageCount < 1) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    self.scrollView.scrollEnabled = YES;
    self.pageControl.numberOfPages = imageCount ;
    CGSize size = [self.pageControl sizeForNumberOfPages:imageCount];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, 20);
    self.pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-10) ;
    self.pageControl.currentPage = 0;
}

-(void)setIsLoacl:(BOOL)isLoacl{
    
    _isLoacl = isLoacl;
}
- (void)setIsRunloop:(BOOL)isRunloop
{
    _isRunloop = isRunloop;
    if (isRunloop) {
        [self createTimer];
    }
}
- (void)setColor_pageControl:(UIColor *)color_pageControl
{
    _color_pageControl = color_pageControl ;
    
    self.pageControl.pageIndicatorTintColor = _color_pageControl ;
}
//default whiteColor
- (UIColor *)color_pageControl
{
    if (!_color_pageControl) {
        _color_pageControl = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return _color_pageControl ;
}

- (void)setColor_currentPageControl:(UIColor *)color_currentPageControl
{
    _color_currentPageControl = color_currentPageControl ;
    
    self.pageControl.currentPageIndicatorTintColor = _color_currentPageControl ;
}
//default darkGrayColor
- (UIColor *)color_currentPageControl
{
    if (!_color_currentPageControl) {
        _color_currentPageControl = [UIColor HexString:@"fc4349"] ;
    }
    return _color_currentPageControl ;
}
//create timer
- (void)createTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.dur target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
         [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark -
#pragma mark - action
- (void)timerAction{
    if (_imageCount <= 1) return ;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width *2, 0) animated:YES];
    [self performSelector:@selector(reloadImage) withObject:nil afterDelay:.35];

}
- (void)tapAction{
    if (self.click) {
        self.click(_currentImageIndex);
    }
}
#pragma mark -
#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadImage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"开始拖拽");
        [self.timer invalidate];
        self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self createTimer];
}
- (void)reloadImage
{
    if ( self.imageViews.count == 0 || self.dataArry.count == 0) {
        return;
    }
    NSInteger leftImageIndex,rightImageIndex ;
    CGPoint offset = [_scrollView contentOffset] ;
    
    if (offset.x > self.frame.size.width)
    { //  向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.dataArry.count ;
    }
    else if(offset.x < self.frame.size.width)
    { //  向左滑动
        _currentImageIndex = (_currentImageIndex + self.dataArry.count - 1) % self.dataArry.count ;
    }
    
    UIImageView * centerImageView = [self.imageViews objectAtIndex:1];
    UIImageView *leftImageView = [self.imageViews objectAtIndex:0];
    UIImageView *rightImageView = [self.imageViews objectAtIndex:2];
    
//    centerImageView.backgroundColor =self.dataArry[_currentImageIndex];
    
    [self loadImageView:centerImageView withIndex:_currentImageIndex];
    
    //  重新设置左右图片
    leftImageIndex  = (_currentImageIndex + self.dataArry.count - 1) % self.dataArry.count ;
    rightImageIndex = (_currentImageIndex + 1) % self.dataArry.count ;
//    leftImageView.backgroundColor  = self.dataArry[leftImageIndex] ;
//    rightImageView.backgroundColor = self.dataArry[rightImageIndex] ;
    [self loadImageView:leftImageView withIndex:leftImageIndex];
    [self loadImageView:rightImageView withIndex:rightImageIndex];

    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = self.currentImageIndex;
}

-(UIImageView*)loadImageView:(UIImageView*)image withIndex:(NSInteger)index{

    if (_isLoacl) {
//        NSString* imge_str = [self.dataArry objectAtIndex:index] ;
        [image setImage:[self.dataArry objectAtIndex:index]];
    }else{
        
        NSString* imge_str = [NSString getImageUrlWithCover:[[self.dataArry objectAtIndex:index] objectForKey:@"cover"]];
        [image setImageWithURL:[NSURL URLWithString:imge_str] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    }
   
    return image;
    
}

#pragma mark -
#pragma mark -懒加载
- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _scrollView.contentSize = CGSizeMake(self.frame.size.width *3, self.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    
    }
    return _scrollView;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init] ;
        _pageControl.pageIndicatorTintColor = self.color_pageControl ;
        _pageControl.currentPageIndicatorTintColor = self.color_currentPageControl ;
        
    }
    
    return _pageControl ;
}
- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}
@end
