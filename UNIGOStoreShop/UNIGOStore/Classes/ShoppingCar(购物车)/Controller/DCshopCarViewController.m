//
//  DCshopCarViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCshopCarViewController.h"
#import "DCOrderDetailViewController.h"
// Models
#import "DCRecommendItem.h"
// Views
#import "DCEmptyCartView.h"
#import "DCShopCarTableViewCell.h"
#import "DCRecommendReusableView.h"
// Vendors
#import <MJExtension.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
// Categories

// Others
#import "DCShopCar.h"


@interface DCshopCarViewController ()<UITableViewDataSource , UITableViewDelegate >
{
    DCShopCar * shopCarModel ;
    DCEmptyCartView *emptyCartView ;
}

/* 推荐商品数据 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *recommendItem;

/* 通知 */
@property (weak ,nonatomic) id dcObserve;

@property (strong, nonatomic) IBOutlet UITableView *rootTableView;


@property (weak, nonatomic) IBOutlet UILabel *selectCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIView *sumView;

@end

@implementation DCshopCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    [self setUpBase];
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  64, SCREEN_WIDTH, SCREEN_HEIGHT- 64);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.backgroundColor=PersonBackGroundColor;
    _rootTableView.sectionHeaderHeight = 16 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.view.backgroundColor=PersonBackGroundColor;
    [self.view addSubview:_rootTableView];
    
    [self.view addSubview:_sumView];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        _rootTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    shopCarModel = [DCShopCar sharedDataBase];
//    DCShopCarModel * iten = [[DCShopCarModel alloc]init];
//    
//    iten.name = @"苹果手机iPhonexmac 高配版全网通 4G 质保三年高端手机";
//    iten.image = @"http://gfs14.gomein.net.cn/T177EvBgJb1RCvBVdK-800.png";
//    iten.price = @"668.00";
//    iten.count = @"2";
//    iten.stock = @"20";
//    iten.info = @"中华神鹰 3代机型 红色";
//    iten.isSelect = YES;
//    iten.identifier = @"123";
//    iten.nature = @"中华神鹰 3代机型 红色";
//    [shopCarModel.carList addObject:iten];
    [_rootTableView reloadData];
    //
    
    if (_isTabBar) {
        _sumView.bottom = ScreenH;
        _rootTableView.height = ScreenH-64 -100;
    }else{
        _sumView.bottom = ScreenH-50;
        _rootTableView.height = ScreenH-64 -100-50;
    }
    [self selectSum ];
    
    
    if (!(shopCarModel.carList.count>0)) {
        [self setUpEmptyCartView];
    }else{
        [self.view addSubview:_rootTableView];
    }
}

#pragma mark - 初始化空购物车View
- (void)setUpEmptyCartView
{
    
    if (!emptyCartView) {
        emptyCartView = [[DCEmptyCartView alloc] init];
        emptyCartView.frame = CGRectMake(0, DCTopNavH, ScreenW, 300);
        emptyCartView.buyingClickBlock = ^{
            NSLog(@"点击了立即抢购");
        };
    }
    [self.view addSubview:emptyCartView];
    
   
}

#pragma mark - initizlize
- (void)setUpBase
{
    self.view.backgroundColor = DCBGColor;
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  shopCarModel.carList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 112;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    DCShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DCShopCarTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    DCShopCarModel * iten  = [shopCarModel.carList objectAtIndex:indexPath.row];
    cell.shopCar = iten;
    
    cell.backSelect = ^(DCShopCarModel * _Nonnull model) {
        [shopCarModel.carList replaceObjectAtIndex:indexPath.row withObject:model];
        [_rootTableView reloadData];
        [self selectSum ];
    };
    return   cell;
}

#pragma mark 计算总额
-(void)selectSum{
    
    float  sumPrice = 0 ;
    int  selctCount = 0;
    for (DCShopCarModel* shop in shopCarModel.carList) {
        if (shop.isSelect) {
            sumPrice = (float)[shop.price floatValue]*[shop.count intValue]+sumPrice;
            selctCount++;
        }
    }
    _selectCountLabel.text = [NSString stringWithFormat:@"%d",selctCount];
    _sumLabel.text = [NSString stringWithFormat:@"¥：%.2f",sumPrice];
}

#pragma  mark - 设置编辑 删除
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{  ///设置可以编辑 并有动画
    
    [super setEditing:YES animated:YES];
    [_rootTableView setEditing:YES animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return YES;

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{    ///实施方法 进行增减行的操作
    
    
    if (shopCarModel.carList.count>indexPath.row) {
        
        [shopCarModel.carList removeObjectAtIndex:indexPath.row];
        [_rootTableView reloadData];
        [self selectSum ];

        if (!(shopCarModel.carList.count>0)) {
            [self setUpEmptyCartView];
        }
    }
    
}

- (IBAction)buyNow:(UIButton *)sender {
    
    
    if (shopCarModel.buyList.count>=1) {
        [shopCarModel.buyList removeAllObjects];
    }
    for (DCShopCarModel * model in shopCarModel.carList) {
        
        if (model.isSelect) {
            [shopCarModel.buyList addObject:model];
        }
        
    }
    
    
    DCOrderDetailViewController * orderVC = [[DCOrderDetailViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

#pragma mark - 消失
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObserve];
}
@end
