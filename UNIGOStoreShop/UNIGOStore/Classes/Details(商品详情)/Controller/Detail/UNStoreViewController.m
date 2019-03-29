//
//  UNStoreViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 19/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "UNStoreViewController.h"

@interface UNStoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *campayName;
@property (weak, nonatomic) IBOutlet UILabel *campayType;
@property (weak, nonatomic) IBOutlet UILabel *campayManage;

@end

@implementation UNStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headLabel.text = @"店铺信息";
    
//    [self getStroeInfo];
}


-(void)getStroeInfo{
    
    NSString *path = [API_HOST stringByAppendingString:siteInfo_get];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [HttpEngine requestGetWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        [self relaodUI:JSONDic];
        NSLog(@"===%@",responseObject );
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        
        int code=[[Dic_data objectForKey:@"status"] intValue];
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        
    }];
    
}


-(void)relaodUI:(NSDictionary*)Diction{
    
    _campayName.text = [Diction objectForKey:@"name"];
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
