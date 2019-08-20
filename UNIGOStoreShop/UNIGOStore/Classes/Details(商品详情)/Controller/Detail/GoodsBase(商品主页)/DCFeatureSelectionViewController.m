//
//  DCFeatureSelectionViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "DCFeatureSelectionViewController.h"

// Controllers
#import "DCFillinOrderViewController.h"
// Models
#import "DCFeatureItem.h"
#import "DCFeatureTitleItem.h"
#import "DCFeatureList.h"
// Views
#import "PPNumberButton.h"
#import "DCFeatureItemCell.h"
#import "DCFeatureHeaderView.h"
#import "DCCollectionHeaderLayout.h"
#import "DCFeatureChoseTopCell.h"
// Vendors
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "UIViewController+XWTransition.h"
// Categories

// Others

#define NowScreenH ScreenH * 0.8

@interface DCFeatureSelectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate,PPNumberButtonDelegate,UITableViewDelegate,UITableViewDataSource>

/* contionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray <DCFeatureItem *> *featureAttr;
/* 选择属性 */
@property (strong , nonatomic)NSMutableArray *seleArray;
/* 商品选择结果Cell */
@property (weak , nonatomic)DCFeatureChoseTopCell *cell;

@end

static NSInteger num_;

static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";
static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";
static NSString *const DCFeatureChoseTopCellID = @"DCFeatureChoseTopCell";
@implementation DCFeatureSelectionViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCCollectionHeaderLayout *layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = DCMargin;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, DCMargin, 0, DCMargin);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[DCFeatureChoseTopCell class] forCellReuseIdentifier:DCFeatureChoseTopCellID];
    }
    return _tableView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpFeatureAlterView];
    
    [self setUpBase];
    
    [self setUpBottonView];
}
- (void)viewWillLayoutSubviews {
    self.view.frame = CGRectMake(self.view.frame.origin.x, ScreenH*0.2, ScreenW, ScreenH*0.8);

}
#pragma mark - initialize

-(void)setGoodsInfomation:(NSDictionary *)goodsInfomation{
    _goodsInfomation = goodsInfomation;
    
    self.goodsSpecValue = [goodsInfomation objectForKey:@"goodsSpecValue"];
}
-(void)setGoodsSpecValue:(NSDictionary *)goodsSpecValue{
    _goodsSpecValue = goodsSpecValue;
    
    if (_featureAttr.count>0) {
        [_featureAttr removeAllObjects];
        _featureAttr = nil;
    }
    if (!_featureAttr) {
        _featureAttr = [NSMutableArray array];
    }
    
    for (NSDictionary*dic in goodsSpecValue) {
        DCFeatureItem * item = [[DCFeatureItem alloc ]init];
        item.title = [dic objectForKey:@"name"];
        
        item.listKeys = [NSMutableArray array];
        item.listValue = [NSMutableArray array];

        for (NSDictionary*d in [dic objectForKey:@"list"]) {
            [item.listKeys addObject:[d objectForKey:@"spec_name"] ];
            [item.listValue addObject:[d objectForKey:@"spec_id"] ];
        }
          [_featureAttr addObject:item];
    }
    
//    NSArray * keys_array = [goodsSpecValue allKeys];
//    for (NSString *title in keys_array) {
//        DCFeatureItem * item = [[DCFeatureItem alloc ]init];
//        NSDictionary * d = [goodsSpecValue objectForKey:title];
//        item.title = title;
//        item.listKeys = [d allKeys];
//        item.listValue = [d allValues];
//        [_featureAttr addObject:item];
//    }
    
//    [self.tableView reloadData];

}

- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    _featureAttr = [DCFeatureItem mj_objectArrayWithFilename:@"ShopItem.plist"]; //数据
    self.tableView.frame = CGRectMake(0, 0, ScreenW, 100);
    self.tableView.rowHeight = 100;
    self.collectionView.frame = CGRectMake(0, self.tableView.dc_bottom ,ScreenW , NowScreenH - 200);

    
    if (_lastSeleArray.count == 0){
        _seleArray = [@[] mutableCopy];

        for (NSInteger i = 0; i < _featureAttr.count; i++) {
            DCFeatureItem * item  = _featureAttr[i];
            for (NSInteger j = 0; j < item.listKeys.count; j++) {
                _featureAttr[i].index =  10;
                [self.collectionView reloadData];
            }
            [_seleArray addObject: [item.listValue objectAtIndex:0]];

        }

      return;
    }
    for (NSString *str in _lastSeleArray) {//反向遍历（赋值）
        for (NSInteger i = 0; i < _featureAttr.count; i++) {
            DCFeatureItem * item  = _featureAttr[i];
            for (NSInteger j = 0; j < item.listKeys.count; j++) {
                if ([ item.listValue[j] isEqualToString:str]) {
//                    _featureAttr[i].list[j].isSelect = YES;
                    _featureAttr[i].index = j + 10;
                    [self.collectionView reloadData];
                }
            }
        }
    }
    
    
   
    

}

#pragma mark - 底部按钮
- (void)setUpBottonView
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonH = 50;
    CGFloat buttonW = ScreenW / titles.count;
    CGFloat buttonY = NowScreenH - buttonH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttton setTitle:titles[i] forState:0];
        buttton.backgroundColor = (i == 0) ? [UIColor orangeColor] : [UIColor redColor];
        CGFloat buttonX = buttonW * i;
        buttton.tag = i;
        buttton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.view addSubview:buttton];
        [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"数量";
    numLabel.font = PFR14Font;
    [self.view addSubview:numLabel];
    numLabel.frame = CGRectMake(DCMargin, NowScreenH - 90, 50, 35);
    
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), numLabel.dc_y, 110, numLabel.dc_height)];
    numberButton.shakeAnimation = YES;
    numberButton.minValue = 1;
    numberButton.inputFieldFont = 23;
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
    numberButton.currentNumber = num_;
    numberButton.delegate = self;
    
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        num_ = num;
    };
    [self.view addSubview:numberButton];
}

#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {//未选择全属性警告
        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [self dismissFeatureViewControllerWithTag:button.tag];
    
}

#pragma mark - 弹出弹框
- (void)setUpFeatureAlterView
{
    XWInteractiveTransitionGestureDirection direction = XWInteractiveTransitionGestureDirectionDown;
    WEAKSELF
    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf dismissFeatureViewControllerWithTag:100];
        }];
   
    } edgeSpacing:0];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCFeatureChoseTopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCFeatureChoseTopCellID forIndexPath:indexPath];
    _cell = cell;
    
    cell.goodPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[_goodsInfomation objectForKey:@"price"]];

    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {
        cell.chooseAttLabel.textColor = [UIColor redColor];
        cell.chooseAttLabel.text = @"选择类型";
    }else {
        NSDictionary * dic = [self priceOfNowSelect];
        cell.chooseAttLabel.textColor = [UIColor darkGrayColor];
//        NSString *attString = (_seleArray.count == _featureAttr.count) ? [_seleArray componentsJoinedByString:@"，"] : [_lastSeleArray componentsJoinedByString:@"，"];
        cell.chooseAttLabel.text = [NSString stringWithFormat:@"已选属性：%@",[dic objectForKey:@"spec_name"]];
        cell.goodPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[dic objectForKey:@"price"]];

    }
    
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:_goodImageView]];
    WEAKSELF
    cell.crossButtonClickBlock = ^{
        [weakSelf dismissFeatureViewControllerWithTag:100];
    };
    return cell;
}

-(NSDictionary* )priceOfNowSelect{
    
    NSArray * array = _seleArray;
    if (_seleArray.count>0) {
    }else{
        array = _lastSeleArray ;
    }
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    return dic;
}

#pragma mark - 退出当前界面
- (void)dismissFeatureViewControllerWithTag:(NSInteger)tag
{
    WEAKSELF

    [UIView animateWithDuration:0.5 animations:^{
        self.view.top = ScreenH ;
        
//        if (![weakSelf.cell.chooseAttLabel.text isEqualToString:@"选择类型"]) {//当选择全属性才传递出去
//
//            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//                if (weakSelf.seleArray.count == 0) {
//                    NSMutableArray *numArray = [NSMutableArray arrayWithArray:weakSelf.lastSeleArray];
//                    NSDictionary *paDict = @{
//                                             @"Tag" : [NSString stringWithFormat:@"%zd",tag],
//                                             @"Num" : [NSString stringWithFormat:@"%zd",num_],
//                                             @"Array" : numArray
//                                             };
//                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:SHOPITEMSELECTBACK object:nil userInfo:dict];
//                }else{
//                    NSDictionary *paDict = @{
//                                             @"Tag" : [NSString stringWithFormat:@"%zd",tag],
//                                             @"Num" : [NSString stringWithFormat:@"%zd",num_],
//                                             @"Array" : weakSelf.seleArray
//                                             };
//                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:SHOPITEMSELECTBACK object:nil userInfo:dict];
//                }
//            });
//        }
    }];
    
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        if (![weakSelf.cell.chooseAttLabel.text isEqualToString:@"选择类型"]) {//当选择全属性才传递出去
            
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                if (weakSelf.seleArray.count == 0) {
                    NSMutableArray *numArray = [NSMutableArray arrayWithArray:weakSelf.lastSeleArray];
                    NSDictionary *paDict = @{
                                             @"Tag" : [NSString stringWithFormat:@"%zd",tag],
                                             @"Num" : [NSString stringWithFormat:@"%zd",num_],
                                             @"Array" : numArray
                                             };
                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
                    [[NSNotificationCenter defaultCenter]postNotificationName:SHOPITEMSELECTBACK object:nil userInfo:dict];
                }else{
                    NSDictionary *paDict = @{
                                             @"Tag" : [NSString stringWithFormat:@"%zd",tag],
                                             @"Num" : [NSString stringWithFormat:@"%zd",num_],
                                             @"Array" : weakSelf.seleArray
                                             };
                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
                    [[NSNotificationCenter defaultCenter]postNotificationName:SHOPITEMSELECTBACK object:nil userInfo:dict];
                }
            });
        }
    }];
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _featureAttr[section].listKeys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    
    DCFeatureItem * item = _featureAttr[indexPath.section] ;
    
    cell.attLabel.text = item.listKeys[indexPath.row] ;
    
    if (item.index == indexPath.row+10) {
        [cell isSelect:YES];
    }else{
        [cell isSelect:NO];

    }
    
//    cell.content = _featureAttr[indexPath.section].listKeys[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        headerView.headerLabel.text = _featureAttr[indexPath.section].title;
        return headerView;
    }else {

        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"====%ld===%ld",indexPath.section ,indexPath.row);
    //限制每组内的Item只能选中一个(加入质数选择)
    if (_featureAttr[indexPath.section].index == indexPath.row) {
        _featureAttr[indexPath.section].index= 0;
        
//        for (NSInteger j = 0; j < _featureAttr[indexPath.section].listKeys.count; j++) {
//            _featureAttr[indexPath.section].list[j].isSelect = NO;
//        }
    }
//    _featureAttr[indexPath.section].list[indexPath.row].isSelect = !_featureAttr[indexPath.section].list[indexPath.row].isSelect;
    _featureAttr[indexPath.section].index= indexPath.row+10;

    
    //section，item 循环讲选中的所有Item加入数组中 ，数组mutableCopy初始化
    _seleArray = [@[] mutableCopy];
    for (NSInteger i = 0; i < _featureAttr.count; i++) {
        
        DCFeatureItem * item = _featureAttr[i] ;
        for (NSInteger j = 0; j < item.listKeys.count; j++) {
            if (item.index -10 == j) {
                [_seleArray addObject: [item.listValue objectAtIndex:j]];
            }else{
                [_seleArray removeObject:[item.listValue objectAtIndex:j]];
                [_lastSeleArray removeAllObjects];
            }
        }
    }
    //刷新tableView和collectionView
    [self.collectionView reloadData];
    [self.tableView reloadData];
}


#pragma mark - <HorizontalCollectionLayoutDelegate>
#pragma mark - 自定义layout必须实现的方法
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    
    return _featureAttr[indexPath.section].listKeys[indexPath.row];
//    return _featureAttr[indexPath.section].list[indexPath.row].infoname;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
