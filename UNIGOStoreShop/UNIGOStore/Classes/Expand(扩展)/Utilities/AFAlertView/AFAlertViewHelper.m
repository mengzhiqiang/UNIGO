//
//  AFAlertViewHelper.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/13.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFAlertViewHelper.h"
#import "Define.h"
#import "UIViewController+Extension.h"
@implementation AFAlertViewHelper

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)controller
               cancelTitle:(NSString *)cancelTitle
                otherTitle:(NSString *)otherTitle
                clickBlock:(ClickBlock)clickBlock
{
    if (IOS_VERSION >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                !clickBlock ? :  clickBlock(0);
            }];
            [alertController addAction:cancelAction];
        }
        
        if (otherTitle.length > 0) {
            UIAlertAction *completeAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                !clickBlock ? :  clickBlock(1);
            }];
            [alertController addAction:completeAction];
        }
        
        if (!controller) {
            controller = [UIViewController getCurrentController];
            if ([controller isKindOfClass:[UIWindow class]]) {
                controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            }
        }
        
        [controller presentViewController:alertController animated:YES completion:nil];
        [self willPresentAlertView:alertController.view];
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = title;
        alertView.message = message;
        if (cancelTitle.length > 0) {
            [alertView addButtonWithTitle:cancelTitle];
        }
        if (otherTitle.length > 0) {
            [alertView addButtonWithTitle:otherTitle];
        }
        
        [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
            !clickBlock ? :  clickBlock(buttonIndex);
        }];
    }

}
+ (void)willPresentAlertView:(UIView *)alertView
{
    
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) view;
            label.textAlignment = UITextAlignmentLeft;
            
        }
    }
}
+(void)settingSuccessWith:(NSString*)title{
    
    UIView* CreenView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-135)/2, 150, 135 , 135)];
    view.backgroundColor =[UIColor HexString:@"728095"];
    [view draCirlywithColor:nil andRadius:10];
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((view.width-55)/2, 23, 55, 55)];
    imageV.image = [UIImage imageNamed:@""];
    [view addSubview:imageV];
    
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, imageV.bottom+10, view.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font =[UIFont systemFontOfSize:16];
    label.textColor =[UIColor whiteColor];
    label.text = @"";
    
    [CreenView addSubview:view];
    
    
}

@end
