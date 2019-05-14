//
//  DCOrderListViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 30/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCOrderListViewController.h"
#import "HMSegmentedControl.h"
#import "JFJorderTabelView.h"
#import "DCOrderDetailViewController.h"
@interface DCOrderListViewController ()<UIScrollViewDelegate>
{
    HMSegmentedControl * segmentedControl3 ;
    
    JFJorderTabelView *order_all;
    JFJorderTabelView *order_NoPay;     //未支付
    JFJorderTabelView *order_stayGoods;  //未发货
    JFJorderTabelView *order_deliverGoods;  //已发货
    JFJorderTabelView *order_over;   //已完成

}
@property(strong,nonatomic) UIScrollView * scrollView ;


@property(assign,nonatomic) int  orderStatus ;

@end

@implementation DCOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"未支付",@"待发货", @"已发货", @"已完成"]];
    [segmentedControl3 setFrame:CGRectMake(0, DCTopNavH, SCREEN_WIDTH, 50)];
    __weak typeof(self) weakSelf = self;
    [segmentedControl3 setIndexChangeBlock:^(NSInteger index) {
        
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 200) animated:YES];
    }];
    segmentedControl3.selectionIndicatorHeight = 4.0f;
    segmentedControl3.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    
    segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl3.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    //    segmentedControl3.selectionIndicatorBoxColor = [UIColor grayColor];
    //    segmentedControl3.verticalDividerColor = [UIColor redColor];
    //    segmentedControl3.borderColor = [UIColor orangeColor];
    
    segmentedControl3.selectionIndicatorBoxOpacity = 1.0;
    segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl3.selectedSegmentIndex = HMSegmentedControlNoSegment;
    segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl3.shouldAnimateUserSelection = NO;
    segmentedControl3.tag = 2;
    [segmentedControl3 setSelectedSegmentIndex:0];
    [self.view addSubview:segmentedControl3];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat lisTheight = SCREEN_HEIGHT-DCTopNavH -50;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DCTopNavH+50, SCREEN_WIDTH, lisTheight)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, lisTheight);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    
    
    order_all = [[JFJorderTabelView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, lisTheight)];
    order_all.orderStyle = @"全部";
    [order_all updataData:nil tagre:self];

    [self.scrollView addSubview:order_all];
    
    order_NoPay = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, lisTheight)];
    order_NoPay.orderStyle = @"未支付";
    [self.scrollView addSubview:order_NoPay];
    
    order_stayGoods = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, lisTheight)];
    [self.scrollView addSubview:order_stayGoods];
    
    order_deliverGoods= [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, lisTheight)];
    order_deliverGoods.orderStyle = @"已发货";
    [self.scrollView addSubview:order_deliverGoods];
    
    order_over= [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, lisTheight)];
    order_over.orderStyle = @"已完成";
    [self.scrollView addSubview:order_over];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetAllOrder];
}

#pragma mark 订单
-(void)GetAllOrder{
    NSString *path = [API_HOST stringByAppendingString:order_lists];
//    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
//    [diction setObject:@"1" forKey:@"pay_status"];
//    [diction setObject:@"0" forKey:@"status"];
    WEAKSELF
    [HttpEngine requestPostWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"=订单==%@",JSONDic );
        [order_all updataData:JSONDic tagre:self];

    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"订单=code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
    }];
    
}

-(void)loadUIView:(NSArray*)orderArray{
    
    
    for (NSDictionary*diction in orderArray) {
    
        int status = [[diction objectForKey:@"status"] intValue];
        int pay_status = [[diction objectForKey:@"pay_status"] intValue];
        
//        if (pay_status) {
//            <#statements#>
//        }
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

@end
