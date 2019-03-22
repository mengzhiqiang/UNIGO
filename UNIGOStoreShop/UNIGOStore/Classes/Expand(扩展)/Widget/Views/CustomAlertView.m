//
//  CustomAlertView.m
//  ALPHA
//
//  Created by teelab2 on 15/1/12.
//  Copyright (c) 2015年 ALPHA. All rights reserved.
//

#import "CustomAlertView.h"
#import "ExtendClass.h"
#import "Define.h"
#import "CommonVariable.h"


@implementation CustomAlertView


static CustomAlertView *alert = nil;


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        

        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.frame=CGRectMake((frame.size.width-95)/2, (frame.size.height-20)/2-25, 95, 42.5);
        _gifImageView.animationImages=[[CommonVariable  shareCommonVariable] LoadImage_Array];
        _gifImageView.animationDuration=2;
        _gifImageView.animationRepeatCount=0;
//
        [_gifImageView startAnimating];
        [self addSubview:_gifImageView];
        
        
        self.activityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        self.activityView.frame=CGRectMake((frame.size.width-80)/2, (frame.size.height-80)/2-25, 80, 80);

//        self.activityView.center=self.center;
        [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.activityView setBackgroundColor:[UIColor lightGrayColor]];
        
        self.activityView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
//        [self addSubview:self.activityView];
//        [self.activityView startAnimating];
        
        [self drawImageRound:self.activityView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(0, 60, 80, 20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"正在加载...";
        _titleLabel.font = [UIFont systemFontOfSize:10];
        [self.activityView addSubview:_titleLabel];
        _titleLabel.hidden=YES;
        
        self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.9] ;
    }
    
    return self;
}

-(void)drawImageRound :(UIView *)view{
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    
}

-(void)backGrondColor:(UIColor*)col{
    self.backgroundColor=col ;

}

/**************************************************************
 ** 功能:     弹框
 ** 参数:     无
 ** 返回:     commonvariable对象
 **************************************************************/
+ (id)shareCustom{
    
    if (!alert) {
        alert = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    return alert;
}

-(void)setGitImageFrame:(int)height{

    _activityView.frame=CGRectMake((SCREEN_WIDTH-80)/2, (SCREEN_HEIGHT-80)/2-height, 80, 80);

}

-(void)hiddenAlertView{
    
    [_gifImageView stopAnimating];
    [self setHidden:YES];
    
    [self.activityView stopAnimating];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
