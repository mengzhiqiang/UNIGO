//
//  DCGoodBaseViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCGoodBaseViewController.h"

// Controllers
#import "DCFootprintGoodsViewController.h"
#import "DCShareToViewController.h"
#import "DCToolsViewController.h"
#import "DCFeatureSelectionViewController.h"
#import "DCFillinOrderViewController.h"
#import "LogInmainViewController.h"
#import "UNStoreViewController.h"
#import "DCOrderDetailViewController.h"
// Models

// Views
#import "DCLIRLButton.h"

#import "DCDetailShufflingHeadView.h" //头部轮播
#import "DCDetailGoodReferralCell.h"  //商品标题价格介绍
#import "DCDetailShowTypeCell.h"      //种类
#import "DCShowTypeOneCell.h"
#import "DCShowTypeTwoCell.h"
#import "DCShowTypeThreeCell.h"
#import "DCShowTypeFourCell.h"
#import "DCDetailServicetCell.h"      //服务
#import "DCDetailLikeCell.h"          //猜你喜欢
#import "DCDetailOverFooterView.h"    //尾部结束
#import "DCDetailPartCommentCell.h"   //部分评论
#import "DCDeatilCustomHeadView.h"    //自定义头部
// Vendors
#import "AddressPickerView.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "HttpRequestToken.h"
// Categories
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
#import "DCShopCar.h"

// Others

@interface DCGoodBaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WKNavigationDelegate>

@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) WKWebView *webView;

@property(strong,nonatomic)DCShopCarModel * selectShopCarModel;
/* 选择地址弹框 */
@property (strong , nonatomic)AddressPickerView *adPickerView;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
/* 通知 */
@property (strong ,nonatomic) id dcObj;

@property (assign ,nonatomic) CGFloat  oldPoint;
@property (assign ,nonatomic) CGFloat  NewPoint;

@end

//header
static NSString *DCDetailShufflingHeadViewID = @"DCDetailShufflingHeadView";
static NSString *DCDeatilCustomHeadViewID = @"DCDeatilCustomHeadView";
//cell
static NSString *DCDetailGoodReferralCellID = @"DCDetailGoodReferralCell";

static NSString *DCShowTypeOneCellID = @"DCShowTypeOneCell";
static NSString *DCShowTypeTwoCellID = @"DCShowTypeTwoCell";
static NSString *DCShowTypeThreeCellID = @"DCShowTypeThreeCell";
static NSString *DCShowTypeFourCellID = @"DCShowTypeFourCell";

static NSString *DCDetailServicetCellID = @"DCDetailServicetCell";
static NSString *DCDetailLikeCellID = @"DCDetailLikeCell";
static NSString *DCDetailPartCommentCellID = @"DCDetailPartCommentCell";
//footer
static NSString *DCDetailOverFooterViewID = @"DCDetailOverFooterView";


static NSString *lastNum_;
static NSMutableArray *lastSeleArray_;

@implementation DCGoodBaseViewController

#pragma mark - LazyLoad
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.frame = self.view.bounds;
        _scrollerView.contentSize = CGSizeMake(ScreenW, (ScreenH - 50) * 2);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.scrollEnabled = NO;
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0; //Y
        layout.minimumInteritemSpacing = 0; //X
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH - 50);
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.scrollerView addSubview:_collectionView];
        
        //注册header
        [_collectionView registerClass:[DCDetailShufflingHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDetailShufflingHeadViewID];
        [_collectionView registerClass:[DCDeatilCustomHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDeatilCustomHeadViewID];
        //注册Cell
        [_collectionView registerClass:[DCDetailGoodReferralCell class] forCellWithReuseIdentifier:DCDetailGoodReferralCellID];
        [_collectionView registerClass:[DCShowTypeOneCell class] forCellWithReuseIdentifier:DCShowTypeOneCellID];
        [_collectionView registerClass:[DCShowTypeTwoCell class] forCellWithReuseIdentifier:DCShowTypeTwoCellID];
        [_collectionView registerClass:[DCShowTypeThreeCell class] forCellWithReuseIdentifier:DCShowTypeThreeCellID];
        [_collectionView registerClass:[DCShowTypeFourCell class] forCellWithReuseIdentifier:DCShowTypeFourCellID];
        [_collectionView registerClass:[DCDetailLikeCell class] forCellWithReuseIdentifier:DCDetailLikeCellID];
        [_collectionView registerClass:[DCDetailPartCommentCell class] forCellWithReuseIdentifier:DCDetailPartCommentCellID];
        [_collectionView registerClass:[DCDetailServicetCell class] forCellWithReuseIdentifier:DCDetailServicetCellID];
        //注册Footer
        [_collectionView registerClass:[DCDetailOverFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCDetailOverFooterViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //间隔
        
    }
    return _collectionView;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.frame = CGRectMake(0,ScreenH , ScreenW, ScreenH - 50);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(DCTopNavH, 0, 0, 0);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        [self.scrollerView addSubview:_webView];

        _webView.navigationDelegate = self;
    }
    return _webView;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 1000.0;" // WKWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
}

#pragma mark - LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    
    [self setUpViewScroller];
    
    [self setUpGoodsWKWebView];
    
//    [self setUpSuspendView];
    
    [self acceptanceNote];

    
}

-(void)setGoodsInfomation:(NSDictionary *)goodsInfomation{
    _goodsInfomation = goodsInfomation;
    [self setLastSeleArrayNewData:_goodsInfomation];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

}

-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//
//    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:SHOPITEMSELECTBACK object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:SELECTCARTORBUY object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:SHAREALTERVIEW object:nil];

}

#pragma mark - initialize
- (void)setUpInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = DCBGColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.scrollerView.backgroundColor = self.view.backgroundColor;

    //初始化
    lastSeleArray_ = [NSArray array];
    lastNum_ = 0;
    
}

#pragma mark - 接受通知
- (void)acceptanceNote
{
    //分享通知
    WEAKSELF
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SHAREALTERVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSLog(@"==%@",note.object);
        [weakSelf selfAlterViewback];
        if ([note.object isEqualToString:@"3"]) {
            [weakSelf setUpAlterViewControllerWith:[DCShareToViewController new] WithDistance:300 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
        }
        [weakSelf selfpopRootVC:note.object];
        
    }];
    

    //父类加入购物车，立即购买通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SELECTCARTORBUY object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
//        if (lastSeleArray_.count != 0) {
//            if ([note.userInfo[@"buttonTag"] isEqualToString:@"2"]) { //加入购物车（父类）
//
//                [weakSelf addShopCars];
//
//            }else if ([note.userInfo[@"buttonTag"] isEqualToString:@"3"]){//立即购买（父类）
//                [weakSelf buyNowWithData];
//
//                DCOrderDetailViewController *dcFillVc = [DCOrderDetailViewController new];
//                [weakSelf.navigationController pushViewController:dcFillVc animated:YES];
//            }
//
//        }else {
        
            DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
//            dcNewFeaVc.goodImageView = weakSelf.goodImageView;
//            dcNewFeaVc.goodsInfomation = self.goodsInfomation ;

            dcNewFeaVc.lastNum = lastNum_;
            dcNewFeaVc.goodsInfomation =  weakSelf.goodsInfomation ;
            dcNewFeaVc.goodImageView =  weakSelf.goodImageView;
            dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
            
            
            [weakSelf setUpAlterViewControllerWith:dcNewFeaVc WithDistance:ScreenH * 0.8 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:YES WithFlipEnable:YES];
//        }
    }];

    //选择Item通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSArray *selectArray = note.userInfo[@"Array"];
        NSString *num = note.userInfo[@"Num"];
        NSString *buttonTag = note.userInfo[@"Tag"];

        lastNum_ = num;
        lastSeleArray_ = selectArray;
        
        [weakSelf.collectionView reloadData];
        
        if ([buttonTag isEqualToString:@"0"]) { //加入购物车
            
            [weakSelf addShopCars];
            
        }else if ([buttonTag isEqualToString:@"1"]) { //立即购买
            
            [weakSelf buyNowWithData];
            DCOrderDetailViewController *dcFillVc = [DCOrderDetailViewController new];
            [weakSelf.navigationController pushViewController:dcFillVc animated:YES];
        }
        
    }];
}
-(NSDictionary* )priceOfNowSelect{
    
    if (!((lastSeleArray_.count)>=1)) {
        return nil;
    }
    
    NSArray *result = [lastSeleArray_ sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        return [obj1 compare:obj2]; //升序
    }];
    NSString * string ;
    for (int i=0; i<result.count; i++) {
        if (i==0) {
            string = result[0];
        }else{
            string = [NSString stringWithFormat:@"%@_%@",string,result[i]];
        }
    }
    NSLog(@"result=%@",string);
    NSDictionary * dic = [[_goodsInfomation objectForKey:@"goodsSpecResult"] objectForKey:string];
    return dic ;
}

-(void)setShufflingArray:(NSArray *)shufflingArray{
    _shufflingArray = shufflingArray ;
    
    [self.collectionView reloadData];
}
#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 100, 40, 40);
}

#pragma mark - 记载图文详情

-(void)setDetailUrl:(NSString *)detailUrl{
    _detailUrl = detailUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_detailUrl]];
    [self.webView loadRequest:request];
    
}
- (void)setUpGoodsWKWebView
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_detailUrl]];
    [self.webView loadRequest:request];
    
    //下拉返回商品详情View
    UIView *topHitView = [[UIView alloc] init];
    topHitView.frame = CGRectMake(0, -35, ScreenW, 35);
    DCLIRLButton *topHitButton = [DCLIRLButton buttonWithType:UIButtonTypeCustom];
    topHitButton.imageView.transform = CGAffineTransformRotate(topHitButton.imageView.transform, M_PI); //旋转
    [topHitButton setImage:[UIImage imageNamed:@"Details_Btn_Up"] forState:UIControlStateNormal];
    [topHitButton setTitle:@"下拉返回商品详情" forState:UIControlStateNormal];
    topHitButton.titleLabel.font = PFR12Font;
    [topHitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [topHitView addSubview:topHitButton];
    topHitButton.frame = topHitView.bounds;
    
//    [self.webView.scrollView addSubview:topHitView];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;  /// 5评论  6推荐
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section ==1) {
        if (_goodsInfomation[@"active_note"]) {
            return 2;
        }
    }
    return (section == 2 ) ? 1 : 1;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    DCUserInfo *userInfo = UserInfoData;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DCDetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCDetailGoodReferralCellID forIndexPath:indexPath];
            if (_goodsInfomation) {
                cell.goodTitleLabel.text = _goodTitle;
                cell.goodPriceLabel.text = [NSString stringWithFormat:@"¥ %@",_goodPrice];
                cell.goodSaleCountLabel.text =  [NSString stringWithFormat:@"销量：%@",_goodsInfomation[@"sales"]];
                if (_goodsInfomation[@"market_price"]) {
                    NSString *textStr = [NSString stringWithFormat:@"¥ %@",_goodsInfomation[@"market_price"]];
                    //中划线
                    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
                    // 赋值
                    cell.goodMarketPriceLabel.attributedText = attribtStr;
                    
                    if ([_goodsInfomation[@"market_price"] floatValue]<=[_goodPrice floatValue]) {
                        cell.goodMarketPriceLabel.hidden = YES;
                    }else{
                        cell.goodMarketPriceLabel.hidden = NO;
                        
                    }
                }else{
                    cell.goodMarketPriceLabel.hidden = YES;
                }
                
                cell.goodSubtitleLabel.text = _goodSubtitle;
            }
            
//            [DCSpeedy dc_setUpLabel:cell.goodTitleLabel Content:_goodTitle IndentationFortheFirstLineWith:cell.goodPriceLabel.font.pointSize * 2];
            WEAKSELF
            cell.shareButtonClickBlock = ^{
                [weakSelf setUpAlterViewControllerWith:[DCShareToViewController new] WithDistance:300 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
            };
            gridcell = cell;
        }

    }else if (indexPath.section == 1 ){
        if (indexPath.section == 1) {
            DCShowTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCShowTypeOneCellID forIndexPath:indexPath];

            if (indexPath.row==0) {
                NSString *result = [NSString stringWithFormat:@"%@ %@件",[[self priceOfNowSelect] objectForKey:@"spec_name"],lastNum_];
                cell.leftTitleLable.text = (lastSeleArray_.count == 0) ? @"点击" : @"已选";
                cell.contentLabel.text = (lastSeleArray_.count == 0) ? @"请选择该商品属性" : result;
                cell.isHasindicateButton = YES;

            }else{
                cell.leftTitleLable.text = @"活动";
                cell.contentLabel.text = _goodsInfomation[@"active_note"];
                cell.isHasindicateButton = NO;
            }
           
            gridcell = cell;
        }else{
//            if (indexPath.row == 0) {
//                DCShowTypeTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCShowTypeTwoCellID forIndexPath:indexPath];
//                cell.contentLabel.text = (![[DCObjManager dc_readUserDataForKey:@"isLogin"] isEqualToString:@"1"]) ? @"预送地址" : userInfo.defaultAddress;//地址
//                gridcell = cell;
//            }else{
//                DCShowTypeThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCShowTypeThreeCellID forIndexPath:indexPath];
//                gridcell = cell;
////            }
        }
    }else if (indexPath.section == 2){
//        DCDetailServicetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCDetailServicetCellID forIndexPath:indexPath];
//        NSArray *btnTitles = @[@"以旧换新",@"可选增值服务"];
//        NSArray *btnImages = @[@"detail_xiangqingye_yijiuhuanxin",@"ptgd_icon_zengzhifuwu"];
//        NSArray *titles = @[@"以旧换新再送好礼",@"为商品保价护航"];
//        [cell.serviceButton setTitle:btnTitles[indexPath.row] forState:UIControlStateNormal];
//        [cell.serviceButton setImage:[UIImage imageNamed:btnImages[indexPath.row]] forState:UIControlStateNormal];
//        cell.serviceLabel.text = titles[indexPath.row];
//        if (indexPath.row == 0) {//分割线
//            [DCSpeedy dc_setUpLongLineWith:cell WithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.4] WithHightRatio:0.6];
//        }
//        gridcell = cell;
            DCShowTypeFourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCShowTypeFourCellID forIndexPath:indexPath];
        if ([_goodsInfomation objectForKey:@"shop_name"]) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",[_goodsInfomation objectForKey:@"shop_name"]];
            cell.hintLabel.text = [_goodsInfomation objectForKey:@"link"];
        }
           [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString: [_goodsInfomation objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"MG_payVoucher"]];
        cell.isHasindicateButton = NO;
            gridcell = cell;
    }else if (indexPath.section == 4){
        DCDetailPartCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCDetailPartCommentCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor orangeColor];
        gridcell = cell;
    }else if (indexPath.section == 5){
        DCDetailLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCDetailLikeCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            DCDetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDetailShufflingHeadViewID forIndexPath:indexPath];
            headerView.shufflingArray = _shufflingArray;
            reusableview = headerView;
        }else if (indexPath.section == 5){
            DCDeatilCustomHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCDeatilCustomHeadViewID forIndexPath:indexPath];
            reusableview = headerView;
        }
    }else if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 5) {
            DCDetailOverFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCDetailOverFooterViewID forIndexPath:indexPath];
            reusableview = footerView;
        }else{
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
            footerView.backgroundColor = DCBGColor;
            reusableview = footerView;
        }
    }
    return reusableview;
    
    ;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //商品详情
        return (indexPath.row == 0) ? CGSizeMake(ScreenW, [DCSpeedy dc_calculateTextSizeWithText:_goodTitle WithTextFont:16 WithMaxW:ScreenW - DCMargin * 6].height + [DCSpeedy dc_calculateTextSizeWithText:_goodPrice WithTextFont:20 WithMaxW:ScreenW - DCMargin * 6].height + [DCSpeedy dc_calculateTextSizeWithText:_goodSubtitle WithTextFont:12 WithMaxW:ScreenW - DCMargin * 6].height + DCMargin * 4) : CGSizeMake(ScreenW, 35);
    }else if (indexPath.section == 1){//商品属性选择
        return CGSizeMake(ScreenW, 45);
    }else if (indexPath.section == 2){//商品快递信息
        return CGSizeMake(ScreenW, 60);
    }else if (indexPath.section == 3){//商品保价
        return CGSizeMake(ScreenW , 60);
    }else if (indexPath.section == 4){//商品评价部分展示
        return CGSizeMake(ScreenW, 270);
    }else if (indexPath.section == 5){//商品猜你喜欢
        return CGSizeMake(ScreenW, (ScreenW / 3 + 60) * 2 + 20);
    }else{
        return CGSizeZero;
    }
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (section == 0) ?  CGSizeMake(ScreenW, ScreenW) : ( section == 5) ? CGSizeMake(ScreenW, 30) : CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return (section == 5) ? CGSizeMake(ScreenW, 35) : CGSizeMake(ScreenW, DCMargin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self scrollToDetailsPage]; //滚动到详情页面
    }else if (indexPath.section == 2 ) {
        NSString * phone =  [_goodsInfomation objectForKey:@"link"] ;
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (indexPath.section == 1){ //属性选择
        if (indexPath.row==1) {
            return ;
        }
        NSArray * diction = [_goodsInfomation objectForKey:@"goodsSpecValue"] ;
//        NSLog(@"goodsSpecValue=== %@" , [[_goodsInfomation objectForKey:@"goodsSpecValue"] class]);
//        NSLog(@"goodsSpecValue=== %ld" ,diction.count);

        if (diction.count>=1) {
            DCFeatureSelectionViewController *dcFeaVc = [DCFeatureSelectionViewController new];
            dcFeaVc.lastNum = lastNum_;
            dcFeaVc.goodsInfomation = self.goodsInfomation ;
            dcFeaVc.goodImageView = _goodImageView;
            dcFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
            
            [self setUpAlterViewControllerWith:dcFeaVc WithDistance:ScreenH * 0.8 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:YES WithFlipEnable:YES];
            
        }else {
            [UIHelper showUpMessage:@"无可设置属性"];
        }
        
      
    }else if(indexPath.section == 3){
        
        NSString * phone =  [_goodsInfomation objectForKey:@"link"] ;
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}
#pragma mark - 视图滚动
- (void)setUpViewScroller{
    WEAKSELF
    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(YES);
            weakSelf.scrollerView.contentOffset = CGPointMake(0, ScreenH);
        } completion:^(BOOL finished) {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }];
    }];
    
//    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(NO);
//            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
//            self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        } completion:^(BOOL finished) {
//            [weakSelf.webView.scrollView.mj_header endRefreshing];
//        }];
//    }];
    self.webView.scrollView.delegate =self ;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)setLastSeleArrayNewData:(NSDictionary*)dictiaon{
    
    NSArray * aa = [dictiaon objectForKey:@"goodsSpecValue"];
    
    lastSeleArray_ = [NSMutableArray arrayWithCapacity:20];
    
    for (NSDictionary* d in aa) {

        NSArray * arr =[d objectForKey:@"list"];
        NSDictionary* dic = arr.firstObject;
        [lastSeleArray_ addObject: dic[@"spec_id"]] ;
    }
    lastNum_ = @"1" ;
    [_collectionView reloadData];
    
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.webView.scrollView) {
//        self.oldPoint = self.NewPoint;
        NSLog(@"===%f",scrollView.contentOffset.y);
        if (self.NewPoint>scrollView.contentOffset.y) {
            self.NewPoint = scrollView.contentOffset.y;
        }
        if (scrollView.contentOffset.y>0) {
            self.NewPoint = scrollView.contentOffset.y;
        }
    }
   
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == self.webView.scrollView) {
 
        if (_NewPoint<-100) {
            [UIView animateWithDuration:0.8 animations:^{
                !self.changeTitleBlock ? : self.changeTitleBlock(NO);
                self.scrollerView.contentOffset = CGPointMake(0, 0);
                //                self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
            }];
        }
    }
}




#pragma mark - 点击事件
#pragma mark - 更换地址
- (void)chageUserAdress
{
    if ([[HttpRequestToken getToken]length]<1) {
        LogInmainViewController *dcLoginVc = [LogInmainViewController new];
        [self presentViewController:dcLoginVc animated:YES completion:nil];
    }
    _adPickerView = [AddressPickerView shareInstance];
    [_adPickerView showAddressPickView];
    [self.view addSubview:_adPickerView];
    
    WEAKSELF
    _adPickerView.block = ^(NSString *province,NSString *city,NSString *district) {
        DCUserInfo *userInfo = UserInfoData;
        NSString *newAdress = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        if ([userInfo.defaultAddress isEqualToString:newAdress]) {
            return;
        }
        userInfo.defaultAddress = newAdress;
        [userInfo save];
        [weakSelf.collectionView reloadData];
    };
}

#pragma mark - 滚动到详情页面
- (void)scrollToDetailsPage
{
#warning 修改
//    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//        [[NSNotificationCenter defaultCenter]postNotificationName:SCROLLTODETAILSPAGE object:nil];
//    });
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    if (self.scrollerView.contentOffset.y > ScreenH) {
        [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }else{
        WEAKSELF
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }];
    }
    !_changeTitleBlock ? : _changeTitleBlock(NO);
}

#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    [self dismissViewControllerAnimated:YES completion:nil]; //以防有控制未退出
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
    WEAKSELF
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf selfAlterViewback];
    }];
}

#pragma mark 购物车
-(void)addShopCars{
    
    NSString *path = [API_HOST stringByAppendingString:goodsCart_add];
    
    NSMutableDictionary * pram = [NSMutableDictionary dictionary];
    
    [pram setObject:[_goodsInfomation objectForKey:@"id"] forKey:@"goods_id"];
    [pram setObject:[[self priceOfNowSelect] objectForKey:@"spec_id"] forKey:@"spec_id"];
    [pram setObject:lastNum_ forKey:@"cart_num"];
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    [HttpEngine requestPostWithURL:path params:pram isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        //        success(JSONDic);
        [UIHelper hiddenAlertWith:self.view];
        [self setUpWithAddSuccess];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [UIHelper hiddenAlertWith:self.view];

        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        
    }];
    
}

#pragma mark - 加入购物车成功
- (void)setUpWithAddSuccess
{
    
    [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
    
}


-(void)buyNowWithData{
    
    DCShopCar*shopCarModel = [DCShopCar sharedDataBase];
    
    if ([shopCarModel.buyList count]>0) {
        [shopCarModel.buyList removeAllObjects];
    }
    DCShopCarModel * iten = [[DCShopCarModel alloc]init];
    
    iten.name = [_goodsInfomation objectForKey:@"name"];
    iten.image = [_goodsInfomation objectForKey:@"image"];
    iten.price = [_goodsInfomation objectForKey:@"price"];
    iten.price = [[self priceOfNowSelect] objectForKey:@"price"];

    iten.cart_num = lastNum_;
    iten.stock = [_goodsInfomation objectForKey:@"stock"];
    iten.info = [_goodsInfomation objectForKey:@"image"];
    iten.isSelect = YES;
    iten.goods_id = [_goodsInfomation objectForKey:@"id"];
    iten.spec_name = [[self priceOfNowSelect] objectForKey:@"spec_name"];
    iten.spec_id = [[self priceOfNowSelect] objectForKey:@"spec_id"];
    
    [shopCarModel.buyList addObject:iten];
    

}


#pragma 退出界面
- (void)selfAlterViewback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selfpopRootVC:(NSString*)tag
{
    if ([tag intValue]==1) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        self.navigationController.tabBarController.selectedIndex = [tag intValue];
        [self.navigationController popToRootViewControllerAnimated:NO];

    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SHOPITEMSELECTBACK object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SELECTCARTORBUY object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SHAREALTERVIEW object:nil];

}

@end
