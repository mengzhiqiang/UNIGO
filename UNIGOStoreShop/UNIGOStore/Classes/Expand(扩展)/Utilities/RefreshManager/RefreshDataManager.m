//
//  RefreshDataManager.m
//  CompareTimeDemo
//
//  Created by admin on 16/6/1.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "RefreshDataManager.h"
#import "NSDate+Extension.h"

@implementation RefreshDataManager
+ (RefreshDataManager *)sharedManager
{
    static RefreshDataManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (BOOL)needRefreshData:(NSString *)recordDate {
   return [[RefreshDataManager sharedManager]needRefreshData:recordDate];
}
- (BOOL)needRefreshData:(NSString *)recordDate {
    //获取到时间
    if (recordDate.length > 0) {

        if ([NSDate compareDataTime:recordDate]) {//相差6小时
           return YES;
        }else {
            NSLog(@"相差不足6小时，无需刷新");
            return NO;
        }

    }else {
        NSLog(@"没有时间记录");
        return NO;
    }

}

@end
