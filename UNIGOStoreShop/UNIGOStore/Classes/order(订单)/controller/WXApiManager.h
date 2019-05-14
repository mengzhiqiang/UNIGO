//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional


@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

@property (nonatomic, strong) UIViewController * payController;
@property (nonatomic, strong) UINavigationController * navigationController;

@property (nonatomic, strong) UIViewController * payStatusController;


+ (instancetype)sharedManager;


-(void)setPayControll:(UIViewController*)payVC WithStatusVC:(UIViewController*)StatusVC;
@end
