//
//  AFCustomImageAlertView.h
//  AFJiaJiaMob
//
//  Created by mengzhiqiang on 17/2/26.
//  Copyright © 2017年 Auric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCustomImageAlertView : UIView<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (copy, nonatomic) void (^backEnterWechatBlock)();
@property (weak, nonatomic) IBOutlet UILabel *btntitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *pushButton;

-(void)alertViewOfImage:(UIImage*)image title:(NSString*)title subtitle:(NSString*)subtitle buttonTitle:(NSString*)btnTitle;

@end
