//
//  DCorderDetailViewController.m
//  jiefujia
//
//  Created by zhiqiang meng on 8/4/2019.
//  Copyright © 2019 TeeLab. All rights reserved.
//

#import "DCorderDetailStatueViewController.h"
#import "JFJOrderTableViewCell.h"
@interface DCorderDetailStatueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *rootTableView;
@property (strong, nonatomic) IBOutlet UIView *headOrderView;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *footOrderView;

@end

@implementation DCorderDetailStatueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headLabel.text = @"订单详情";
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  64, SCREEN_WIDTH, SCREEN_HEIGHT- 64);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 16 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.backgroundColor=PersonBackGroundColor;
    self.view.backgroundColor=PersonBackGroundColor;
    
    [self.view addSubview:_rootTableView];
    
}

#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return  2;
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
    return 212;
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

@end
