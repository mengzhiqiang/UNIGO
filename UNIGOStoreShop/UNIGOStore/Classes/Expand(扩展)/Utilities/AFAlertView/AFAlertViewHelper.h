//
//  AFAlertViewHelper.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/13.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+Blocks.h"


typedef void(^ClickBlock)(NSInteger buttonIndex);

@interface AFAlertViewHelper : NSObject

/**
 *  弹框 AlertView
 *
 *  @param title       标题
 *  @param message     提示语
 *  @param controller  代理
 *  @param cancelTitle 取消按钮标题
 *  @param otherTitle  确定按钮标题
 *  @param clickBlock  block回调
 */

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)controller
               cancelTitle:(NSString *)cancelTitle
                otherTitle:(NSString *)otherTitle
                clickBlock:(ClickBlock)clickBlock;

@end
