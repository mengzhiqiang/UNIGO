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

#pragma mark  调起微信支付
-(void)payOfWXPayReqdata:(NSDictionary *)Dic_data  backResult:(BackBlockResult)backResult{
    
    _backResult = backResult ;
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [NSString stringWithFormat:@"%@",[Dic_data objectForKey:@"partnerid"]];
    request.prepayId= [Dic_data objectForKey:@"prepayid"];
    request.package = [Dic_data objectForKey:@"package"];
    request.nonceStr= [Dic_data objectForKey:@"noncestr"];
    request.timeStamp= (UInt32)[[Dic_data objectForKey:@"timestamp"] intValue];
    request.sign= [Dic_data objectForKey:@"sign"];
    
    if ([WXApi sendReq:request]) {
        NSLog(@"支付中");
    }else{
        NSLog(@"支付调取失败");
    }
    
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (_backResult) {
                    _backResult(@"success");
                }
                break;
                
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                if (_backResult) {
                    _backResult(@"fail");
                }
                break;
        }
        
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
