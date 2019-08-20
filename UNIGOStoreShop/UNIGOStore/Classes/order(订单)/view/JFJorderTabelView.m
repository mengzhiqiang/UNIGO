//
//  JFJorderTabelView.m
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "JFJorderTabelView.h"
#import "JFJOrderTableViewCell.h"
#import "PayViewController.h"
#import "DCorderDetailStatueViewController.h"
#import "WXApi.h"

@interface JFJorderTabelView()<UITableViewDataSource,UITableViewDelegate>

@property(strong ,nonatomic) UIViewController * controller ;

@property(strong ,nonatomic) NSArray * data ;

@end

@implementation JFJorderTabelView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor HexString:@"f2f2f2"];
        self.delegate =self;
        self.dataSource =self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)setOrderStyle:(NSString *)orderStyle{
    _orderStyle = orderStyle ;
    [self reloadData];
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  (self.data.count?self.data.count:0);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"manageTableViewCell";
    
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.stateLabel draCirlywithColor:nil andRadius:2.0f];
    cell.stateLabel.text = @"已完成";
    [cell.oredreImageView setImageWithURL:[NSURL URLWithString:DefaultImage] placeholderImage:nil];
    cell.backgroundColor=[UIColor clearColor];
    cell.payButton.hidden = YES;
    cell.DeleteOrderButton.hidden = YES;
    
    if (self.data.count > indexPath.row) {
        NSDictionary * diction = [self.data objectAtIndex:indexPath.row];
        cell.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@", [NSDate timeWithTimeIntervalString: [diction objectForKey:@"create_time"]]];
        cell.goodeTitleLabel.text = [diction objectForKey:@"name"];
        cell.goodsStatusLabel.text = [diction objectForKey:@"spec_name"];
        cell.goodCountLabel.text = [NSString stringWithFormat:@"x%@",[diction objectForKey:@"total_num"]];;
        cell.orderSumLabel.text = [NSString stringWithFormat:@"合计：¥%@",[diction objectForKey:@"total_price"]];;
        [cell.oredreImageView setImageWithURL:[NSURL URLWithString: [diction objectForKey:@"image"]] placeholderImage:nil];
        int status = [[diction objectForKey:@"status"] intValue];
        int pay_status = [[diction objectForKey:@"pay_status"] intValue];

        [cell.DeleteOrderButton setTitle:@"已支付" forState:UIControlStateNormal];
        cell.DeleteOrderButton.enabled = NO;

        switch (status) {
            case -2:
                {
                    cell.orderStatusLabel.text = @"退款成功";
                }
                break;
            case -1:
            {
                cell.orderStatusLabel.text = @"退款中";

            }
                break;
            case 0:
            {
                cell.orderStatusLabel.text = @"待付款";
                cell.payButton.hidden = NO;
                cell.DeleteOrderButton.hidden = NO;
                [cell.DeleteOrderButton setTitle:@"去支付" forState:UIControlStateNormal];
                cell.DeleteOrderButton.enabled = YES;
            }
                break;
            case 1:
            {
                cell.orderStatusLabel.text = @"待发货";

            }
                break;
            case 2:
            {
                cell.orderStatusLabel.text = @"待收货";

            }
                break;
            case 3:
            {
                cell.orderStatusLabel.text = @"已收货";
                
            }
                break;
            case 4:
            {
                cell.orderStatusLabel.text = @"待评论";
                
            }
                break;
            case 5:
            {
                cell.orderStatusLabel.text = @"已完成";

            }
                break;
            case 10:
            {
                cell.orderStatusLabel.text = @"已取消";
                [cell.DeleteOrderButton setTitle:@"订单已取消" forState:UIControlStateNormal];
                cell.DeleteOrderButton.hidden = NO;
            }
                break;
            default:
                break;
        }
        
    }
    
    if (![WXApi isWXAppInstalled]) {
        cell.payButton.hidden = YES;
    }
    
    cell.backSelect = ^(NSString * _Nonnull style) {
        
//        if ([style isEqualToString:@"pay"]) {
            ///支付
            [self payOrderWith:indexPath.row];
//        }else{
//            //删除
//            [self deleteOrderWithRow:indexPath.row];
//        }
    };
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 1;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * diction = [self.data objectAtIndex:indexPath.row];

//    if ([_orderStyle isEqualToString:@"全部"]) {
        DCorderDetailStatueViewController* statueVC =[[DCorderDetailStatueViewController alloc]init];
        statueVC.orderID = [diction objectForKey:@"id"];
        [_controller.navigationController pushViewController:statueVC animated:YES];
//        return;
//    }
    
}

-(void)updataData:(NSArray* )array tagre:(UIViewController*)tagre{

    self.data = array ;
    _controller = tagre;
    
    [self reloadData];
}

-(void)payOrderWith:(NSInteger)row{
    
    NSDictionary * diction = [self.data objectAtIndex:row];

    PayViewController* payVC = [[PayViewController alloc]init];
    payVC.SumOfPrice = [diction objectForKey:@"total_price"];
    payVC.orderID =  [diction objectForKey:@"id"];
    [_controller.navigationController pushViewController:payVC animated:YES];
    
}

-(void)deleteOrderWithRow:(NSInteger)row{
    
    NSDictionary * diction = [self.data objectAtIndex:row];

    NSLog(@"===%ld" , row);
    NSString *path = [API_HOST stringByAppendingString:order_cancel];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[diction objectForKey:@"id"] forKey:@"id"];
    //    [diction setObject:@"0" forKey:@"status"];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:dic isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"=取消订单==%@",responseObject );
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadOrderUI" object:nil];

    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"取消订单=code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
}

@end
