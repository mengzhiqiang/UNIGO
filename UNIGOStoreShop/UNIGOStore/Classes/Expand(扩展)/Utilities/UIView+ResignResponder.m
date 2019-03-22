//
//  UIView+ResignResponder.m
//  SmartDevice
//
//  Created by singelet on 16/6/28.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UIView+ResignResponder.h"

@implementation UIView (ResignResponder)

//处理收回键盘的事件
+ (UIView *)findFirstResponderBeneathView:(UIView*)view
{
    for(UIView *childView in view.subviews) {
        if( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if(result) {
            return result;
        }
    }
    return nil;
}

@end
