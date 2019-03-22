//
//  UIView+ResignResponder.h
//  SmartDevice
//
//  Created by singelet on 16/6/28.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ResignResponder)

//处理收回键盘的事件
+ (UIView *)findFirstResponderBeneathView:(UIView*)view;

@end
