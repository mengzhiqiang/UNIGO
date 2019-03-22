//
//  UpdateBabyInformation.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFUpdateBabyInformation.h"
#import "AFCommonEngine.h"
#import "AFCommonEngine.h"
//#import "afcount"
@implementation AFUpdateBabyInformation

#pragma mark - 宝贝信息修改
+ (void )requestPatchWithparams:(NSMutableDictionary *)params
                                       key:(NSString*)key
                                       value:(NSString*)value
                                      success:(HttpSuccessBlock)success
                                      failure:(HttpFailureBlock)failure
{
    NSString *pathUrl = [API_HOST stringByAppendingString:user_update];

    NSDictionary * param = @{key:value};
    
    [HttpEngine requestPostWithURL:pathUrl params:param isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+(NSString*)WithNoting:(NSString*)string{
    
    if (string.length<1) {
        return @"";
    }
    return string ;
}

+(void)saveBabyInformationWithKey:(NSString*)key WithValue:(NSString*)value andOldBabyInfor:(NSMutableDictionary*)babydic{
    
    if ([key isEqualToString:@"alias"]) {
        NSMutableDictionary *dic = [(NSMutableDictionary*)[babydic objectForKey:@"ctx"] mutableCopy];
        [dic setObject:value forKey:@"alias"];
        [babydic setObject:dic forKey:@"ctx"];
    }else{
        [babydic setObject:value forKey:key];
    }
}


@end
