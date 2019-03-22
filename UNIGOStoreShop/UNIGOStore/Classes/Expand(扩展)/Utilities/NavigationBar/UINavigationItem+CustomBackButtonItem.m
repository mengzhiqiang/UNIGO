//
//  UINavigationItem+CustomBackButtonItem.m
//  SmartDevice
//
//  Created by singelet on 16/6/23.
//  Copyright © 2016年 ALPHA. All rights reserved.
//

#import "UINavigationItem+CustomBackButtonItem.h"
#import <objc/runtime.h>

@implementation UINavigationItem (CustomBackButtonItem)

+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
//        
//        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButtonItem_backBarbuttonItem));
//        method_exchangeImplementations(originalMethodImp, destMethodImp);
//    });
//    
    // another way
//    UIImage *backButtonImage = [[UIImage imageNamed:@"main_btn_back_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
////    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
}

static char kCustomBackButtonItemKey;
- (UIBarButtonItem *)myCustomBackButtonItem_backBarbuttonItem{
    UIBarButtonItem *item = [self myCustomBackButtonItem_backBarbuttonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonItemKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        item.tintColor = [UIColor whiteColor];
        objc_setAssociatedObject(self, &kCustomBackButtonItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}


@end
