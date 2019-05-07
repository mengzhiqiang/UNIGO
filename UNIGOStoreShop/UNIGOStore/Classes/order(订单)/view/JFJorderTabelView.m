//
//  JFJorderTabelView.m
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "JFJorderTabelView.h"
#import "JFJOrderTableViewCell.h"

#import "DCorderDetailStatueViewController.h"

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
    
    return 215;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"manageTableViewCell";
    
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.stateLabel.text = @"已完成";
    [cell.oredreImageView setImageWithURL:[NSURL URLWithString:DefaultImage] placeholderImage:nil];
    cell.backgroundColor=[UIColor clearColor];
    cell.payButton.hidden = YES;

    if ([_orderStyle isEqualToString:@"未支付"]) {
        cell.orderStatusLabel.text = @"未支付";
        cell.payButton.hidden = NO;
    }
    if ([_orderStyle isEqualToString:@"全部"]) {
        
        if (indexPath.row==0) {
            cell.orderStatusLabel.text = @"未支付";
            cell.payButton.hidden = NO;

        }else if (indexPath.row==1) {
            cell.orderStatusLabel.text = @"已支付";
            
        } else if (indexPath.row==2) {
            cell.orderStatusLabel.text = @"已完成";
            
        }
    }
    if ([_orderStyle isEqualToString:@"退款"]) {
        cell.orderStatusLabel.text = @"退款中";
    }
    
    if (self.data.count > indexPath.row) {
        NSDictionary * diction = [self.data objectAtIndex:indexPath.row];
        cell.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@", [NSDate timeWithTimeIntervalString: [diction objectForKey:@"create_time"]]];
        cell.goodeTitleLabel.text = [diction objectForKey:@"name"];
        cell.goodsDetailLabel.text = [diction objectForKey:@"spec_name"];
        cell.goodCountLabel.text = [NSString stringWithFormat:@"x%@",[diction objectForKey:@"total_num"]];;
        cell.orderSumLabel.text = [NSString stringWithFormat:@"订单总额 ¥%@",[diction objectForKey:@"total_price"]];;

        int status = [[diction objectForKey:@"status"] intValue];
        
        
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
                cell.orderStatusLabel.text = @"待发货";

            }
                break;
            case 1:
            {
                cell.orderStatusLabel.text = @"已发货";

            }
                break;
            case 2:
            {
                cell.orderStatusLabel.text = @"已收货";

            }
                break;
            case 4:
            {
                cell.orderStatusLabel.text = @"已完成";

            }
                break;
                
            default:
                break;
        }
        
    }
    
    cell.backSelect = ^(NSString * _Nonnull style) {
        
        if ([style isEqualToString:@"pay"]) {
            ///支付
        }else{
            //删除
            [self deleteOrderWithRow:indexPath.row];
        }
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
    
    if ([_orderStyle isEqualToString:@"全部"]) {
        DCorderDetailStatueViewController* statueVC =[[DCorderDetailStatueViewController alloc]init];
        [_controller.navigationController pushViewController:statueVC animated:YES];
        return;
    }
    
}

-(void)updataData:(NSArray* )array tagre:(UIViewController*)tagre{
    
    self.data = array ;
    _controller = tagre;
    
    [self reloadData];
}

-(void)deleteOrderWithRow:(NSInteger)row{
    
    NSLog(@"===%ld" , row);
    
}

@end
