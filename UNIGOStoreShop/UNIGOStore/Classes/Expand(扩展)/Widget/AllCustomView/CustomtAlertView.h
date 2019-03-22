//
//  CustomtAlertView.h
//  SmartDevice
//
//  Created by mengzhiqiang on 17/3/14.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomtAlertView : UIView


+ (CustomtAlertView*)sharedView;

-(void)settingSuccessWith:(NSString*)title;

-(void)settingFailWith:(NSString*)title ;

@end
