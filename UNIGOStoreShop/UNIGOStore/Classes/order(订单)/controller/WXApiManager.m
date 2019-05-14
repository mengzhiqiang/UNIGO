//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"温馨提示"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        [UIHelper alertWithTitle:@"温馨提示" WithMsg:strMsg delegate:self.payController BtnTitle:@"确定" otherTitle:nil andTag:100 backHander:^{
            
            UIViewController * viewVC = self.payController.navigationController.viewControllers.firstObject;
            [self.payController.navigationController popToRootViewControllerAnimated:NO];
            [viewVC.navigationController pushViewController:self.payStatusController animated:YES];
        } otherHander:^{
            
        }];
        
      
        
    }else {
    }
}

- (void)onReq:(BaseReq *)req {

}

-(void)setPayControll:(UIViewController*)payVC WithStatusVC:(UIViewController*)StatusVC{
    
//    self.navigationController = payVC.navigationController;
    self.payController = payVC;
    self.payStatusController = StatusVC;
    
}
@end
