//
//  UIAlertView+Blocks.h
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/13.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(NSInteger buttonIndex);

@interface UIAlertView (Blocks)

- (void)showAlertViewWithBlock:(CompleteBlock)complete;


@end
