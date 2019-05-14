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

#import "MQChatViewManager.h"
#import "AFMeiQiaCustomEngine.h"

@interface DCorderDetailStatueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *rootTableView;
@property (strong, nonatomic) IBOutlet UIView *headOrderView;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UIView *footOrderView;
@property (weak, nonatomic) IBOutlet UILabel *goodeSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) NSArray * goodsArray;
@property (strong, nonatomic) NSDictionary * goodsPayDiction;


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
    
    int isPay = [[diction objectForKey:@"pay_status"] intValue];
    if (isPay==1) {
        _payButton.hidden = YES;
    }
    _goodsArray = [[diction objectForKey:@"goods"] copy];
    
    [_rootTableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return  _goodsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 70;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 261;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return _headOrderView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 137;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footOrderView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JFJOrderTableViewCell";
    
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
 
    NSDictionary* diction =  [_goodsArray objectAtIndex:indexPath.row];
    
    cell.goodsDetailLabel.text = [diction objectForKey:@"name"];
    cell.goodsStatusLabel.text = [diction objectForKey:@"spec_name"];
    cell.priceLabel.text = [diction objectForKey:@"price"];
    cell.goodCountLabel.text = [diction objectForKey:@"count"];
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:DefaultImage] placeholderImage:nil];
    return   cell;
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
    PayViewController* payVC = [[PayViewController alloc]init];
    payVC.SumLabel.text = _goodeSumLabel.text;
    payVC.orderID = _orderID;

    [self.navigationController pushViewController:payVC animated:YES];
    
}
- (IBAction)deleteOrder:(UIButton *)sender {
    
}

@end
