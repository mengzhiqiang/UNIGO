//
//  DCGoodsSetViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 strong. All rights reserved.
//
typedef void(^backSection) (NSDictionary*diction);

#import "DCGoodsSetViewController.h"

// Controllers
#import "DCFootprintGoodsViewController.h"
#import "DCGoodDetailViewController.h"
// Models
#import "DCRecommendItem.h"
// Views
#import "DCNavSearchBarView.h"
#import "DCCustionHeadView.h"
#import "DCSwitchGridCell.h"
#import "DCListGridCell.h"
#import "DCColonInsView.h"
#import "DCSildeBarView.h"
#import "DCHoverFlowLayout.h"
// Vendors
#import <MJExtension.h>
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
// Categories

// Others
#import "GoodsRequestTool.h"
#import "DCSearchToolView.h"
@interface DCGoodsSetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    DCSearchToolView * searchToolView ;

}
/* scrollerVew */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 搜索 */
@property (strong , nonatomic)UIView *topSearchView;
/* 搜索按钮 */
@property (strong , nonatomic)UIButton *searchButton;
/* 切换视图按钮 */
@property (strong , nonatomic)UIButton *switchViewButton;
/* 自定义头部View */
@property (strong , nonatomic)DCCustionHeadView *custionHeadView;
/* 具体商品数据 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *setItem;
/* 冒号工具View */
@property (strong , nonatomic)DCColonInsView *colonView;
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isSwitchGrid;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
/* 足迹按钮 */
@property (strong , nonatomic)UIButton *footprintButton;


@property (assign , nonatomic)int sort;   //排序 1综合2销量3新品4价格 默认为1综合
@property (assign , nonatomic)int sortStatus;  //排序 1升序 2降序 默认为1升序

@end

static CGFloat _lastContentOffset;

static NSString *const DCCustionHeadViewID = @"DCCustionHeadView";
static NSString *const DCSwitchGridCellID = @"DCSwitchGridCell";
static NSString *const DCListGridCellID = @"DCListGridCell";

@implementation DCGoodsSetViewController

#pragma mark  - 防止警告
- (NSString *)goodPlisName
{
    return nil;
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCHoverFlowLayout *layout = [DCHoverFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[DCCustionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID]; //头部View
        [_collectionView registerClass:[DCSwitchGridCell class] forCellWithReuseIdentifier:DCSwitchGridCellID];//cell
        [_collectionView registerClass:[DCListGridCell class] forCellWithReuseIdentifier:DCListGridCellID];//cell
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.barTintColor == DCBGColor)return;
    self.navigationController.navigationBar.barTintColor = DCBGColor;
    
    if (_searchName) {
        [_searchButton setTitle:_searchName forState:0];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setUpColl];
    
    [self setUpData];
    
//    [self setUpSuspendView];
    
    backSection  backsect = ^(NSDictionary*diction){
        NSLog(@"diciton==%@",diction);
    };
    
    backsect(nil);
    
    [self testblock:^(NSDictionary *diction) {
        NSLog(@"diciton==%@",diction);

    }];
    
    
}

-(void)testblock:(backSection)backs{
    
    backs(@{@"123":@"456"});
}
#pragma mark - 搜索点击
- (void)searchButtonClick
{
    NSLog(@"===");
    if (!searchToolView) {
        searchToolView = [[DCSearchToolView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    if (self.searchName) {
        searchToolView.searchBar.text = self.searchName ;
    }
    [searchToolView.searchBar becomeFirstResponder];
    searchToolView.hidden = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:searchToolView];
    WEAKSELF
    searchToolView.backText = ^(NSString * _Nonnull text) {
        weakSelf.searchName = text;
        [weakSelf getGoodListwithDiction:nil];

    };
}


#pragma mark - initialize
- (void)setUpColl
{
    // 默认列表视图
    _isSwitchGrid = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = DCBGColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - 加载数据
- (void)setUpData
{
    
    [self getGoodListwithDiction:nil];
}
#pragma mark - 导航栏
- (void)setUpNav
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
//    UIButton *button = [[UIButton alloc] init];
//    [button setImage:[UIImage imageNamed:@"flzq_nav_jiugongge"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"flzq_nav_list"] forState:UIControlStateSelected];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    [button addTarget:self action:@selector(switchViewButtonBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer];
    
    
    _topSearchView = [[UIView alloc] init];
    _topSearchView.backgroundColor = [UIColor whiteColor];
    _topSearchView.layer.cornerRadius = 16;
    [_topSearchView.layer masksToBounds];
    _topSearchView.frame = CGRectMake(50, 6, ScreenW - 110, 32);
    self.navigationItem.titleView = _topSearchView;
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"搜索商品" forState:0];
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:0];
    _searchButton.titleLabel.font = PFR13Font;
    [_searchButton setImage:[UIImage imageNamed:@"group_home_search_gray"] forState:0];
    [_searchButton adjustsImageWhenHighlighted];
    _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * DCMargin, 0, 0);
    _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, DCMargin, 0, 0);
    [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.frame = CGRectMake(0, 0, _topSearchView.dc_width - 2 * DCMargin, _topSearchView.dc_height);
    [_topSearchView addSubview:_searchButton];
    
   
}

#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 60, 40, 40);
    
    _footprintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_footprintButton];
    [_footprintButton addTarget:self action:@selector(footprintButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_footprintButton setImage:[UIImage imageNamed:@"ptgd_icon_zuji"] forState:UIControlStateNormal];
    _footprintButton.frame = CGRectMake(ScreenW - 50, ScreenH - 60, 40, 40);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _setItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCListGridCell *cell = nil;
    cell = (_isSwitchGrid) ? [collectionView dequeueReusableCellWithReuseIdentifier:DCListGridCellID forIndexPath:indexPath] : [collectionView dequeueReusableCellWithReuseIdentifier:DCSwitchGridCellID forIndexPath:indexPath];
    cell.youSelectItem = _setItem[indexPath.row];
    
    WEAKSELF
    if (_isSwitchGrid) { //列表Cell
        __weak typeof(cell)weakCell = cell;
        cell.colonClickBlock = ^{ // 冒号点击
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setUpColonInsView:weakCell];
            [strongSelf.colonView setUpUI]; // 初始化
            strongSelf.colonView.collectionBlock = ^{
                NSLog(@"点击了收藏%zd",indexPath.row);
            };
            strongSelf.colonView.addShopCarBlock = ^{
                NSLog(@"点击了加入购物车%zd",indexPath.row);
            };
            strongSelf.colonView.sameBrandBlock = ^{
                NSLog(@"点击了同品牌%zd",indexPath.row);
            };
            strongSelf.colonView.samePriceBlock = ^{
                NSLog(@"点击了同价格%zd",indexPath.row);
            };
        };
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        DCCustionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
        WEAKSELF
        headerView.backIndex = ^(NSDictionary *diction) {
            [weakSelf getGoodListwithDiction:diction];
        };

        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (_isSwitchGrid) ? CGSizeMake(ScreenW, 120) : CGSizeMake((ScreenW - 4)/2, (ScreenW - 4)/2 + 40);//列表、网格Cell
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 40); //头部
}

#pragma mark - 边间距属性默认为0
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
    
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (_isSwitchGrid) ? 0 : 4;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了商品第%zd",indexPath.row);
    
    DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
    dcVc.goodID = _setItem[indexPath.row].identifier ;
    dcVc.goodTitle = _setItem[indexPath.row].name;
    dcVc.goodPrice = _setItem[indexPath.row].price;
    dcVc.goodSubtitle = _setItem[indexPath.row].info;
    dcVc.shufflingArray = _setItem[indexPath.row].images;
    dcVc.goodImageView = _setItem[indexPath.row].image;
    
    [self.navigationController pushViewController:dcVc animated:YES];
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.colonView.dc_x = ScreenW;
    }completion:^(BOOL finished) {
        [weakSelf.colonView removeFromSuperview];
    }];
}


#pragma mark - 滑动代理
//开始滑动的时候记录位置
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _lastContentOffset = scrollView.contentOffset.y;
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y > _lastContentOffset){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.collectionView.frame = CGRectMake(0, 20, ScreenW, ScreenH - 20);
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.collectionView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH);
        self.view.backgroundColor = DCBGColor;
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;

    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.footprintButton.dc_y = (strongSelf.backTopButton.hidden == YES) ? ScreenH - 60 : ScreenH - 110;
    }];
    
}

#pragma mark - 冒号工具View
- (void)setUpColonInsView:(UICollectionViewCell *)cell
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //单列
        _colonView = [[DCColonInsView alloc] init];
        
    });
    [cell addSubview:_colonView];
    
    _colonView.frame = CGRectMake(cell.dc_width, 0, cell.dc_width - 120, cell.dc_height);
    
    [UIView animateWithDuration:0.5 animations:^{
        _colonView.dc_x = 120;
    }];
}

#pragma mark - 点击事件

#pragma mark - 切换视图按钮点击
- (void)switchViewButtonBarItemClick:(UIButton *)button
{
    button.selected = !button.selected;
    _isSwitchGrid = !_isSwitchGrid;
    
    [_colonView removeFromSuperview];
    
    [self.collectionView reloadData];
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
#pragma mark - 商品浏览足迹
- (void)footprintButtonClick
{
    [self setUpAlterViewControllerWith:[DCFootprintGoodsViewController alloc] WithDistance:ScreenW * 0.4];
}

#pragma mark - 商品筛选
- (void)filtrateButtonClick
{
    [DCSildeBarView dc_showSildBarViewController];
}

#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance
{
    XWDrawerAnimatorDirection direction = XWDrawerAnimatorDirectionRight;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = YES;
    [self xw_presentViewController:vc withAnimator:animator];
    WEAKSELF
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf selfAlterViewback];
    }];
}

#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 请求网络数据

-(void)getGoodListwithDiction:(NSDictionary*)pram{
    
//    NSDictionary * diction = @{@"cateId":@"5"};
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction addEntriesFromDictionary:pram];
    if (_goodsCateID) {
        [diction setObject:_goodsCateID forKey:@"cateId"];
    }
    if (_searchName) {
        [diction setObject:_searchName forKey:@"search"]; 
    }

    [GoodsRequestTool getGoodsCateWithPram:diction success:^(id  _Nonnull responseObject) {
        self.setItem = [DCRecommendItem mj_objectArrayWithKeyValuesArray:responseObject];
        [self.collectionView reloadData];
        
    } fail:^(NSDictionary * _Nonnull error) {
        
    }];
    
}

@end
