//
//  DCHandPickViewController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCHandPickViewController.h"

// Controllers
#import "DCNavigationController.h"
#import "DCGoodsSetViewController.h"
#import "DCCommodityViewController.h"
#import "DCshopCarViewController.h"
#import "DCGoodDetailViewController.h"
#import "DCGMScanViewController.h"
#import "WKwebViewController.h"
// Models
#import "DCGridItem.h"
#import "DCRecommendItem.h"
#import "DCRecommendList.h"
#import "DCHomeGoodsItem.h"

// Views
#import "DCNavSearchBarView.h"
#import "DCHomeTopToolView.h"
/* cell */
#import "DCGoodsCountDownCell.h" //倒计时商品
#import "DCNewWelfareCell.h"     //新人福利
#import "DCGoodsHandheldCell.h"  //掌上专享
#import "DCExceedApplianceCell.h"//不止
#import "DCGoodsYouLikeCell.h"   //猜你喜欢商品
#import "DCGoodsGridCell.h"      //10个选项
#import "DCHomeGoodsCollectionViewCell.h"

#import "DCRecommendCollectionViewCell.h"
/* head */
#import "DCSlideshowHeadView.h"  //轮播图
#import "DCCountDownHeadView.h"  //倒计时标语
#import "DCYouLikeHeadView.h"    //猜你喜欢等头部标语
/* foot */
#import "DCTopLineFootView.h"    //热点
#import "DCOverFootView.h"       //结束
#import "DCScrollAdFootView.h"   //底滚动广告
#import "GoodsRequestTool.h"
// Vendors
#import "DCHomeRefreshGifHeader.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
// Categories
#import "UIBarButtonItem+DCBarButtonItem.h"
// Others
#import "CDDTopTip.h"
#import "NetworkUnit.h"
#import "UNHomeData.h"

#import "DCSearchToolView.h"
@interface DCHandPickViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    DCSearchToolView * searchToolView ;

}
/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 10个属性 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *gridItem;
/* 推荐商品属性 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *youLikeItem;

/* 推荐商品列表 */
@property (strong , nonatomic)NSMutableArray<DCRecommendList*> *homeRecommendList;
/* 顶部工具View */
@property (nonatomic, strong) DCHomeTopToolView *topToolView;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

/* banner 数据*/
@property (strong , nonatomic)NSArray *bannerArray;
@property (strong , nonatomic)NSMutableArray *bannerImagesArray;

@property (strong , nonatomic)NSArray *tagStyleArray;
@property (strong , nonatomic)NSArray *tuijianArray;
@property (strong , nonatomic)NSArray *middleImageArray;

@property (strong , nonatomic)NSArray <DCHomeGoodsItem *>*goodesTuijianArray;


@end
/* cell */
static NSString *const DCGoodsCountDownCellID = @"DCGoodsCountDownCell";
static NSString *const DCNewWelfareCellID = @"DCNewWelfareCell";
static NSString *const DCGoodsHandheldCellID = @"DCGoodsHandheldCell";
static NSString *const DCGoodsYouLikeCellID = @"DCGoodsYouLikeCell";
static NSString *const DCGoodsGridCellID = @"DCGoodsGridCell";
static NSString *const DCExceedApplianceCellID = @"DCExceedApplianceCell";

static NSString *const DCHomeGoodsCollectionViewCellID = @"DCHomeGoodsCollectionViewCell";


static NSString *const DCRecommendCollectionViewCellID = @"DCRecommendCollectionViewCell";

/* head */
static NSString *const DCSlideshowHeadViewID = @"DCSlideshowHeadView";
static NSString *const DCCountDownHeadViewID = @"DCCountDownHeadView";
static NSString *const DCYouLikeHeadViewID = @"DCYouLikeHeadView";
/* foot */
static NSString *const DCTopLineFootViewID = @"DCTopLineFootView";
static NSString *const DCOverFootViewID = @"DCOverFootView";
static NSString *const DCScrollAdFootViewID = @"DCScrollAdFootView";

@implementation DCHandPickViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, ScreenW, ScreenH - DCBottomTabH-iphoneXTabbarHieght);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        [_collectionView registerClass:[DCGoodsCountDownCell class] forCellWithReuseIdentifier:DCGoodsCountDownCellID];
        [_collectionView registerClass:[DCGoodsHandheldCell class] forCellWithReuseIdentifier:DCGoodsHandheldCellID];
        [_collectionView registerClass:[DCGoodsYouLikeCell class] forCellWithReuseIdentifier:DCGoodsYouLikeCellID];
        [_collectionView registerClass:[DCGoodsGridCell class] forCellWithReuseIdentifier:DCGoodsGridCellID];
        [_collectionView registerClass:[DCExceedApplianceCell class] forCellWithReuseIdentifier:DCExceedApplianceCellID];
        [_collectionView registerClass:[DCNewWelfareCell class] forCellWithReuseIdentifier:DCNewWelfareCellID];

        
//        [_collectionView registerClass:[DCRecommendCollectionViewCell class] forCellWithReuseIdentifier:DCRecommendCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DCRecommendCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DCRecommendCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DCHomeGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DCHomeGoodsCollectionViewCellID];

        [_collectionView registerClass:[DCTopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID];
        [_collectionView registerClass:[DCOverFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID];
        [_collectionView registerClass:[DCScrollAdFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCScrollAdFootViewID];
        
        [_collectionView registerClass:[DCYouLikeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID];
        [_collectionView registerClass:[DCSlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID];
        [_collectionView registerClass:[DCCountDownHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCountDownHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getbanner];
    
    [self setUpBase];
    
//    [self setUpNavTopView];
    
    [self setUpGoodsData];
    
    [self setUpScrollToTopView];
    
    [self setUpGIFRrfresh];
    
    [self getNetwork];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.collectionView.backgroundColor = DCBGColor;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 获取网络
- (void)getNetwork
{
    if ([[NetworkUnit getInternetStatus] isEqualToString:@"notReachable"]) { //网络
        [CDDTopTip showTopTipWithMessage:@"您现在暂无可用网络"];
    }
}

#pragma mark - 设置头部header
- (void)setUpGIFRrfresh
{
    self.collectionView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpRecData)];
}

#pragma mark - 刷新
- (void)setUpRecData
{
    WEAKSELF
    [DCSpeedy dc_callFeedback]; //触动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //手动延迟
        [self getbanner];

    });
}

#pragma mark - 加载数据
- (void)setUpGoodsData
{
    _gridItem = [DCGridItem mj_objectArrayWithFilename:@"GoodsGrid.plist"];
    _youLikeItem = [DCRecommendItem mj_objectArrayWithFilename:@"HomeHighGoods.plist"];
}

#pragma mark - 滚回顶部
- (void)setUpScrollToTopView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 110-iphoneXTop, 40, 40);
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[DCHomeTopToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了首页扫一扫");
        DCGMScanViewController *dcGMvC = [DCGMScanViewController new];
        [weakSelf.navigationController pushViewController:dcGMvC animated:YES];
    };
    _topToolView.rightItemClickBlock = ^{
        NSLog(@"点击了首页分类");
        DCCommodityViewController *dcComVc = [DCCommodityViewController new];
        [weakSelf.navigationController pushViewController:dcComVc animated:YES];
    };
    _topToolView.rightRItemClickBlock = ^{
        NSLog(@"点击了首页购物车");
        DCshopCarViewController *shopCarVc = [DCshopCarViewController new];
        shopCarVc.isTabBar = YES;
        shopCarVc.title = @"购物车";
        [weakSelf.navigationController pushViewController:shopCarVc animated:YES];
    };
    _topToolView.searchButtonClickBlock = ^{
        NSLog(@"点击了首页搜索");
    };
    _topToolView.voiceButtonClickBlock = ^{
        NSLog(@"点击了首页语音");
    };
    [self.view addSubview:_topToolView];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return  _homeRecommendList.count +2;
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { //10属性
        return 10;
    }
//    if ( section == 3) { //广告福利  倒计时  掌上专享
//        return 1;
//    }
    
    for (int i=0; i<_homeRecommendList.count; i++) {
        
        if (section == i+1) {
            return _homeRecommendList[i].data.count ;
        }
    }
    
    if (section == _homeRecommendList.count+1) { //推荐
        return _goodesTuijianArray.count;
    }
  
//    if (section == 2) { //猜你喜欢
//        return _youLikeItem.count;
//    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {//10
        DCGoodsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsGridCellID forIndexPath:indexPath];
        cell.gridItem = _gridItem[indexPath.row];
        gridcell = cell;
        
    }
    else if (indexPath.section == _homeRecommendList.count+1) {//
        DCHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCHomeGoodsCollectionViewCellID forIndexPath:indexPath];
       
        if (_goodesTuijianArray.count >indexPath.row) {
            [cell  loadNewUI:_goodesTuijianArray[indexPath.row]];
        }

        gridcell = cell;
    }
//    else if (indexPath.section == _homeRecommendList.count+2) {//
//        DCGoodsCountDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsCountDownCellID forIndexPath:indexPath];
//        gridcell = cell;
//    }
//    else if (indexPath.section == 3) {//掌上专享
////        DCExceedApplianceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCExceedApplianceCellID forIndexPath:indexPath];
////        cell.goodExceedArray = GoodsRecommendArray;
////        gridcell = cell;
//
//    }
//    else if (indexPath.section == 3) {//推荐
//        DCGoodsHandheldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsHandheldCellID forIndexPath:indexPath];
//        NSArray *images = GoodsHandheldImagesArray;
//        cell.handheldImage = images[indexPath.row];
//        gridcell = cell;
//    }
    else {//猜你喜欢
        DCRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCRecommendCollectionViewCellID forIndexPath:indexPath];
//        cell.lookSameBlock = ^{
//            NSLog(@"点击了第%zd商品的找相似",indexPath.row);
//        };
        cell.RecommendItem = [_homeRecommendList[indexPath.section-1].data objectAtIndex:indexPath.row];
        gridcell = cell;
    }
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            DCSlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID forIndexPath:indexPath];
            
            headerView.imageGroupArray = [self bannerImages];   ///banner 轮播图
            headerView.backIndex = ^(NSInteger index) {
                
                if (index==100) {
                    [self searchButtonClick];
                }else if (index==101){
                    self.tabBarController.selectedIndex = 1 ;
                }else{
                    NSDictionary *diction =  [_bannerArray objectAtIndex:index];
                    WKwebViewController * webVC = [[WKwebViewController alloc]init];
                    webVC.webUrl = [diction objectForKey:@"url"];
                    webVC.headTitle = [diction objectForKey:@"name"] ;
                    [self.navigationController pushViewController:webVC animated:YES];
                    
                }
              
            };
            reusableview = headerView;
          
    
            
//        }else if (indexPath.section == 2){
////            DCCountDownHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCountDownHeadViewID forIndexPath:indexPath];
////            reusableview = headerView;
        }
        else if (indexPath.section >= 1 ){

            if (self.homeRecommendList !=nil) {
                if (indexPath.section < self.homeRecommendList.count+1) {
                    DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
                    //            [headerView.likeImageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs7.gomein.net.cn/T1WudvBm_T1RCvBVdK.png"]];
                    
                    [headerView.likeImageView setImageWithURL:[NSURL URLWithString:_homeRecommendList[indexPath.section-1].image] placeholderImage:nil];
                    reusableview = headerView;
                    headerView.backTouch = ^{
                        [self pushNextVCWithURL:_homeRecommendList[indexPath.section-1].url andName:_homeRecommendList[indexPath.section-1].name];
                    };
                }else{
                    
                    DCCountDownHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCountDownHeadViewID forIndexPath:indexPath];
                    reusableview = headerView;
                }
             
            }else{
                DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
                //            [headerView.likeImageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs7.gomein.net.cn/T1WudvBm_T1RCvBVdK.png"]];
                
                [headerView.likeImageView setImageWithURL:[NSURL URLWithString:_homeRecommendList[indexPath.section-1].image] placeholderImage:nil];
                reusableview = headerView;
                headerView.backTouch = ^{
                    [self pushNextVCWithURL:_homeRecommendList[indexPath.section-1].url andName:_homeRecommendList[indexPath.section-1].name];
                };
            }
           
        }
//        else if (indexPath.section == 2){
//            DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
//            [headerView.likeImageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs5.gomein.net.cn/T16LLvByZj1RCvBVdK.png"]];
//            reusableview = headerView;
//        }

    }
    if (kind == UICollectionElementKindSectionFooter) {
//        if (indexPath.section == 0) {
////            DCTopLineFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID forIndexPath:indexPath];
////            reusableview = footview;
////        }else if (indexPath.section == 3){
////            DCScrollAdFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCScrollAdFootViewID forIndexPath:indexPath];
////            reusableview = footerView;
//
//        }else
//            if (indexPath.section == 2) {
//            DCOverFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID forIndexPath:indexPath];
//            reusableview = footview;
//        }
    }

    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//9宫格组
        return CGSizeMake(ScreenW/5 , ScreenW/5 + DCMargin);
    }
//    if (indexPath.section == 1) {//广告
//        return CGSizeMake(ScreenW, 180);
//    }
////    if (indexPath.section == 2) {//计时
////        return CGSizeMake(ScreenW, 150);
////    }
//    if (indexPath.section == 3) {//掌上
//        return CGSizeMake(ScreenW,ScreenW * 0.35 + 120);
//    }
//    if (indexPath.section == 3) {//推荐组
//        return [self layoutAttributesForItemAtIndexPath:indexPath].size;
//    }
    if (indexPath.section >= 1 && indexPath.section<_homeRecommendList.count+1) {//猜你喜欢
        return CGSizeMake((ScreenW - 4)/2, 138);
    }else if ( indexPath.section==_homeRecommendList.count+1){
        return CGSizeMake((ScreenW - 4)/2, 230);

    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            layoutAttributes.size = CGSizeMake(ScreenW, ScreenW * 0.38);
        }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
            layoutAttributes.size = CGSizeMake(ScreenW * 0.5, ScreenW * 0.24);
        }else{
            layoutAttributes.size = CGSizeMake(ScreenW * 0.25, ScreenW * 0.35);
        }
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return CGSizeMake(ScreenW, 188+SCREEN_top); //图片滚动的宽高
    }else  if (section == 1) {
        return CGSizeMake(ScreenW, 100); //图片滚动的宽高
    }
     else if (  section == 2) {
        return CGSizeMake(ScreenW, 40);  //推荐适合的宽高
     }if (section>=1 && section < _tuijianArray.count+1) {
         return CGSizeMake(ScreenW, 165); //
     }else if (section == _tuijianArray.count+1){
         return CGSizeMake(ScreenW, 50);  //
     }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return CGSizeMake(ScreenW, 180);  //Top头条的宽高
//    }
//    if (section == 3) {
//        return CGSizeMake(ScreenW, 80); // 滚动广告
//    }
//    if (section == 2) {
//        return CGSizeMake(ScreenW, 40); // 结束
//    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section >= 1) ? 4 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section >= 1) ? 4 : 0;
}

-(void)pushNextVCWithURL:(NSString*)URL andName:(NSString*)name{
    
    if ([URL hasPrefix:@"http"]) {
        WKwebViewController * webVC = [[WKwebViewController alloc]init];
        webVC.webUrl = URL ;
        webVC.headTitle = name ;
        [self.navigationController pushViewController:webVC animated:YES];
    }else  if ([URL hasPrefix:@"category://"]){
        DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init] ;
        goodSetVc.goodsCateID = [[URL componentsSeparatedByString:@"//"] lastObject];
        [self.navigationController pushViewController:goodSetVc animated:YES];
    }else if ([URL hasPrefix:@"goods:"]){
        DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
        dcVc.goodID = [[URL componentsSeparatedByString:@"//"] lastObject];
        [self.navigationController pushViewController:dcVc animated:YES];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//10
        DCGridItem* item = _gridItem[indexPath.row];
        [self pushNextVCWithURL:item.url andName:item.name];
    }else
        if (indexPath.section >= 1){
        
            if (indexPath.section == _homeRecommendList.count+1) {
                
              DCHomeGoodsItem * item =   self.goodesTuijianArray[indexPath.row];

                DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
                dcVc.goodID = item.identity;
                [self.navigationController pushViewController:dcVc animated:YES];
                return ;
            }
            
          DCHomeRecommend * recom =  [_homeRecommendList[indexPath.section-1].data objectAtIndex:indexPath.row];
            if ([recom.url hasPrefix:@"goods://"]) {
                NSString *str1 = [recom.url substringFromIndex:8];//截取
                NSLog(@"=goods==%@",str1);
                
                DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
                dcVc.goodID = str1;
                [self.navigationController pushViewController:dcVc animated:YES];

            }else if ([recom.url hasPrefix:@"http"]){
                NSLog(@"=http==%@",recom.url);
                WKwebViewController * webVC = [[WKwebViewController alloc]init];
                webVC.webUrl = recom.url ;
                webVC.headTitle = recom.title ;
                [self.navigationController pushViewController:webVC animated:YES];

            }else{
                [UIHelper showUpMessage:@"数据错误，请重试！"];
            }
            
            
            return ;
        DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
        dcVc.goodTitle = _youLikeItem[indexPath.row].name;
        dcVc.goodPrice = _youLikeItem[indexPath.row].price;
        dcVc.goodSubtitle = _youLikeItem[indexPath.row].info;
        dcVc.shufflingArray = _youLikeItem[indexPath.row].images;
        dcVc.goodImageView = _youLikeItem[indexPath.row].image;
        
        [self.navigationController pushViewController:dcVc animated:YES];
    }else if (indexPath.section == 3){
        
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;//判断回到顶部按钮是否隐藏
    _topToolView.hidden = (scrollView.contentOffset.y < 0) ? YES : NO;//判断顶部工具View的显示和隐形
    
    if (scrollView.contentOffset.y > DCNaviH) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWTOPTOOLVIEW object:nil];
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDETOPTOOLVIEW object:nil];
    }
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - 消息
- (void)messageItemClick
{

}

#pragma  mark  - 数据请求

-(void)getbanner{
    
     __weak typeof(self) myself = self ;
    [UNHomeData getBanner:^(id  _Nonnull responseObject) {
        [self loadNewDataOfViewWithArray:(NSArray *)responseObject];
    } error:^(NSDictionary * _Nonnull error) {
        
    }];
}

-(void)loadNewDataOfViewWithArray:(NSArray*)array{
    
    NSLog(@"=array==%@==",array) ;
    for (NSDictionary*diction in array) {
        NSArray * a = [diction objectForKey:@"data"];
        NSString*  type = diction[@"type"] ;
        if (a && type) {
            switch ([type intValue]) {
                case 1:
                {
                    self.bannerArray = (NSArray *)a;
                }
                    break;
                case 2:
                {
                    self.tagStyleArray = (NSArray *)a;
                    _gridItem = [DCGridItem mj_objectArrayWithKeyValuesArray:a];
                }
                    break;
                case 3:
                {
                    self.tuijianArray = (NSArray *)a;
                    self.homeRecommendList = [DCRecommendList mj_objectArrayWithKeyValuesArray:a];
                    
                    [self.collectionView.mj_header endRefreshing];
                    
                    for (int i=0; i<self.homeRecommendList.count; i++) {
                        NSArray * ar = [self.homeRecommendList objectAtIndex:i].data;
                        NSMutableArray * arr = [DCHomeRecommend mj_objectArrayWithKeyValuesArray:ar];
                        [self.homeRecommendList objectAtIndex:i].data = arr;
                    }
                    
                }
                    break;
                case 4:
                {
//                    self.goodesTuijianArray = (NSArray *)a;
                    self.goodesTuijianArray = [DCHomeGoodsItem mj_objectArrayWithKeyValuesArray:a];

                }
                    break;
                default:
                    break;
            }
            
        }
        }
     
    [self.collectionView reloadData];

}

-(NSArray *)bannerImages{
    
    if (!_bannerImagesArray) {
        _bannerImagesArray = [NSMutableArray array];
    }
    if (_bannerImagesArray.count) {
        [_bannerImagesArray removeAllObjects];
    }
    
    for (int i=0; i<_bannerArray.count; i++) {
        [_bannerImagesArray addObject:[[_bannerArray objectAtIndex:i] objectForKey:@"image"] ];
    }
    
    if (_bannerImagesArray.count<1) {
        return  GoodsHomeSilderImagesArray ;
    }
    
    return _bannerImagesArray;
}


#pragma mark - 请求 推荐列表
-(void)getGoodListwithID{
    WEAKSELF;
    [GoodsRequestTool getHomeGoodsCateWithsuccess:^(id  _Nonnull responseObject) {
        self.homeRecommendList = [DCRecommendList mj_objectArrayWithKeyValuesArray:responseObject];
        
        [weakSelf.collectionView.mj_header endRefreshing];

        for (int i=0; i<self.homeRecommendList.count; i++) {
            NSArray * ar = [self.homeRecommendList objectAtIndex:i].data;
            NSMutableArray * a = [DCHomeRecommend mj_objectArrayWithKeyValuesArray:ar];
            [self.homeRecommendList objectAtIndex:i].data = a;
        }
        
        [self.collectionView reloadData];
        
    } fail:^(NSDictionary * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];

    }];
    
}

#pragma mark - 搜索点击
- (void)searchButtonClick
{
    NSLog(@"===");
    if (!searchToolView) {
        searchToolView = [[DCSearchToolView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    [searchToolView.searchBar becomeFirstResponder];
    searchToolView.hidden = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:searchToolView];
    WEAKSELF
    searchToolView.backText = ^(NSString * _Nonnull text) {
        
        DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init];
        goodSetVc.goodPlisName = @"ClasiftyGoods.plist";
        goodSetVc.searchName = text;
        [weakSelf.navigationController pushViewController:goodSetVc animated:YES];
    };
}
@end
