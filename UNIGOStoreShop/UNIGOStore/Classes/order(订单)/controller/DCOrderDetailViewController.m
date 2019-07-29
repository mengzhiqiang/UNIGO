//
//  DCOrderDetailViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCOrderDetailViewController.h"
#import "DCReceivingAddressViewController.h"


#import "JFJOrderTableViewCell.h"
#import "DeviceTableViewCell.h"
#import "DCShopCar.h"
#import "LCActionSheet.h"
#import "DCAddressModel.h"
#import "PayViewController.h"
#import "WXApi.h"


@interface DCOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    DCShopCar * shopCar ;
    DCAdressItem * selectItem;
    DCReceivingAddressViewController * addressVC ;
}

@property (strong, nonatomic) IBOutlet UIView *addressView;

@property (strong, nonatomic)  UITableView *rootTableView;

@property (strong, nonatomic)  NSString * addressPrice ;
@property (strong, nonatomic)  NSString * souponPrice ;


@property (strong, nonatomic)  NSString * payStyle ;
@property (weak, nonatomic) IBOutlet UIView *sumPayView;
@property (weak, nonatomic) IBOutlet UILabel *sumPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *noAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressDetailView;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;

@end

@implementation DCOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headLabel.text = @"订单信息";
    shopCar = [DCShopCar sharedDataBase];
    
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH-60);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 16 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.backgroundColor=PersonBackGroundColor;
    self.view.backgroundColor=PersonBackGroundColor;
    
    [self.view addSubview:_rootTableView];
    
    _souponPrice = @"20.00";
    _addressPrice = @"8.00";
    
    
    self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]+_addressPrice.floatValue-_souponPrice.floatValue] ;

//    if (![WXApi isWXAppInstalled]) {
//        _payButton.hidden = YES;
//    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updataAddressView];

//    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];
//
//    [[UINavigationBar appearance] setHidden:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}




-(void)updataAddressView{
    
    NSArray * addList = [DCAddressModel sharedDataBase].addressList ;
    selectItem = addList.firstObject;
  
    if (addressVC.selectAddrss.mobile.length>0) {
        selectItem = addressVC.selectAddrss ;
    }else{
        for (DCAdressItem * item in addList) {
            if (item.is_default) {
                selectItem = item;
            }
        }
    }
    
    if (selectItem) {
        _noAddressView.hidden = YES;
        _addressDetailLabel.hidden = NO;
        _addressNameLabel .text = [NSString stringWithFormat:@"%@ %@",selectItem.consignee,selectItem.mobile];
        _addressDetailLabel.text = selectItem.address;
    }else{
        _noAddressView.hidden = NO;
        _addressDetailLabel.hidden = YES;
    }
    NSLog(@"===%@",addList);
    
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==2) {
        return 3;
    }else  if (section==0) {
        return shopCar.buyList.count;
    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 70+10;
    }else  if (indexPath.section==2) {
        return 45;
    }
    return 50 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JFJOrderTableViewCell"];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        DCShopCarModel *model = [shopCar.buyList objectAtIndex:indexPath.row];
        cell.goodsDetailLabel.text = model.name;
        cell.priceLabel.text = model.price;
        cell.sleepCountLabel.text = [NSString stringWithFormat:@"X%@",model.cart_num];
        cell.stateLabel.text = model.spec_name ;
        [cell.goodsImageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
        
        return cell;
    }
        else {
       
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
           if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
           }
            cell.titleNameLabel.left = 15;
            cell.pushTagImageView.hidden = YES;

            switch (indexPath.section) {
//                case 1:
//                    {
////                        cell.titleNameLabel.text =@"优惠券";
////                        cell.pushNextLabel.text = @"暂无可用优惠券" ;
//
//                    }
//                    break;
                case 1:
                {
                    cell.titleNameLabel.text =@"支付方式";
                    cell.pushNextLabel.text = @"在线支付" ;
                }
                    break;
                case 2:
                {
                    if (indexPath.row==0) {
                        cell.titleNameLabel.text =@"商品金额";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]] ;

                    }
//                    else  if (indexPath.row==1) {
//                        cell.titleNameLabel.text =@"优惠折扣";
//                        cell.pushNextLabel.text = [NSString stringWithFormat:@"-%@",_souponPrice];
//                    }
                    else   if (indexPath.row==1) {
                        cell.titleNameLabel.text =@"运费";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"+%@",_addressPrice];

                        
                    }else if (indexPath.row==2) {
                        cell.titleNameLabel.text =@"实际支付";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]+_addressPrice.floatValue-_souponPrice.floatValue] ;

                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 140+10;
    }
    else if(section == 1){
        return  8.0f;
    }
    return 1.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return  _addressView;
    }
    return nil;
}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
//        [self selectCouponActionSheetView ];
        [UIHelper showUpMessage:@"无可用优惠券"];
    }
    else if (indexPath.section == 2) {
        [self selectCouponActionSheetView ];
    }
    
}

/* 计算商品价格*/
-(CGFloat)shopSumOfPrice{
    
    CGFloat sum = 0 ;
    for (DCShopCarModel *model in shopCar.buyList) {
        
        sum = [model.price floatValue] * model.cart_num.intValue+sum;
    }

    
    return sum ;
}

#pragma mark 选择优惠券
- (void)selectCouponActionSheetView
{
    
//    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"到店付款",@"在线支付"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
//        if(buttonIndex == 2) {
//            return ;
//        }
//        if (buttonIndex==0) {
//            _payStyle = @"flowLine";
//        } else  if (buttonIndex==1) {
//            _payStyle = @"online";
//        }
//
//    }];
//
//    [sheet showWithColor:[UIColor HexString:@"2c2c2c"]];
}

- (IBAction)sumbitPay:(UIButton *)sender {
    
    [self addOrderOfShop];
 
}

-(void)pushPayVCWithOrder:(NSString*)oder{
    PayViewController * payVC = [[PayViewController alloc]init];
    payVC.SumOfPrice = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]+_addressPrice.floatValue-_souponPrice.floatValue] ;
    payVC.orderID = oder;
    
    UIViewController * viewVC = self.navigationController.viewControllers.firstObject;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [viewVC.navigationController pushViewController:payVC animated:YES];
    
}

#pragma mark 提交订单
-(void)addOrderOfShop{
    
    if (!(selectItem.identifier.length>=1)) {
        [UIHelper alertWithTitle:@"请选择地址"];
        return ;
    }
    
    NSString *path = [API_HOST stringByAppendingString:order_add];
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    NSString * car_id = @"";
    for (DCShopCarModel * model in shopCar.buyList) {
        if (model.identifier) {
            if (car_id.length>0) {
                car_id = [NSString stringWithFormat:@"%@,%@",car_id,model.identifier];
            }else{
                car_id = model.identifier ;
            }
        }
    }
    
    if (car_id.length>0) {
        [diction setObject:car_id forKey:@"cart_id"];
    }else{
        DCShopCarModel * model  = shopCar.buyList.firstObject;
        
        [diction setObject:model.goods_id forKey:@"goods_id"];
        [diction setObject:model.spec_id forKey:@"spec_id"];
        [diction setObject:model.cart_num forKey:@"goods_num"];

    }
    [diction setObject:selectItem.identifier forKey:@"address_id"];

    
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=下订单====%@",responseObject );
        if ([JSONDic objectForKey:@"order_id"]) {
            [self pushPayVCWithOrder:[JSONDic objectForKey:@"order_id"]];
        }else{
            [self pushPayVCWithOrder:nil];
        }
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code=下订单====%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
}
- (IBAction)selectAddress:(UIButton *)sender {
    
    if (!addressVC) {
        addressVC = [[DCReceivingAddressViewController alloc]init];
        addressVC.pushTag = 2 ;
    }
    [self.navigationController pushViewController:addressVC animated:YES];
}

@end
