//
//  GoodsRequestTool.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 24/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "GoodsRequestTool.h"

@implementation GoodsRequestTool

+(void)getGoodsCate:(void(^)(id responseObject))success  {
    
    NSString *path = [API_HOST stringByAppendingString:goodsCate_get];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        success(JSONDic);
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        
    }];
    
}

+(void)getGoodsCateWithPram:(NSDictionary*)pram
                    success:(void(^)(id responseObject))success
                       fail:(void (^)(NSDictionary*error))error{
    
    NSString *path = [API_HOST stringByAppendingString:goodsList_get];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [HttpEngine requestPostWithURL:path params:pram isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        success(JSONDic);
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        
    }];
    
    
}
@end
