
//
//  DCMyCenterViewController.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/5.
//Copyright © 2017年 strong. All rights reserved.
//

#import "DCMyCenterViewController.h"
#import "UNmanagerController.h"

// Controllers
#import "DCManagementViewController.h" //账户管理
#import "DCGMScanViewController.h"  //扫一扫
#import "DCSettingViewController.h" //设置
#import "LogInmainViewController.h"
#import "DCOrderListViewController.h"
#import "AboutUslistViewController.h"
#import "DCReceivingAddressViewController.h"
#import "AFMeiQiaCustomEngine.h"

// Models
#import "DCGridItem.h"
// Views
                               //顶部和头部View
#import "DCCenterTopToolView.h"
#import "DCMyCenterHeaderView.h"
                               //四组Cell
#import "DCCenterItemCell.h"
#import "DeviceTableViewCell.h"
//#import "DCCenterServiceCell.h"
//#import "DCCenterBeaShopCell.h"
//#import "DCCenterBackCell.h"

// Vendors
#import <MJExtension.h>
#import "HttpRequestToken.h"
#import "AFAccountEngine.h"
#import "UIButton+AFNetworking.h"
// Categories

// Others

@interface DCMyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFAccount * accountInfo ;
}
/* headView */
@property (strong , nonatomic)DCMyCenterHeaderView *headView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 顶部Nva */
@property (strong , nonatomic)DCCenterTopToolView *topToolView;

/* 服务数据 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *serviceItem;

@property (strong , nonatomic)NSArray * tipArray;

@end

static NSString *const DCCenterItemCellID = @"DCCenterItemCell";
static NSString *const DCCenterServiceCellID = @"DCCenterServiceCell";
static NSString *const DCCenterBeaShopCellID = @"DCCenterBeaShopCell";
static NSString *const DCCenterBackCellID = @"DCCenterBackCell";
static NSString *const DeviceTableViewCellID = @"DeviceTableViewCell";


@implementation DCMyCenterViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - DCBottomTabH);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCCenterItemCell class] forCellReuseIdentifier:DCCenterItemCellID];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterServiceCell class]) bundle:nil] forCellReuseIdentifier:DCCenterServiceCellID];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterBeaShopCell class]) bundle:nil] forCellReuseIdentifier:DCCenterBeaShopCellID];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterBackCell class]) bundle:nil] forCellReuseIdentifier:DCCenterBackCellID];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeviceTableViewCell class]) bundle:nil] forCellReuseIdentifier:DeviceTableViewCellID];


        
    }
    return _tableView;
}

- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
        NSInteger armNum = [DCSpeedy dc_GetRandomNumber:1 to:9];
        [_headerBgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_main_bg_11"]]];
        [_headerBgImageView setBackgroundColor:[UIColor greenColor]];
        [_headerBgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (DCMyCenterHeaderView *)headView
{
    if (!_headView) {
        _headView = [DCMyCenterHeaderView dc_viewFromXib];
        _headView.frame =  CGRectMake(0, 0, ScreenW, 200);
    }
    return _headView;
}


- (NSMutableArray<DCGridItem *> *)serviceItem
{
    if (!_serviceItem) {
        _serviceItem = [NSMutableArray array];
    }
    return _serviceItem;
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    accountInfo =  [AFAccountEngine  getAccount];
    self.headView.useNameLabel.text = accountInfo.client.nickname;
    if ([HttpRequestToken getToken].length<1) {
        self.headView.useNameLabel.text = @"点击登录";
    }
    [self.headView.myIconButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:accountInfo.client.headimgurl] ];
    [self.tableView reloadData ];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    [self getOrderStateNumber ];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpData];

    [self setUpNavTopView];
    
    [self setUpHeaderCenterView];
    
    
}

#pragma mark - 获取数据
- (void)setUpData
{
    _serviceItem = [DCGridItem mj_objectArrayWithFilename:@"MyServiceFlow.plist"];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[DCCenterTopToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, DCTopNavH)];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{ //点击了扫描
        DCGMScanViewController *dcGMvC = [DCGMScanViewController new];
        [weakSelf.navigationController pushViewController:dcGMvC animated:YES];
    };
    _topToolView.rightItemClickBlock = ^{ //点击设置
        AboutUslistViewController *dcSetVc = [AboutUslistViewController new];
        [weakSelf.navigationController pushViewController:dcSetVc animated:YES];
    };
    
    [self.view addSubview:_topToolView]; //  暂时取消
    
}


#pragma mark - initialize
- (void)setUpBase {
    
    self.view.backgroundColor = DCBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = [UIView new]; //去除多余分割线
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    
    self.tableView.tableHeaderView = self.headView;
    self.headerBgImageView.frame = self.headView.bounds;
    [self.headView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
    
    WEAKSELF
    self.headView.headClickBlock = ^{
        
        if ([HttpRequestToken getToken].length<1) {
            LogInmainViewController *dcLoginVc = [LogInmainViewController new];
            [weakSelf presentViewController:dcLoginVc animated:YES completion:nil];
            return ;
        }
        UNmanagerController *dcMaVc = [UNmanagerController new];
        [weakSelf.navigationController pushViewController:dcMaVc animated:YES];
    };
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([HttpRequestToken getToken].length<1) {
        return  3;
    }
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cusCell = [UITableViewCell new];
    if (indexPath.section == 0) {
        DCCenterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterItemCellID forIndexPath:indexPath];
        
        cell.backIndex = ^(int index) {
            if ([HttpRequestToken getToken].length<1) {
                LogInmainViewController *dcLoginVc = [LogInmainViewController new];
                [self presentViewController:dcLoginVc animated:YES completion:nil];
                return ;
            }
            DCOrderListViewController * orderlist = [[DCOrderListViewController alloc]init];
            orderlist.selectIndex = index+1 ;
            [self.navigationController pushViewController:orderlist animated:YES];
        };
        cell.orderArray = _tipArray ;
        cusCell = cell;
    }
    else if (indexPath.section==1){

        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceTableViewCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if ([HttpRequestToken getToken].length<1) {
           
            cell.titleNameLabel.text = @"我的设置";
            cell.headImageView.image = [UIImage imageNamed:@"btn_setting"];
            cusCell = cell;
        }else{
            cell.titleNameLabel.text = @"收货地址管理";
            cell.titleNameLabel.width = 150 ;
            cell.headImageView.image = [UIImage imageNamed:@"user_icon_yinhangka"];
        }
        cusCell = cell;


    }else{
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceTableViewCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if( indexPath.section ==2){
            
            if ([HttpRequestToken getToken].length<1) {
             
                cell.titleNameLabel.text = @"联系客服";
                cell.headImageView.image = [UIImage imageNamed:@"xiaoxi"];
                cusCell = cell;

            }else{
                cell.titleNameLabel.text = @"我的设置";
                cell.headImageView.image = [UIImage imageNamed:@"btn_setting"];
                cusCell = cell;
            }
            
        }else if( indexPath.section == 3){
            cell.titleNameLabel.text = @"联系客服";
            cell.headImageView.image = [UIImage imageNamed:@"xiaoxi"];
            cusCell = cell;

        }
   
    }
  
//    else
//        if(indexPath.section == 1){
//        DCCenterServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterServiceCellID forIndexPath:indexPath];
//        cell.serviceItemArray = [NSMutableArray arrayWithArray:_serviceItem];
//        cusCell = cell;
//    }
//    else if (indexPath.section == 2){
//        DCCenterBeaShopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterBeaShopCellID forIndexPath:indexPath];
//        cusCell = cell;
//    }
//    else if (indexPath.section == 3){
//        DCCenterBackCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterBackCellID forIndexPath:indexPath];
//        cusCell = cell;
//    }
    
    return cusCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 45 ;
    }
    return 0.01 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section!=0) {
        return  nil ;
    }
    UIView* view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor whiteColor];
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    v.backgroundColor = [UIColor whiteColor];
    [view addSubview:v];
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 200, 20)];
    label.text = @"订单信息";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor HexString:@"333333"];
    [view addSubview:label];
    
    UILabel * label1 =[[UILabel alloc]initWithFrame:CGRectMake(ScreenW-130, 12, 100, 20)];
    label1.text = @"查看全部订单";
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor HexString:@"333333"];
    [view addSubview:label1];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"next_table_image.png"];
    imageView.frame = CGRectMake(ScreenW-25, 17, 10, 10);
    [view addSubview:imageView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, ScreenW, 45);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(pushOrderVC) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view ;
}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([HttpRequestToken getToken].length<1) {
        LogInmainViewController *dcLoginVc = [LogInmainViewController new];
        [self presentViewController:dcLoginVc animated:YES completion:nil];
        return ;
    }
    NSLog(@"===%ld",(long)indexPath.row);

    if (indexPath.section==0) {
        DCOrderListViewController * orderVC = [[DCOrderListViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else if (indexPath.section==1) {
        DCReceivingAddressViewController* adressVC = [[DCReceivingAddressViewController alloc]init];
        [self.navigationController pushViewController:adressVC animated:YES];
        
    }else if (indexPath.section==2){
        AboutUslistViewController* adressVC = [[AboutUslistViewController alloc]init];
        [self.navigationController pushViewController:adressVC animated:YES];
        
    } else if (indexPath.section==3) {
        [AFMeiQiaCustomEngine didMeiQiaUIViewController:self andContant:nil];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
        [self setStatusBarBackgroundColor:[UIColor whiteColor]];
      
    }
    
}
-(void)pushOrderVC{
    DCOrderListViewController * orderVC = [[DCOrderListViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//待付款Item组
//        return 300;
        return 90;
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2){
        return 55;
    }else if (indexPath.section == 3){
        return 55;
    }
    return 0;
}

#pragma mark - 滚动tableview 完毕之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _topToolView.hidden = (scrollView.contentOffset.y < 0) ? YES : NO;
    
//    _topToolView.backgroundColor = (scrollView.contentOffset.y > 64) ? RGB(0, 0, 0) : [UIColor clearColor];
    
    //图片高度
    CGFloat imageHeight = self.headView.dc_height;
    //图片宽度
    CGFloat imageWidth = ScreenW;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        self.headerBgImageView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
}

#pragma 获取订单状态数量
-(void)getOrderStateNumber{
    
    NSString *path = [API_HOST stringByAppendingString:order_tips];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [HttpEngine requestPostWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        self.tipArray = JSONDic;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
    }];
    
}
@end
