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
}
@property(strong,nonatomic) UIScrollView * scrollView ;

@end

@implementation DCOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"已支付", @"未支付", @"未评论", @"售后"]];
    [segmentedControl3 setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
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
    CGFloat lisTheight = SCREEN_HEIGHT-tabHeight -50;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabHeight+50, SCREEN_WIDTH, lisTheight)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 200);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, 200) animated:NO];
    [self.view addSubview:self.scrollView];
    
    
    JFJorderTabelView *order0 = [[JFJorderTabelView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, lisTheight)];
    order0.orderStyle = @"全部";
    [order0 updataData:nil tagre:self];

    [self.scrollView addSubview:order0];
    
    JFJorderTabelView *label1 = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, lisTheight)];
    [self.scrollView addSubview:label1];
    
    JFJorderTabelView *label2 = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, lisTheight)];
    label2.orderStyle = @"未支付";
    [self.scrollView addSubview:label2];
    
    JFJorderTabelView *label3 = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, lisTheight)];
    label3.orderStyle = @"未评论";

    [self.scrollView addSubview:label3];
    
    JFJorderTabelView *order1 = [[JFJorderTabelView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, lisTheight)];
    order1.orderStyle = @"退款";
    [order1 updataData:nil tagre:self];
    [self.scrollView addSubview:order1];
    
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
