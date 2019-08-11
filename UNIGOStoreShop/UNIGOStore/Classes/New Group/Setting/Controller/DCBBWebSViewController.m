//
//  DCBBWebSViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 7/8/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCBBWebSViewController.h"
#import "DCNewWebViewController.h"
@interface DCBBWebSViewController ()

@end

@implementation DCBBWebSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DCNewWebViewController * newWeb = [[DCNewWebViewController alloc]init];
    newWeb.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50-iphoneXTabbarHieght);
    [self addChildViewController:newWeb];
    [self.view addSubview:newWeb.view];
    
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
