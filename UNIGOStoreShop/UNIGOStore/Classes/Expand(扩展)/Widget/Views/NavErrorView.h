//
//  NavErrorView.h
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/22.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavErrorView : UIView

@property (nonatomic, strong)   UILabel         *PromptLabelNav;  

+ (id)shareNavErrorView;
-(void)addPromptLabelNav:(NSString*)title;

@end
