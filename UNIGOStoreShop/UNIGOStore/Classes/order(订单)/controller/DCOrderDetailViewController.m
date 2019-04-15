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


@interface DCOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    DCShopCar * shopCar ;
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
    
    shopCar = [DCShopCar sharedDataBase];
    
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  64, SCREEN_WIDTH, SCREEN_HEIGHT- 64-60);
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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updataAddressView];

}
-(void)updataAddressView{
    
    NSArray * addList = [DCAddressModel sharedDataBase].addressList ;
    DCAdressItem * selectItem = addList.firstObject;
  
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==3) {
        return 4;
    }else  if (section==0) {
        return shopCar.buyList.count;
    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 70+10;
    }else  if (indexPath.section==3) {
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
        cell.sleepCountLabel.text = [NSString stringWithFormat:@"X%@",model.count];
        cell.stateLabel.text = model.nature ;
        [cell.goodsImageView setImageWithURL:[NSURL URLWithString:DefaultImage] placeholderImage:[UIImage imageNamed:@""]];
        
        return cell;
    }
        else {
       
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
           if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
           }
            cell.titleNameLabel.left = 15;
            switch (indexPath.section) {
                case 1:
                    {
                        cell.titleNameLabel.text =@"优惠券";
                        cell.pushNextLabel.text = @"暂无可用优惠券" ;

                    }
                    break;
                case 2:
                {
                    cell.titleNameLabel.text =@"支付方式";
                    cell.pushNextLabel.text = @"在线支付" ;

                }
                    break;
                case 3:
                {
                    if (indexPath.row==0) {
                        cell.titleNameLabel.text =@"商品金额";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]] ;

                    }else  if (indexPath.row==1) {
                        cell.titleNameLabel.text =@"优惠折扣";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"-%@",_souponPrice];
                    }else   if (indexPath.row==2) {
                        cell.titleNameLabel.text =@"运费";
                        cell.pushNextLabel.text = [NSString stringWithFormat:@"+%@",_addressPrice];

                        
                    }else if (indexPath.row==3) {
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
        [UIHelper alertWithTitle:@"无可用优惠券"];
    }
    else if (indexPath.section == 2) {
        [self selectCouponActionSheetView ];
    }
    
}

/* 计算商品价格*/
-(CGFloat)shopSumOfPrice{
    
    CGFloat sum = 0 ;
    for (DCShopCarModel *model in shopCar.buyList) {
        sum = [model.price floatValue] * model.count.intValue+sum;
    }
    
    return sum ;
}

#pragma mark 选择优惠券
- (void)selectCouponActionSheetView
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"到店付款",@"在线支付"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 2) {
            return ;
        }
        if (buttonIndex==0) {
            _payStyle = @"flowLine";
        } else  if (buttonIndex==1) {
            _payStyle = @"online";
        }
      
    }];
    
    [sheet showWithColor:[UIColor HexString:@"2c2c2c"]];
}

- (IBAction)sumbitPay:(UIButton *)sender {
    
    PayViewController * payVC = [[PayViewController alloc]init];
    payVC.SumLabel.text = [NSString stringWithFormat:@"%.2f", [self shopSumOfPrice]+_addressPrice.floatValue-_souponPrice.floatValue] ;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}
- (IBAction)selectAddress:(UIButton *)sender {
    
    if (!addressVC) {
        addressVC = [[DCReceivingAddressViewController alloc]init];
        addressVC.pushTag = 2 ;
    }
    [self.navigationController pushViewController:addressVC animated:YES];
}

@end
