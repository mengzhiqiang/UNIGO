//
//  NavErrorView.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/22.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "NavErrorView.h"
#import "Define.h"
#import "ExtendClass.h"
static NavErrorView *navE = nil;

@implementation NavErrorView

+(id)shareNavErrorView{
    if (!navE) {
        navE = [[NavErrorView alloc] init];
        navE.frame= CGRectMake(0, 31, SCREEN_WIDTH, 33);
        navE.backgroundColor=[[UIColor grayColor] colorWithHexString:@"ff999a"];
    
        
    }
    return navE;
}

-(void)addPromptLabelNav:(NSString*)title{
    
    if (!self.PromptLabelNav) {
        self.PromptLabelNav=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 23)];
        [navE addSubview:_PromptLabelNav];
        _PromptLabelNav.text = @"错误提示";
        _PromptLabelNav.textAlignment = NSTextAlignmentCenter;
        _PromptLabelNav.font = [UIFont systemFontOfSize:15];
        _PromptLabelNav.textColor=[UIColor whiteColor];
    }
 
    _PromptLabelNav.text = title;

    
}

@end
