//
//  UpdateBabyInformation.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 16/7/21.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UpdateBabySuccessBlock)(id responseObject);
typedef void (^UpdateBabyFailureBlock)(NSError *error);


NS_ENUM(NSInteger){
    
    UpdateBabyAliasItemTag = 1,
    UpdateBabyDodItemTag ,
    UpdateBabySexItemTag,
    UpdateBabyNicknameItemTag,

};

@interface AFUpdateBabyInformation : NSObject


#pragma mark - 宝贝信息修改
+ (void )requestPatchWithparams:(NSMutableDictionary *)params
                            key:(NSString*)key
                          value:(NSString*)value
                        success:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure;

+ (void )GetRobtos:(NSMutableDictionary *)params
                        success:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure;



@end







