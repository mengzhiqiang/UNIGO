//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef void (^BackBlockResult)(NSString *result);


@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, strong) UIViewController * payController;
@property (nonatomic, strong) UINavigationController * navigationController;

@property (nonatomic, strong) UIViewController * payStatusController;

@property (nonatomic, copy) BackBlockResult backResult;

+ (instancetype)sharedManager;


-(void)setPayControll:(UIViewController*)payVC WithStatusVC:(UIViewController*)StatusVC;

-(void)payOfWXPayReqdata:(NSDictionary *)Dic_data  backResult:(BackBlockResult)backResult;

@end
