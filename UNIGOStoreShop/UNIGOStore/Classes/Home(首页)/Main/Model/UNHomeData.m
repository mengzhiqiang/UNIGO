//
//  UNHomeData.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 22/3/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "UNHomeData.h"

@implementation UNHomeData

/* 获取 首页 banner */
+(void)getBanner:(void(^)(id responseObject))success
           error:(void(^)(NSDictionary *error))fail{
    
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        NSString *path = home_banner;
    NSString *path = [API_HOST stringByAppendingString:home_banner];

        [HttpEngine requestGetWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
            success(JSONDic);
            
        } failure:^(NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSDictionary *Dic_data = error.userInfo;
            fail(Dic_data);
        }];
        
    
}

/* 获取 首页 推荐列表 */

+(void)getRecommend:(void(^)(id responseObject))success
              error:(void(^)(NSDictionary *error))fail{
    
    
}

+(void)getGoodDetailWithID:(NSString *)goodID success:(void (^)(id _Nonnull))success error:(void (^)(NSDictionary * _Nonnull))fail{

    NSString *path = [API_HOST stringByAppendingString:goodDetail_get];
    NSDictionary* pram = @{@"id":goodID};
    [HttpEngine requestGetWithURL:path params:pram isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {

        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        success(JSONDic);
        
    } failure:^(NSError *error) {

        NSDictionary *Dic_data = error.userInfo;
        fail(Dic_data);
    }];
    
}
@end
