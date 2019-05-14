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
    _rootTableView .frame = CGRectMake(0,  DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH - 50-iphoneXTabbarHieght);
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
    
    [self getallShopCars ];
    
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
        _sumView.bottom = ScreenH-iphoneXTabbarHieght;
        _rootTableView.height = ScreenH-DCTopNavH -100-iphoneXTabbarHieght;
    }else{
        _sumView.bottom = ScreenH-50-iphoneXTabbarHieght;
        _rootTableView.height = ScreenH-DCTopNavH -100-50-iphoneXTabbarHieght;
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
    
    emptyCartView.hidden = NO;
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
    
    return  [shopCarModel.carList objectAtIndex:section].data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return shopCarModel.carList.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    DCShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DCShopCarTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:indexPath.section];
    DCShopCarModel * iten  = [shopModel.data objectAtIndex:indexPath.row];
    cell.shopCar = iten;
    
    cell.backSelect = ^(DCShopCarModel * _Nonnull model) {
        
        if (!model.isSelect) {
            shopModel.isSelect = NO;
        }
//        [self editeShopCar:model withindex:indexPath];
//        [shopModel.data replaceObjectAtIndex:indexPath.row withObject:model];
        [_rootTableView reloadData];
//        [self selectSum ];
    };
    cell.backShopCount = ^(DCShopCarModel * _Nonnull model) {
        
        [self editeShopCar:model withindex:indexPath];

    };
    return   cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:section];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    view.backgroundColor = [UIColor HexString:@"f2f2f2"];
    UIButton * shopSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopSelectBtn.frame = CGRectMake(5, 0, 30, 30);
    [shopSelectBtn setTitle:@"" forState:UIControlStateNormal];
    
    if (shopModel.isSelect) {
        [shopSelectBtn setTitle:@"" forState:UIControlStateNormal];
        [shopSelectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [shopSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    shopSelectBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:16];
    shopSelectBtn.tag = section+100 ;
    [shopSelectBtn addTarget:self action:@selector(shopSelect:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopSelectBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, ScreenW-50-80, 30)];
//    label.text = @"在校购商城";
    label.text =shopModel.shop_name;
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
    return view;
}

-(void)shopSelect:(UIButton*)sender{
    
    
    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:sender.tag-100];
    shopModel.isSelect = ! shopModel.isSelect;

    if (shopModel.isSelect) {
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }else{
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    for (DCShopCarModel * carModel in shopModel.data) {
        carModel.isSelect = shopModel.isSelect;
    }
    
    [_rootTableView reloadData];
    [self selectSum];
}
#pragma mark 计算总额
-(void)selectSum{
    
    float  sumPrice = 0 ;
    int  selctCount = 0;
    for (DCShopModel* shop in shopCarModel.carList) {
        
        for (DCShopCarModel * model in shop.data) {
            if (model.isSelect) {
                sumPrice = (float)[model.price floatValue]*[model.cart_num intValue]+sumPrice;
                selctCount++;
            }
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
    
    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:indexPath.section];

    if (shopModel.data.count>indexPath.row) {
        [self deleteShopCar:[shopModel.data objectAtIndex:indexPath.row] withindex:indexPath];
    }
}

- (IBAction)buyNow:(UIButton *)sender {
    
    if (shopCarModel.buyList.count>=1) {
        [shopCarModel.buyList removeAllObjects];
    }
    for (DCShopModel * model in shopCarModel.carList) {
        
        DCShopModel * shopModel= model;
        for (DCShopCarModel* carModel in shopModel.data) {
//            if (!carModel.isSelect) {
//                [shopModel.data removeObject:carModel];
//            }
//            if (shopModel.data.count==0) {
//                break;
//            }
            if (carModel.isSelect) {
                [shopCarModel.buyList addObject:carModel];
            }

        }
        
//        [shopCarModel.buyList addObject:shopModel];
    }
    DCOrderDetailViewController * orderVC = [[DCOrderDetailViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

#pragma mark 购物车
-(void)getallShopCars{
    
    NSString *path = [API_HOST stringByAppendingString:goodsCart_list];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        
        if (JSONDic.count>0) {
            [weakSelf  setShopCarWithData:JSONDic];
        }else{
            [shopCarModel.carList removeAllObjects];
            emptyCartView.hidden = NO;
            [_rootTableView reloadData];
            [self selectSum];
        }
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
}

#pragma mark 删除购物车
-(void)deleteShopCar:(DCShopCarModel*)carModel withindex:(NSIndexPath*)indepath{
    
    NSString *path = [API_HOST stringByAppendingString:goodsCart_modify];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:carModel.identifier forKey:@"id"];
    
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        [weakSelf  setShopCarWithData:JSONDic];
        
        DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:indepath.section];
        [shopModel.data removeObject:carModel];
        [_rootTableView reloadData];
        [self selectSum];
//        [weakSelf backAndReloadData:carModel withIndex:indepath];

    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"deleteShopCar==code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
}
-(void)deleteSuccessShopCar:(DCShopCarModel*)carModel withindex:(NSIndexPath*)indepath{
    DCShopModel * shopModel = [shopCarModel.carList objectAtIndex:indepath.section];

    [shopModel.data removeObjectAtIndex:indepath.row];
    [_rootTableView reloadData];
    [self selectSum ];
    if (!(shopCarModel.carList.count>0)) {
        [self setUpEmptyCartView];
    }
}

#pragma mark 修改购物车数量
-(void)editeShopCar:(DCShopCarModel*)carModel withindex:(NSIndexPath*)indepath{
    
    NSString *path = [API_HOST stringByAppendingString:goodsCart_modify];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setObject:carModel.identifier forKey:@"id"];
    [diction setObject:carModel.cart_num forKey:@"num"];
    
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        [weakSelf backAndReloadData:carModel withIndex:indepath];
    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"editeShopCar==code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        [_rootTableView reloadData];
    }];
}
-(void)backAndReloadData:(DCShopCarModel*)carModel withIndex:(NSIndexPath*)indexpath{
    
    DCShopModel * shopModel =  [shopCarModel.carList objectAtIndex:indexpath.section];
    [shopModel.data replaceObjectAtIndex:indexpath.row withObject:carModel];
    [_rootTableView reloadData];
    [self selectSum];
    
}

-(void)setShopCarWithData:(NSArray *)array{
    
    if (array.count>=1) {
        
        if (shopCarModel.carList.count>=1) {
            [shopCarModel.carList removeAllObjects];
        }
        if (shopCarModel.buyList.count>=1) {
            [shopCarModel.buyList removeAllObjects];
        }
        for (int i=0; i< [array count]; i++) {
            NSDictionary * dic = [array objectAtIndex:i];
            DCShopModel * model = [DCShopModel mj_objectWithKeyValues:dic];
            model.data = [DCShopCarModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"data"]];
            for (DCShopCarModel* carShop in model.data) {
                carShop.isSelect = YES;
            }
            model.isSelect = YES;
            [shopCarModel.carList addObject:model];
        }
        emptyCartView.hidden = YES;
        [_rootTableView reloadData];
        [self selectSum];
    }else{
        
        
    }
    
}

#pragma mark - 消失
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObserve];
}
@end
