//
//  AFCustomImageAlertView.m
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 17/2/26.
//  Copyright © 2017年 Auric. All rights reserved.
//

#import "AFCustomImageAlertView.h"
#import "AFPhotoAlbumHelper.h"
@implementation AFCustomImageAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//

}
*/
-(void)setRootFrame{

//    [_rootView draCirlywithColor:nil andRadius:10.0];
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
   
    if ((iPhone5 || isPAD_or_IPONE4)) {
        _rootView.frame= CGRectMake((SCREEN_WIDTH-280*RATIO)/2, 114, 280*RATIO, 400*RATIO);
        _alertImageView.frame = CGRectMake(46*RATIO, 108*RATIO, 208*RATIO, 208*RATIO);
        _titlelabel.top = 24*RATIO;
        _subTitleLabel.top = 56*RATIO;

    }else{
        _rootView.frame= CGRectMake((SCREEN_WIDTH-300)/2, 134, 300, 400);

    }
    _NextButton.frame = CGRectMake(0, _rootView.height-50-13, _rootView.width, 50);
    _pushButton.frame = CGRectMake(0, _rootView.height-50-13, _rootView.width, 50);
    _pushButton.hidden=YES;
    UIView * screenView=[[UIView alloc]initWithFrame:self.bounds];
    screenView.backgroundColor=[UIColor clearColor];
    [self addSubview:screenView];
    [self sendSubviewToBack:screenView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    tapGestureRecognizer.delegate = self;
    [screenView addGestureRecognizer:tapGestureRecognizer];
}
-(void)hideKeyBoard{
    self.hidden=YES;
}
-(void)alertViewOfImage:(UIImage*)image title:(NSString*)title subtitle:(NSString*)subtitle buttonTitle:(NSString*)btnTitle{

    [self setRootFrame];
    
    if (image) {
        _alertImageView.backgroundColor=[UIColor whiteColor];
        _alertImageView.image = image;
        _titlelabel.text = title;
        _subTitleLabel.text = subtitle;
        
        if ([btnTitle isEqualToString:@"打开微信"]) {
            _NextButton.hidden=YES;
            _pushButton.hidden=NO;

        }else{
            _NextButton.hidden=NO;
            _pushButton.hidden=YES;

        }

    }

}
- (IBAction)hiddenView:(UIButton *)sender {
    
    if ([_titlelabel.text isEqualToString:@"保存成功"]) {
        self.hidden=YES;
        _backEnterWechatBlock();
        return;
    }
    
    [self loadImageFinished:[UIImage imageNamed:@"img_code"]];
}

- (void)loadImageFinished:(UIImage *)image
{
     [AFPhotoAlbumHelper checkSystempPhotoAlbumPermissionWithCallBack:^(NSInteger index) {
         
         if (index == 0 ) {
              UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
         }else if (index == 10 ){
             self.hidden=YES;
         }
     }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    [self changeImage];
}

-(void)changeImage{
    self.hidden=NO;
    [self alertViewOfImage:[UIImage imageNamed:@"img_wechat"] title:@"保存成功" subtitle:@"微信扫一扫 → 相册 → 选择二维码" buttonTitle:@"打开微信"];
}

@end
