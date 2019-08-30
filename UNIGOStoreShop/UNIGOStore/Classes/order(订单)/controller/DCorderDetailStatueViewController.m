//
//  DCorderDetailViewController.m
//  jiefujia
//
//  Created by zhiqiang meng on 8/4/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "DCorderDetailStatueViewController.h"
#import "JFJOrderTableViewCell.h"
#import "PayViewController.h"
#import "DeviceTableViewCell.h"
#import "MQChatViewManager.h"
#import "AFMeiQiaCustomEngine.h"
#import "DCAfterSaleViewController.h"


@interface DCorderDetailStatueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *rootTableView;
@property (strong, nonatomic) IBOutlet UIView *headOrderView;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;

@property (strong, nonatomic) IBOutlet UIView *footOrderView;
@property (weak, nonatomic) IBOutlet UILabel *goodeSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) NSArray * goodsArray;
@property (strong, nonatomic) NSDictionary * goodsPayDiction;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabael;
@property (weak, nonatomic) IBOutlet UILabel *payTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

@end

@implementation DCorderDetailStatueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headLabel.text = @"订单详情";
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 0 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.backgroundColor=PersonBackGroundColor;
    self.view.backgroundColor=PersonBackGroundColor;
    [self.view addSubview:_rootTableView];
    
    [_deleteButton draCirlywithColor:[UIColor grayColor] andRadius:0.5f];
    [_payButton draCirlywithColor:[UIColor orangeColor] andRadius:0.5f];
    
    
    self.headMessageButton.hidden = NO ;
    [self.headMessageButton setTitle:@"客服" forState:UIControlStateNormal];
    self.HeadView.height = DCTopNavH;
    
//    if (![WXApi isWXAppInstalled]) {
//        _payButton.hidden = YES;
//    }
}

-(void)RightMessageOfTableView{

    [AFMeiQiaCustomEngine didMeiQiaUIViewController:self andContant:@{@"style":@"1"}];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];

}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];

    [[UINavigationBar appearance] setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self getOrderDetail];
}

-(void)getOrderDetail{
    
    NSString *path = [API_HOST stringByAppendingString:order_details];

    NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:self.orderID,@"id", nil];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=订单信息====%@",responseObject );
        [self loadNewUI:JSONDic];
        
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=订单信息====%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
}

-(void)loadNewUI:(NSDictionary*)diction{
    
    _goodsPayDiction = diction ;
    NSDictionary *address = [diction objectForKey:@"address"];
    _payNameLabel.text = [NSString stringWithFormat:@"%@  %@",[address objectForKey:@"consignee"] ,[address objectForKey:@"mobile"]];
    _payAddressLabel.text =  [address objectForKey:@"address"];
//    _payTimeLabel.text = [address objectForKey:@"address"];
    _goodeSumLabel.text = [diction objectForKey:@"total_price"];
    
    int status = [[diction objectForKey:@"status"] intValue];
    _payTimeLabel.text = [NSString stringWithFormat:@"订单号：%@", [diction objectForKey:@"order_id"]];
    _timerGoodsLabel.text = @"请核对订单所有信息";
    _timeOutLabel.text = @"如有问题，请联系客服";
    switch (status) {
        case -3:
        {
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"退款失败";
            _payButton.hidden = YES;

        }
            break;
        case -2:
        {
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"退款成功";
            _payButton.hidden = YES;

        }
            break;
        case -1:
        {
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"退款中";
            _payButton.hidden = YES;

        }
            break;
        case 0:
        {
            _payButton.hidden = NO;
            _deleteButton.hidden = NO ;
            _payStatusLabel.text = @"待付款";
            [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
            _timerGoodsLabel.text = @"请在30分钟内支付";
            _timeOutLabel.text = @"超时自动取消订单";
        }
            break;
        case 1:
        {
            _payButton.hidden = NO;
            [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"待发货";
            _timeOutLabel.hidden = YES;
//            [_deleteButton setTitle:@"商品待发货" forState:UIControlStateNormal];
//            _deleteButton.width = 100 ;
//            [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            _deleteButton.enabled = NO;
            
//            _footOrderView.height = 68 ;
        }
            break;
        case 2:
        {
            _payButton.hidden = NO;
            [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"已发货";
            _timeOutLabel.hidden = YES;
//            [_deleteButton setTitle:@"配送中" forState:UIControlStateNormal];
//            [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            _deleteButton.enabled = NO;
//            _footOrderView.height = 68 ;

        }
            break;
        case 3:
        {
            _payButton.hidden = NO;
            [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"已收货";
            _timeOutLabel.hidden = YES;
//            [_payButton setTitle:@"退款" forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            _payButton.hidden = NO;
            [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"待评论";
            _timeOutLabel.hidden = YES;
        }
            break;
        case 5:
        {
            _payButton.hidden = NO;
           [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"已完成";
            _timeOutLabel.hidden = YES;
//            _footOrderView.height = 68 ;

        }
            break;
        case 10:
        {
            _payButton.hidden = YES;
            //        [_payButton  setTitle:@"申请退款" forState:UIControlStateNormal];
            _deleteButton.hidden = YES ;
            _payStatusLabel.text = @"已取消";
            _timeOutLabel.hidden = YES;
            _footOrderView.height = 55 ;

        }
            break;
        default:
            break;
    }
    
    
    _orderIDLabel .text = [diction objectForKey:@"order_id"];
    _payStyleLabel.text =  [diction objectForKey:@"pay_type"];
    _orderTimeLabael.text =  [self time:[diction objectForKey:@"create_time"]];
    _payTimesLabel.text  =  [self time:[diction objectForKey:@"pay_time"]];
    _carTimeLabel.text   =  [self time:[diction objectForKey:@"express_time"]];
    _carNumberLabel.text =  ([[diction objectForKey:@"express"] length]?[diction objectForKey:@"express"]:@"暂无")  ;
    
    _goodsArray = [[diction objectForKey:@"goods"] copy];
    [_rootTableView reloadData];
}

-(NSString*)time:(NSString*)time{
    if ([time integerValue] == 0) {
        return  @"暂无";
    }
   return   [NSDate timeWithTimeIntervalString:time];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_goodsPayDiction[@"active_note"]) {
        return _goodsArray.count+1;
    }
    return  _goodsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==_goodsArray.count) {
        return 44;
    }
    return 70;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 241;
    }
    return 0.01;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return _headOrderView;
    }
    return nil;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 289;
    }
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 147)];
    View.backgroundColor= PersonBackGroundColor ;
    _footOrderView.top = 10 ;
    [View addSubview:_footOrderView];
    return View;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==_goodsArray.count) {
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCellID"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lineLabel1.hidden = NO;
        cell.titleNameLabel.frame = CGRectMake(15, (cell.height-20)/2, 50, 20);
        cell.headImageView.hidden = YES;
        cell.pushTagImageView.hidden = YES;
        cell.pushNextLabel.autoresizesSubviews = NO;
        cell.pushNextLabel.frame = CGRectMake(70, 7, ScreenW-80, 30);
        cell.pushNextLabel.textAlignment = NSTextAlignmentLeft;
        cell.titleNameLabel.text = @"活动";
        cell.pushNextLabel.text = _goodsPayDiction[@"active_note"];
        cell.lineLabel1.top = 0 ;
        return cell ;
    }
    
    else {
        static NSString *CellIdentifier = @"JFJOrderTableViewCell";
        JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        NSDictionary* diction =  [_goodsArray objectAtIndex:indexPath.row];
        
        cell.goodsDetailLabel.text = [diction objectForKey:@"name"];
        cell.stateLabel.text = [diction objectForKey:@"spec_name"];
        cell.priceLabel.text = [diction objectForKey:@"price"];
        cell.sleepCountLabel.text = [NSString stringWithFormat:@"x%@",[diction objectForKey:@"num"]];
        [cell.goodsImageView setImageWithURL:[NSURL URLWithString: [diction objectForKey:@"image"]] placeholderImage:nil];
        
        return   cell;
    }
    
  
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payOrder:(UIButton *)sender {
    
    int status = [[_goodsPayDiction objectForKey:@"status"] intValue];

    if (status==0) { ///未支付
        PayViewController* payVC = [[PayViewController alloc]init];
        payVC.SumOfPrice = _goodeSumLabel.text;
        payVC.orderID = _orderID;
        [self.navigationController pushViewController:payVC animated:YES];
     
    }else{
        DCAfterSaleViewController* payVC = [[DCAfterSaleViewController alloc]init];
        payVC.goodsPayDiction = _goodsPayDiction;
        [self.navigationController pushViewController:payVC animated:YES];
        
        return ;
    }
    

    
}
- (IBAction)deleteOrder:(UIButton *)sender {
    
    NSString *path = [API_HOST stringByAppendingString:order_cancel];
    
    NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:self.orderID,@"id", nil];
    WEAKSELF
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=取消订单====%@",responseObject );
        [UIHelper hiddenAlertWith:self.view];
        
        [self getOrderDetail ];
    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];

        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=取消订单====%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
}

@end
