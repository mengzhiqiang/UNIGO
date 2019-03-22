//
//  UIViewController+NavnationBar.m
//  SmartDevice
//
//  Created by mengzhiqiang on 16/6/22.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UIViewController+navigationBar.h"
#import "Define.h"
#import "ExtendClass.h"
#import "UIHelper.h"
#import "LogInmainViewController.h"
#import "NavErrorView.h"
@implementation UIViewController (navigationBar)

/**************************************************************
 ** 功能:     定制navigation bar  二级界面
 ** 参数:     nsstring（标题）、id（目标对象）
 ** 返回:     uiview
 **************************************************************/
-(void)headerViewWithTitle:(NSString*)title target:(id)sender {
    
    UIImageView*_HeadView = [[UIImageView alloc] init] ;
    
    CGFloat  headHight = 64;
    
    if (iPhoneX) {
        headHight = 86;
    }

    _HeadView.frame = CGRectMake(0,0, SCREEN_WIDTH, headHight) ;
    _HeadView.userInteractionEnabled = YES;
    [_HeadView setBackgroundColor:[[UIColor clearColor] colorWithHexString:@"ffffff"]];
    //    _HeadView.image=[UIImage imageNamed:@"mainHead.png"];
    _HeadView.contentMode= UIViewContentModeScaleToFill;
    _HeadView.clipsToBounds=NO;
    
    float  LandscapeHight = 24;
    if (iPhoneX) {
        LandscapeHight = 24+20;
    }

    UIColor *color_title=[UIColor HexString:@"353535"];
    /////nav 左边按钮
    UIButton* _headLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView*_headimageView=[[UIImageView  alloc]initWithFrame:CGRectMake(11.5, 12, 20, 20)];
    _headimageView.image=[UIImage imageNamed:@"main_btn_back_normal"];
        //    _headimageView.backgroundColor=[UIColor greenColor];
    [_headLeftButton addSubview:_headimageView];

    [_headLeftButton addTarget:sender action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headLeftButton setFrame:CGRectMake(0, LandscapeHight, 50, 40)];
    
    CGFloat wight = 200;
    if (isPAD_or_IPONE4||iPhone5) {
        wight = 160 ;
    }
    UILabel*_headLabel= [[UILabel alloc] init];

    [_headLabel setFrame:CGRectMake((SCREEN_WIDTH - wight)/2, LandscapeHight,wight, 40)];
    _headLabel.backgroundColor = [UIColor clearColor];
    _headLabel.textAlignment=NSTextAlignmentCenter;
    
    _headLabel.font = [UIFont systemFontOfSize:17];
    
    //    if (IOS_VERSION>=8.0) {
    //        _headLabel.font = [UIFont systemFontOfSize:17 weight:10];
    //    }
    
    _headLabel.text = title;
    _headLabel.textColor = color_title;
    [_HeadView addSubview:_headLabel];
    
    /////nav 右边按钮     /////右边按钮
       UIButton* _headMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [_headMessageButton addTarget:sender action:@selector(RightMessageOfTableView) forControlEvents:UIControlEventTouchUpInside];
    _headMessageButton.frame=CGRectMake(SCREEN_WIDTH-72, LandscapeHight, 70, 40);
    _headMessageButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [_headMessageButton setTitleColor: [UIColor HexString:@"000000"] forState:UIControlStateNormal];
    _headMessageButton.hidden=YES;

    [_HeadView addSubview:_headMessageButton  ];

    [_HeadView addSubview:_headLeftButton];
    
    [self.view  insertSubview:_HeadView atIndex:100];
    
}

#pragma mark 错误提示信息
-(BOOL)TitleMessage:(NSDictionary *)Dic_data{
    
    int code=[[Dic_data objectForKey:@"status_code"] intValue];
    
    if (code == 422) {
        
        NSString *str_error = [[[Dic_data objectForKey:@"errors"] allKeys] objectAtIndex:0] ;
        NSLog(@"code==%@",[[[Dic_data objectForKey:@"errors"] objectForKey:str_error] objectAtIndex:0]);
        [self promtNavHidden:[[[Dic_data objectForKey:@"errors"] objectForKey:str_error] objectAtIndex:0]];
        return NO;
    }
    if (code == 100) {
        NSLog(@"message==%@",[Dic_data objectForKey:@"message"]);
        [self promtNavHidden:[Dic_data objectForKey:@"message"]];
        return NO;
    }
    
    if ([[Dic_data objectForKey:@"message"] isEqualToString:@"token_invalid"]||[[Dic_data objectForKey:@"message"] isEqualToString:@"token_expired"]) {
        ////token已失效 需要重新登录
        
//        [UIHelper alertWithTitle:@"登录已失效，请重新登录！"];
        [UIHelper showUpMessage:@"登录已失效，请重新登录！"];

        LogInmainViewController *login = [[LogInmainViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    
    return YES;
}
#pragma mark  顶栏错误提示
-(void)promtNavHidden:(NSString*)title{
    
    if (title.length<1) {
        title = @"网络异常";
    }
    
    NavErrorView* _PromptLabel_Nav =[NavErrorView shareNavErrorView];
    
    [_PromptLabel_Nav addPromptLabelNav:title];
    _PromptLabel_Nav.hidden=NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _PromptLabel_Nav.frame = CGRectMake(0, 64, SCREEN_WIDTH, 33);
        
    }];
    [self.view addSubview:_PromptLabel_Nav];
    [self.view insertSubview:_PromptLabel_Nav atIndex:1];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            _PromptLabel_Nav.frame = CGRectMake(0, 31, SCREEN_WIDTH, 33);
        }];
        
    });
    
}

#pragma mark 左边按钮
-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 右边按钮
- (void)RightBtnClicked
{
    
}


@end
