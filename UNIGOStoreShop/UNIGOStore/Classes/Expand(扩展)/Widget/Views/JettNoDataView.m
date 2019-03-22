//
//  JettNoDataView.m
//  SmartDevice
//
//  Created by zhiqiang meng on 2017/12/30.
//  Copyright © 2017年 TeeLab. All rights reserved.
//

#import "JettNoDataView.h"

@implementation JettNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
-(void)addNoDataImageView:(ClickRefreshBlock)BackRefresh{
    //
    if (!_rootView) {
        
        _rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 400)];
        [self addSubview:_rootView];
        
        _bg_imageView=[[UIImageView alloc]init];
        _bg_imageView.frame = CGRectMake((SCREEN_WIDTH-250*RATIO)/2, 10, 250*RATIO, 250*RATIO);
        _bg_imageView.image =[UIImage imageNamed:@"img_step3"];
        [_rootView addSubview:_bg_imageView];
        
        UILabel  *noDateLabel=[[UILabel alloc]init];
        noDateLabel.frame = CGRectMake(50, CGRectGetMaxY(_bg_imageView.frame)+10, SCREEN_WIDTH-100, 20);
        noDateLabel.text = @"喔噢！您的网络好像有问题...";
        noDateLabel.font =[UIFont boldSystemFontOfSize:15];
        noDateLabel.textColor = [[UIColor grayColor]colorWithHexString:@"7d8699"];
        noDateLabel.textAlignment =NSTextAlignmentCenter;
        [_rootView addSubview:noDateLabel];
        
        UIButton *btn =[ UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, _bg_imageView.bottom+57, SCREEN_WIDTH-50, ((SCREEN_WIDTH-50)/270)*44);
        [btn setTitle:@"刷新试试" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor HexString:NormalColor] forState:UIControlStateNormal];
        [btn draCirlywithColor:[UIColor HexString:NormalColor] andRadius:btn.height/2];
        [_rootView addSubview:btn];
        
        _rootView.height = btn.bottom +20;
        
    }
    _clikRefresh = BackRefresh ;
    _rootView.hidden=NO;
}

-(void)refresh{
    NSLog(@"==refresh===");
    
   _clikRefresh();
    
}

@end
