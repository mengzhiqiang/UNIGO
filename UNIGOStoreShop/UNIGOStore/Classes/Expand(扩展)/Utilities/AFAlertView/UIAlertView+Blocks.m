
//
//  UIAlertView+Blocks.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/13.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static char CompleteBlockKey;

@implementation UIAlertView (Blocks)


- (void)showAlertViewWithBlock:(CompleteBlock)complete
{
    if (complete) {
        objc_setAssociatedObject(self, &CompleteBlockKey, complete, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CompleteBlock block = objc_getAssociatedObject(self, &CompleteBlockKey);
    objc_removeAssociatedObjects(self);
    if (block) {
        block(buttonIndex);
    }
}

@end
