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
    
    return  5;
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

-(void)updataData:(NSDictionary* )diction tagre:(UIViewController*)tagre{
    
    
    _controller = tagre;
}

-(void)deleteOrderWithRow:(NSInteger)row{
    
    NSLog(@"===%ld" , row);
    
}

@end
