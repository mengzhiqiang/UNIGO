//
//  JFJorderTabelView.m
//  jiefujia
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "JFJorderTabelView.h"
#import "JFJOrderTableViewCell.h"
#import "DCOrderDetailViewController.h"
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
    
    return 130;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"manageTableViewCell";
    
    JFJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JFJOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.stateLabel.text = @"已完成";

    cell.backgroundColor=[UIColor clearColor];
    if ([_orderStyle isEqualToString:@"未支付"]) {
        cell.stateLabel.text = @"未支付";
    }
    if ([_orderStyle isEqualToString:@"全部"]) {
        
        if (indexPath.row==0) {
            cell.stateLabel.text = @"未支付";

        }else if (indexPath.row==1) {
            cell.stateLabel.text = @"进行中";
            
        } else if (indexPath.row==2) {
            cell.stateLabel.text = @"已完成";
            
        }
    }
    if ([_orderStyle isEqualToString:@"退款"]) {
        cell.stateLabel.text = @"退款中";
    }
    
    
    
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
    
    DCOrderDetailViewController * vc = [[DCOrderDetailViewController alloc]init];
    [_controller.navigationController pushViewController:vc animated:YES];
}

-(void)updataData:(NSDictionary* )diction tagre:(UIViewController*)tagre{
    
    
    _controller = tagre;
}

@end
